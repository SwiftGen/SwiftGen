//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

extension Filters.Strings {
  /// Lowers the first letter of the string
  /// e.g. "People picker" gives "people picker", "Sports Stats" gives "sports Stats"
  static func lowerFirstLetter(_ value: Any?) throws -> Any? {
    let string = try Filters.parseString(from: value)
    let first = String(string.characters.prefix(1)).lowercased()
    let other = String(string.characters.dropFirst(1))
    return first + other
  }

  /// If the string starts with only one uppercase letter, lowercase that first letter
  /// If the string starts with multiple uppercase letters, lowercase those first letters
  /// up to the one before the last uppercase one, but only if the last one is followed by
  /// a lowercase character.
  /// e.g. "PeoplePicker" gives "peoplePicker" but "URLChooser" gives "urlChooser"
  static func lowerFirstWord(_ value: Any?) throws -> Any? {
    let string = try Filters.parseString(from: value)
    let cs = CharacterSet.uppercaseLetters
    let scalars = string.unicodeScalars
    let start = scalars.startIndex
    var idx = start
    while let scalar = UnicodeScalar(scalars[idx].value), cs.contains(scalar) && idx <= scalars.endIndex {
        idx = scalars.index(after: idx)
    }
    if idx > scalars.index(after: start) && idx < scalars.endIndex,
        let scalar = UnicodeScalar(scalars[idx].value),
        CharacterSet.lowercaseLetters.contains(scalar) {
        idx = scalars.index(before: idx)
    }
    let transformed = String(scalars[start..<idx]).lowercased() + String(scalars[idx..<scalars.endIndex])
    return transformed
  }

  /// Uppers the first letter of the string
  /// e.g. "people picker" gives "People picker", "sports Stats" gives "Sports Stats"
  ///
  /// - Parameters:
  ///   - value: the value to uppercase first letter of
  ///   - arguments: the arguments to the function; expecting zero
  /// - Returns: the string with first letter being uppercased
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
  static func upperFirstLetter(_ value: Any?) throws -> Any? {
    let string = try Filters.parseString(from: value)
    return upperFirstLetter(string)
  }

  /// Converts snake_case to camelCase. Takes an optional Bool argument for removing any resulting
  /// leading '_' characters, which defaults to false
  ///
  /// - Parameters:
  ///   - value: the value to be processed
  ///   - arguments: the arguments to the function; expecting zero or one boolean argument
  /// - Returns: the camel case string
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
  static func snakeToCamelCase(_ value: Any?, arguments: [Any?]) throws -> Any? {
    let stripLeading = try Filters.parseBool(from: arguments, required: false) ?? false
    let string = try Filters.parseString(from: value)

    return try snakeToCamelCase(string, stripLeading: stripLeading)
  }

  /// Converts camelCase to snake_case. Takes an optional Bool argument for making the string lower case,
  /// which defaults to true
  ///
  /// - Parameters:
  ///   - value: the value to be processed
  ///   - arguments: the arguments to the function; expecting zero or one boolean argument
  /// - Returns: the snake case string
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
  static func camelToSnakeCase(_ value: Any?, arguments: [Any?]) throws -> Any? {
    let toLower = try Filters.parseBool(from: arguments, required: false) ?? true
    let string = try Filters.parseString(from: value)
    let snakeCase = try snakecase(string)
    if toLower {
        return snakeCase.lowercased()
    }
    return snakeCase
  }

  /// Converts snake_case to camelCase, stripping prefix underscores if needed
  ///
  /// - Parameters:
  ///   - string: the value to be processed
  ///   - stripLeading: if false, will preserve leading underscores
  /// - Returns: the camel case string
  static func snakeToCamelCase(_ string: String, stripLeading: Bool) throws -> String {
    let unprefixed: String
    if try containsAnyLowercasedChar(string) {
        let comps = string.components(separatedBy: "_")
        unprefixed = comps.map { upperFirstLetter($0) }.joined(separator: "")
    } else {
        let comps = try snakecase(string).components(separatedBy: "_")
        unprefixed = comps.map { $0.capitalized }.joined(separator: "")
    }

    // only if passed true, strip the prefix underscores
    var prefixUnderscores = ""
    var result: String { return prefixUnderscores + unprefixed }
    if stripLeading {
        return result
    }
    for scalar in string.unicodeScalars {
        guard scalar == "_" else { break }
        prefixUnderscores += "_"
    }
    return result
  }

  // MARK: - Private

  private static func containsAnyLowercasedChar(_ string: String) throws -> Bool {
    let lowercaseCharRegex = try NSRegularExpression(pattern: "[a-z]", options: .dotMatchesLineSeparators)
    let fullRange = NSRange(location: 0, length: string.unicodeScalars.count)
    return lowercaseCharRegex.firstMatch(in: string, options: .reportCompletion, range: fullRange) != nil
  }

  /// Uppers the first letter of the string
  /// e.g. "people picker" gives "People picker", "sports Stats" gives "Sports Stats"
  ///
  /// - Parameters:
  ///   - value: the value to uppercase first letter of
  ///   - arguments: the arguments to the function; expecting zero
  /// - Returns: the string with first letter being uppercased
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
  private static func upperFirstLetter(_ value: String) -> String {
    guard let first = value.unicodeScalars.first else { return value }
    return String(first).uppercased() + String(value.unicodeScalars.dropFirst())
  }

  /// This returns the snake cased variant of the string.
  ///
  /// - Parameter string: The string to snake_case
  /// - Returns: The string snake cased from either snake_cased or camelCased string.
  private static func snakecase(_ string: String) throws -> String {
    let longUpper = try NSRegularExpression(pattern: "([A-Z\\d]+)([A-Z][a-z])", options: .dotMatchesLineSeparators)
    let camelCased = try NSRegularExpression(pattern: "([a-z\\d])([A-Z])", options: .dotMatchesLineSeparators)

    let fullRange = NSRange(location: 0, length: string.unicodeScalars.count)
    var result = longUpper.stringByReplacingMatches(in: string,
                                                    options: .reportCompletion,
                                                    range: fullRange,
                                                    withTemplate: "$1_$2")
    result = camelCased.stringByReplacingMatches(in: result,
                                                 options: .reportCompletion,
                                                 range: fullRange,
                                                 withTemplate: "$1_$2")
    return result.replacingOccurrences(of: "-", with: "_")
  }
}
