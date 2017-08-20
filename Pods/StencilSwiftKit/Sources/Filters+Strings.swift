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

enum SwiftIdentifierModes: String {
  case normal, pretty
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

    /// Replaces in the given string the given substring with the replacement
    /// "people picker", replacing "picker" with "life" gives "people life"
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting two arguments: substring, replacement
    /// - Returns: the results string
    /// - Throws: FilterError.invalidInputType if the value parameter or argunemts aren't string
    static func replace(_ value: Any?, arguments: [Any?]) throws -> Any? {
      guard let source = value as? String,
            arguments.count == 2,
            let substring = arguments[0] as? String,
            let replacement = arguments[1] as? String else {
        throw Filters.Error.invalidInputType
      }
      return source.replacingOccurrences(of: substring, with: replacement)
    }

    /// Converts an arbitrary string to a valid swift identifier. Takes an optional Mode argument:
    ///   - normal (default): uppercase the first character, prefix with an underscore if starting
    ///     with a number, replace invalid characters by underscores
    ///   - leading: same as the above, but apply the snaceToCamelCase filter first for a nicer
    ///     identifier
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting zero or one mode argument
    /// - Returns: the identifier string
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func swiftIdentifier(_ value: Any?, arguments: [Any?]) throws -> Any? {
      guard var string = value as? String else { throw Filters.Error.invalidInputType }
      let mode = try Filters.parseEnum(from: arguments, default: SwiftIdentifierModes.normal)

      switch mode {
      case .normal:
        return SwiftIdentifier.identifier(from: string, replaceWithUnderscores: true)
      case .pretty:
        string = SwiftIdentifier.identifier(from: string, replaceWithUnderscores: true)
        string = try snakeToCamelCase(string, stripLeading: true)
        return SwiftIdentifier.prefixWithUnderscoreIfNeeded(string: string)
      }
    }

    /// Lowers the first letter of the string
    /// e.g. "People picker" gives "people picker", "Sports Stats" gives "sports Stats"
    static func lowerFirstLetter(_ value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
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

    /// Lowers the first letter of the string
    /// e.g. "People picker" gives "people picker", "Sports Stats" gives "sports Stats"
    /// 
    /// - Parameters:
    ///   - value: the value to uppercase first letter of
    ///   - arguments: the arguments to the function; expecting zero
    /// - Returns: the string with first letter being uppercased
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func upperFirstLetter(_ value: Any?) throws -> Any? {
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

    /// Checks if the given string contains given substring
    ///
    /// - Parameters:
    ///   - value: the string value to check if it contains substring
    ///   - arguments: the arguments to the function; expecting one string argument - substring
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or 
    ///           if number of arguments is not one or if the given argument isn't a string
    static func contains(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let substring = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.contains(substring)
    }

    /// Checks if the given string has given prefix
    ///
    /// - Parameters:
    ///   - value: the string value to check if it has prefix
    ///   - arguments: the arguments to the function; expecting one string argument - prefix
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
    ///           if number of arguments is not one or if the given argument isn't a string
    static func hasPrefix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let prefix = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.hasPrefix(prefix)
    }

    /// Checks if the given string has given suffix
    ///
    /// - Parameters:
    ///   - value: the string value to check if it has prefix
    ///   - arguments: the arguments to the function; expecting one string argument - suffix
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
    ///           if number of arguments is not one or if the given argument isn't a string
    static func hasSuffix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let suffix = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.hasSuffix(suffix)
    }

    /// Converts a file path to just the filename, stripping any path components before it.
    ///
    /// - Parameter value: the value to be processed
    /// - Returns: the basename of the path
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func basename(_ value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      return (string as NSString).lastPathComponent
    }

    /// Converts a file path to just the path without the filename.
    ///
    /// - Parameter value: the value to be processed
    /// - Returns: the dirname of the path
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func dirname(_ value: Any?) throws -> Any? {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      return (string as NSString).deletingLastPathComponent
    }

    // MARK: - Private methods

    private static func removeLeadingWhitespaces(from string: String) -> String {
      let chars = string.unicodeScalars.drop { CharacterSet.whitespaces.contains($0) }
      return String(chars)
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
