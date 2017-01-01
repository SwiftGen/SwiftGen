//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

enum FilterError: Error {
  case invalidInputType
}

struct StringFilters {
  fileprivate static let reservedKeywords = ["associatedtype", "class", "deinit", "enum", "extension",
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
                                         "right", "set", "Type", "unowned", "weak", "willSet"]

  static func stringToSwiftIdentifier(value: Any?) throws -> Any? {
    guard let value = value as? String else { throw FilterError.invalidInputType }
    return swiftIdentifier(from: value, replaceWithUnderscores: true)
  }

  /* - If the string starts with only one uppercase letter, lowercase that first letter
   * - If the string starts with multiple uppercase letters, lowercase those first letters
   *   up to the one before the last uppercase one, but only if the last one is followed by
   *   a lowercase character.
   * e.g. "PeoplePicker" gives "peoplePicker" but "URLChooser" gives "urlChooser"
   */
  static func lowerFirstWord(_ value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.invalidInputType }
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
    guard let string = value as? String else { throw FilterError.invalidInputType }
    return titlecase(string)
  }

  static func snakeToCamelCase(_ value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.invalidInputType }
    guard let noPrefix = try snakeToCamelCaseNoPrefix(value) else {
      return nil
    }
    var prefixUnderscores = ""
    for scalar in string.unicodeScalars {
      guard scalar == "_" else { break }
      prefixUnderscores += "_"
    }

    return prefixUnderscores + ("\(noPrefix)")
  }

  static func snakeToCamelCaseNoPrefix(_ value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.invalidInputType }

    if try containsAnyLowercasedChar(string) {
      let comps = string.components(separatedBy: "_")
      return comps.map { titlecase($0) }.joined(separator: "")
    } else {
      let comps = try snakecase(string).components(separatedBy: "_")
      return comps.map { $0.capitalized }.joined(separator: "")
    }
  }

  /**
  This returns the string with its first parameter uppercased.
  - note: This is quite similar to `capitalise` except that this filter doesn't lowercase
          the rest of the string but keep it untouched.
  
  - parameter string: The string to titleCase

  - returns: The string with its first character uppercased, and the rest of the string unchanged.
  */
  private static func titlecase(_ string: String) -> String {
    guard let first = string.unicodeScalars.first else { return string }
    return String(first).uppercased() + String(string.unicodeScalars.dropFirst())
  }

  private static func containsAnyLowercasedChar(_ string: String) throws -> Bool {
    let lowercaseCharRegex = try NSRegularExpression(pattern: "[a-z]", options: .dotMatchesLineSeparators)
    let fullRange = NSRange(location: 0, length: string.unicodeScalars.count)
    return lowercaseCharRegex.firstMatch(in: string, options: .reportCompletion, range: fullRange) != nil
  }

  /**
  This returns the snake cased variant of the string.
  - parameter string: The string to snake_case
   
  - returns: The string snake cased from either snake_cased or camelCased string.
  */
  private static func snakecase(_ string: String) throws -> String {
    let longUpper = try NSRegularExpression(pattern: "([A-Z\\d]+)([A-Z][a-z])", options: .dotMatchesLineSeparators)
    let camelCased = try NSRegularExpression(pattern: "([a-z\\d])([A-Z])", options: .dotMatchesLineSeparators)

    let fullRange = NSRange(location: 0, length: string.unicodeScalars.count)
    var result = longUpper.stringByReplacingMatches(in: string, options: .reportCompletion, range: fullRange, withTemplate: "$1_$2")
    result = camelCased.stringByReplacingMatches(in: result, options: .reportCompletion, range: fullRange, withTemplate: "$1_$2")
    return result.replacingOccurrences(of: "-", with: "_")
  }
}

// MARK: - Reserved Keyword escape
extension StringFilters {
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

  static func escapeReservedKeywords(value: Any?) throws -> Any? {
    guard let string = value as? String else { throw FilterError.invalidInputType }
    return escapeReservedKeywords(in: string)
  }
}

struct ArrayFilters {
  static func join(_ value: Any?) throws -> Any? {
    guard let array = value as? [Any] else { throw FilterError.invalidInputType }
    let strings = array.flatMap { $0 as? String }
    guard array.count == strings.count else { throw FilterError.invalidInputType }

    return strings.joined(separator: ", ")
  }
}

struct NumFilters {
  static func hexToInt(_ value: Any?) throws -> Any? {
    guard let value = value as? String else { throw FilterError.invalidInputType }
    return Int(value, radix:  16)
  }

  static func int255toFloat(_ value: Any?) throws -> Any? {
    guard let value = value as? Int else { throw FilterError.invalidInputType }
    return Float(value) / Float(255.0)
  }

  static func percent(_ value: Any?) throws -> Any? {
    guard let value = value as? Float else { throw FilterError.invalidInputType }

    let percent = Int(value * 100.0)
    return "\(percent)%"
  }
}
