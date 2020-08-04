//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension Strings {
  public enum PlaceholderType: String {
    case object = "String"
    case float = "Float"
    case int = "Int"
    case char = "CChar"
    case cString = "UnsafePointer<CChar>"
    case pointer = "UnsafeRawPointer"

    init?(formatChar char: Character) {
      guard let lcChar = String(char).lowercased().first else {
        return nil
      }
      switch lcChar {
      case "@":
        self = .object
      case "a", "e", "f", "g":
        self = .float
      case "d", "i", "o", "u", "x":
        self = .int
      case "c":
        self = .char
      case "s":
        self = .cString
      case "p":
        self = .pointer
      default:
        return nil
      }
    }
  }
}

extension Strings.PlaceholderType {
  private static let formatTypesRegEx: NSRegularExpression = {
    // %d/%i/%o/%u/%x with their optional length modifiers like in "%lld"
    let patternInt = "(?:h|hh|l|ll|q|z|t|j)?([dioux])"
    // valid flags for float
    let patternFloat = "[aefg]"
    // like in "%3$" to make positional specifiers
    let position = "(\\d+\\$)?"
    // precision like in "%1.2f"
    let precision = "[-+# 0]?\\d?(?:\\.\\d)?"

    do {
      return try NSRegularExpression(
        pattern: "(?:^|(?<!%)(?:%%)*)%\(position)\(precision)(@|\(patternInt)|\(patternFloat)|[csp])",
        options: [.caseInsensitive]
      )
    } catch {
      fatalError("Error building the regular expression used to match string formats")
    }
  }()

  /// Extracts the list of PlaceholderTypes from a format key
  ///
  /// Example: "I give %d apples to %@" --> [.int, .string]
  static func placeholderTypes(fromFormat formatString: String) throws -> [Strings.PlaceholderType] {
    let range = NSRange(location: 0, length: (formatString as NSString).length)

    // Extract the list of chars (conversion specifiers) and their optional positional specifier
    let chars = formatTypesRegEx.matches(in: formatString, options: [], range: range)
      .compactMap { match -> (String, Int?)? in
        let range: NSRange
        if match.range(at: 3).location != NSNotFound {
          // [dioux] are in range #3 because in #2 there may be length modifiers (like in "lld")
          range = match.range(at: 3)
        } else {
          // otherwise, no length modifier, the conversion specifier is in #2
          range = match.range(at: 2)
        }
        let char = (formatString as NSString).substring(with: range)

        let posRange = match.range(at: 1)
        if posRange.location == NSNotFound {
          // No positional specifier
          return (char, nil)
        } else {
          // Remove the "$" at the end of the positional specifier, and convert to Int
          let posRange1 = NSRange(location: posRange.location, length: posRange.length - 1)
          let posString = (formatString as NSString).substring(with: posRange1)
          let pos = Int(posString)
          if let pos = pos, pos <= 0 {
            return nil // Foundation renders "%0$@" not as a placeholder but as the "0@" literal
          }
          return (char, pos)
        }
      }

    return try placeholderTypes(fromChars: chars)
  }

  /// Creates an array of `PlaceholderType` from an array of format chars and their optional positional specifier
  ///
  /// - Note: Any position that doesn't have a placeholder defined will be stripped out, shifting the position of
  ///         the remaining placeholders. This is to match how Foundation behaves at runtime.
  ///         i.e. a string of `"%2$@ %3$d"` will end up with `[.object, .int]` since no placeholder
  ///         is defined for position 1.
  /// - Parameter chars: An array of format chars and their optional positional specifier
  /// - Throws: `Strings.ParserError.invalidPlaceholder` in case a `PlaceholderType` would be overwritten
  /// - Returns: An array of `PlaceholderType`
  private static func placeholderTypes(fromChars chars: [(String, Int?)]) throws -> [Strings.PlaceholderType] {
    var list = [Int: Strings.PlaceholderType]()
    var nextNonPositional = 1

    for (str, pos) in chars {
      guard let char = str.first, let placeholderType = Strings.PlaceholderType(formatChar: char) else { continue }
      let insertionPos: Int
      if let pos = pos {
        insertionPos = pos
      } else {
        insertionPos = nextNonPositional
        nextNonPositional += 1
      }
      guard insertionPos > 0 else { continue }

      if let existingEntry = list[insertionPos], existingEntry != placeholderType {
        throw Strings.ParserError.invalidPlaceholder(previous: existingEntry, new: placeholderType)
      } else {
        list[insertionPos] = placeholderType
      }
    }

    // Omit any holes (i.e. position without a placeholder defined)
    return list
      .sorted { $0.0 < $1.0 } // Sort by key, i.e. the positional value
      .map { $0.value }
  }
}
