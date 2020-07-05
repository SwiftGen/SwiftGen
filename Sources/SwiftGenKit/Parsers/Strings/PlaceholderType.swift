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

  // "I give %d apples to %@" --> [.Int, .String]
  static func placeholders(fromFormat formatString: String) throws -> [Strings.PlaceholderType] {
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

    // enumerate the conversion specifiers and their optionally forced position
    // and build the array of PlaceholderTypes accordingly
    var list = [Strings.PlaceholderType]()
    var nextNonPositional = 1
    for (str, pos) in chars {
      if let char = str.first, let placeholderType = Strings.PlaceholderType(formatChar: char) {
        let insertionPos: Int
        if let pos = pos {
          insertionPos = pos
        } else {
          insertionPos = nextNonPositional
          nextNonPositional += 1
        }
        if insertionPos > 0 {
          while list.count <= insertionPos - 1 {
            list.append(.unknown)
          }
          let previous = list[insertionPos - 1]
          guard previous == .unknown || previous == placeholderType else {
            throw Strings.ParserError.invalidPlaceholder(previous: previous, new: placeholderType)
          }
          list[insertionPos - 1] = placeholderType
        }
      }
    }
    return list
  }
}
