//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

public enum ParametersError: Error {
  case invalidSyntax(value: Any)
  case invalidKey(key: String, value: Any)
  case invalidStructure(key: String, oldValue: Any, newValue: Any)
}

public enum Parameters {
  typealias Parameter = (key: String, value: Any)
  public typealias StringDict = [String: Any]

  public static func parse(items: [String]) throws -> StringDict {
    let parameters: [Parameter] = try items.map { item in
      let parts = item.components(separatedBy: "=")
      if parts.count >= 2 {
        return (key: parts[0], value: parts.dropFirst().joined(separator: "="))
      } else if let part = parts.first, parts.count == 1 && validate(key: part) {
        return (key: part, value: true)
      } else {
        throw ParametersError.invalidSyntax(value: item)
      }
    }

    return try parameters.reduce(StringDict()) {
      try parse(parameter: $1, result: $0)
    }
  }

  private static func parse(parameter: Parameter, result: StringDict) throws -> StringDict {
    let parts = parameter.key.components(separatedBy: ".")
    let key = parts.first ?? ""
    var result = result

    // validate key
    guard validate(key: key) else { throw ParametersError.invalidKey(key: parameter.key, value: parameter.value) }

    // no sub keys, may need to convert to array if repeat key if possible
    if parts.count == 1 {
      if let current = result[key] as? [Any] {
        result[key] = current + [parameter.value]
      } else if let current = result[key] as? String {
        result[key] = [current, parameter.value]
      } else if let current = result[key] {
        throw ParametersError.invalidStructure(key: key, oldValue: current, newValue: parameter.value)
      } else {
        result[key] = parameter.value
      }
    } else if parts.count > 1 {
      guard result[key] is StringDict || result[key] == nil else {
        throw ParametersError.invalidStructure(key: key, oldValue: result[key] ?? "", newValue: parameter.value)
      }

      // recurse into sub keys
      let current = result[key] as? StringDict ?? StringDict()
      let sub = (key: parts.suffix(from: 1).joined(separator: "."), value: parameter.value)
      result[key] = try parse(parameter: sub, result: current)
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
}
