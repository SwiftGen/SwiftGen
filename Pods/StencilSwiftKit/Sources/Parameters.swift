//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/// Namespace to handle extra context parameters passed as a list of `foo=bar` strings.
/// Typically used when parsing command-line arguments one by one
/// (like `foo=bar pt.x=1 pt.y=2 values=1 values=2 values=3 flag`)
/// to turn them into a dictionary structure
public enum Parameters {
  public enum Error: Swift.Error {
    case invalidSyntax(value: Any)
    case invalidKey(key: String, value: Any)
    case invalidStructure(key: String, oldValue: Any, newValue: Any)
  }

  typealias Parameter = (key: String, value: Any)
  public typealias StringDict = [String: Any]

  /// Transforms a list of strings representing structured-key/value pairs, like
  /// `["pt.x=1", "pt.y=2", "values=1", "values=2", "values=3", "flag"]`
  /// into a structured dictionary.
  ///
  /// - Parameter items: The list of `k=v`-style Strings, each string
  ///                    representing either a `key=value` pair or a
  ///                    single `flag` key with no `=` (which will then
  ///                    be interpreted as a `true` value)
  /// - Returns: A structured dictionary matching the list of keys
  /// - Throws: `Parameters.Error`
  public static func parse(items: [String]) throws -> StringDict {
    let parameters: [Parameter] = try items.map(createParameter)
    return try parameters.reduce(StringDict()) {
      try parse(parameter: $1, result: $0)
    }
  }

  // MARK: - Private methods

  /// Parse a single `key=value` (or `key`) string and inserts it into
  /// an existing StringDict dictionary being built.
  ///
  /// - Parameters:
  ///   - parameter: The parameter/string (key/value pair) to parse
  ///   - result: The dictionary currently being built and to which to add the value
  /// - Returns: The new content of the dictionary being built after inserting the new parsed value
  /// - Throws: `Parameters.Error`
  private static func parse(parameter: Parameter, result: StringDict) throws -> StringDict {
    let parts = parameter.key.components(separatedBy: ".")
    let key = parts.first ?? ""

    // validate key
    guard validate(key: key) else { throw Error.invalidKey(key: parameter.key, value: parameter.value) }

    // no sub keys, may need to convert to array if repeat key if possible
    if parts.count == 1 {
      return try parse(key: key, parameter: parameter, result: result)
    }

    guard result[key] is StringDict || result[key] == nil else {
      throw Error.invalidStructure(key: key, oldValue: result[key] ?? "", newValue: parameter.value)
    }

    // recurse into sub keys
    var result = result
    let current = result[key] as? StringDict ?? StringDict()
    let sub = (key: parts.suffix(from: 1).joined(separator: "."), value: parameter.value)
    result[key] = try parse(parameter: sub, result: current)
    return result
  }

  /// Parse a single `key=value` (or `key`) string and inserts it into
  /// an existing StringDict dictionary being built.
  ///
  /// - Parameters:
  ///   - parameter: The parameter/string (key/value pair) to parse, where key doesn't have sub keys
  ///   - result: The dictionary currently being built and to which to add the value
  /// - Returns: The new content of the dictionary being built after inserting the new parsed value
  /// - Throws: `Parameters.Error`
  private static func parse(key: String, parameter: Parameter, result: StringDict) throws -> StringDict {
    var result = result
    if let current = result[key] as? [Any] {
      result[key] = current + [parameter.value]
    } else if let current = result[key] as? String {
      result[key] = [current, parameter.value]
    } else if let current = result[key] {
      throw Error.invalidStructure(key: key, oldValue: current, newValue: parameter.value)
    } else {
      result[key] = parameter.value
    }
    return result
  }

  // a valid key is not empty and only alphanumerical or dot
  private static func validate(key: String) -> Bool {
    return !key.isEmpty &&
      key.rangeOfCharacter(from: notAlphanumericsAndDot) == nil
  }

  private static let notAlphanumericsAndDot: CharacterSet = {
    var result = CharacterSet.alphanumerics
    result.insert(".")
    return result.inverted
  }()

  private static func createParameter(from string: String) throws -> Parameter {
    let parts = string.components(separatedBy: "=")
    if parts.count >= 2 {
      return (key: parts[0], value: parts.dropFirst().joined(separator: "="))
    } else if let part = parts.first, parts.count == 1 && validate(key: part) {
      return (key: part, value: true)
    } else {
      throw Error.invalidSyntax(value: string)
    }
  }
}
