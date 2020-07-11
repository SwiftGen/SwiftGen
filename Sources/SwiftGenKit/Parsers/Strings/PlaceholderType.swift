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

    static let unknown = pointer

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
    let position = "([1-9]\\d*\\$)?"
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

  // "I give %d apples to %@" --> [.int, .string]
  static func placeholders(
    fromFormat formatString: String,
    normalizePositionals: Bool = false
  ) throws -> [Strings.PlaceholderType] {
    let range = NSRange(location: 0, length: (formatString as NSString).length)

    // Extract the list of chars (conversion specifiers) and their optional positional specifier
    let chars = formatTypesRegEx.matches(in: formatString, options: [], range: range)
      .map { match -> (String, Int?) in
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
          let pos = (formatString as NSString).substring(with: posRange1)
          return (char, Int(pos))
        }
      }

    return try placeholderTypesFromChars(chars, normalizePositionals: normalizePositionals)
  }

  /// Creates an array of `PlaceholderType` from an array of format chars and their optional positional specifier
  ///
  /// - Parameter chars: An array of format chars and their optional positional specifier
  /// - Parameter normalizePositionals: defines how to treat undefined positions
  ///     - if true, undefined placeholders will be omitted and the remaining placeholder will have their
  ///       position shifted accordingly. This is how Foundation behaves at runtime.
  ///     - if false, undefined placeholders will be replaced with the `.unknown` value
  /// - Throws: `Strings.ParserError.invalidPlaceholder` in case a `PlaceholderType` would be overwritten
  /// - Returns: An array of `PlaceholderType`
  private static func placeholderTypesFromChars(
    _ chars: [(String, Int?)],
    normalizePositionals: Bool
  ) throws -> [Strings.PlaceholderType] {
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

    if normalizePositionals {
      // Omit any holes (i.e. position without a placeholder defined)
      return list
        .sorted { $0.0 < $1.0 } // Sort by key, i.e. the positional value
        .map { $0.value }
    } else {
      // Replace any holes with .unknown
      guard let maxIndex = list.keys.max() else { return [] }
      return (1...maxIndex).map { list[$0] ?? .unknown }
    }
  }
}
