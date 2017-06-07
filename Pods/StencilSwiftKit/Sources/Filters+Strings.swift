//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

enum RemoveNewlinesModes: String {
  case all, leading
}

extension Filters {
  enum Strings {
    fileprivate static let reservedKeywords = [
      "associatedtype", "class", "deinit", "enum", "extension",
      "fileprivate", "func", "import", "init", "inout", "internal",
      "let", "open", "operator", "private", "protocol", "public",
      "static", "struct", "subscript", "typealias", "var", "break",
      "case", "continue", "default", "defer", "do", "else",
      "fallthrough", "for", "guard", "if", "in", "repeat", "return",
      "switch", "where", "while", "as", "Any", "catch", "false", "is",
      "nil", "rethrows", "super", "self", "Self", "throw", "throws",
      "true", "try", "_", "#available", "#colorLiteral", "#column",
      "#else", "#elseif", "#endif", "#file", "#fileLiteral",
      "#function", "#if", "#imageLiteral", "#line", "#selector",
      "#sourceLocation", "associativity", "convenience", "dynamic",
      "didSet", "final", "get", "infix", "indirect", "lazy", "left",
      "mutating", "none", "nonmutating", "optional", "override",
      "postfix", "precedence", "prefix", "Protocol", "required",
      "right", "set", "Type", "unowned", "weak", "willSet"
    ]

    static func swiftIdentifier(_ value: Any?) throws -> Any? {
      guard let value = value as? String else { throw Filters.Error.invalidInputType }
      return StencilSwiftKit.swiftIdentifier(from: value, replaceWithUnderscores: true)
    }

    /* - If the string starts with only one uppercase letter, lowercase that first letter
     * - If the string starts with multiple uppercase letters, lowercase those first letters
     *   up to the one before the last uppercase one, but only if the last one is followed by
     *   a lowercase character.
     * e.g. "PeoplePicker" gives "peoplePicker" but "URLChooser" gives "urlChooser"
     */
    static func lowerFirstWord(_ value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
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

    static func titlecase(_ value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      return titlecase(string)
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
      guard let string = value as? String else { throw Filters.Error.invalidInputType }

      let unprefixed: String
      if try containsAnyLowercasedChar(string) {
        let comps = string.components(separatedBy: "_")
        unprefixed = comps.map { titlecase($0) }.joined(separator: "")
      } else {
        let comps = try snakecase(string).components(separatedBy: "_")
        unprefixed = comps.map { $0.capitalized }.joined(separator: "")
      }

      // only if passed true, strip the prefix underscores
      var prefixUnderscores = ""
      if !stripLeading {
        for scalar in string.unicodeScalars {
          guard scalar == "_" else { break }
          prefixUnderscores += "_"
        }
      }

      return prefixUnderscores + unprefixed
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
      guard let string = value as? String else { throw Filters.Error.invalidInputType }

      let snakeCase = try snakecase(string)
      if toLower {
        return snakeCase.lowercased()
      }
      return snakeCase
    }

    static func escapeReservedKeywords(value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      return escapeReservedKeywords(in: string)
    }

    /// Removes newlines and other whitespace from a string. Takes an optional Mode argument:
    ///   - all (default): remove all newlines and whitespaces
    ///   - leading: remove newlines and only leading whitespaces
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting zero or one mode argument
    /// - Returns: the trimmed string
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func removeNewlines(_ value: Any?, arguments: [Any?]) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      let mode = try Filters.parseEnum(from: arguments, default: RemoveNewlinesModes.all)

      switch mode {
      case .all:
        return string
          .components(separatedBy: .whitespacesAndNewlines)
          .joined()
      case .leading:
        return string
          .components(separatedBy: .newlines)
          .map(removeLeadingWhitespaces(from:))
          .joined()
          .trimmingCharacters(in: .whitespaces)
      }
    }

    // MARK: - Private methods

    private static func removeLeadingWhitespaces(from string: String) -> String {
      let chars = string.unicodeScalars.drop { CharacterSet.whitespaces.contains($0) }
      return String(chars)
    }

    /// This returns the string with its first parameter uppercased.
    /// - note: This is quite similar to `capitalise` except that this filter doesn't
    ///          lowercase the rest of the string but keeps it untouched.
    ///
    /// - Parameter string: The string to titleCase
    /// - Returns: The string with its first character uppercased, and the rest of the string unchanged.
    private static func titlecase(_ string: String) -> String {
      guard let first = string.unicodeScalars.first else { return string }
      return String(first).uppercased() + String(string.unicodeScalars.dropFirst())
    }

    private static func containsAnyLowercasedChar(_ string: String) throws -> Bool {
      let lowercaseCharRegex = try NSRegularExpression(pattern: "[a-z]", options: .dotMatchesLineSeparators)
      let fullRange = NSRange(location: 0, length: string.unicodeScalars.count)
      return lowercaseCharRegex.firstMatch(in: string, options: .reportCompletion, range: fullRange) != nil
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

    /// Checks if the string is one of the reserved keywords and if so, escapes it using backticks
    ///
    /// - Parameter in: the string to possibly escape
    /// - Returns: if the string is a reserved keyword, the escaped string, otherwise the original one
    private static func escapeReservedKeywords(in string: String) -> String {
      guard reservedKeywords.contains(string) else {
        return string
      }
      return "`\(string)`"
    }
  }
}
