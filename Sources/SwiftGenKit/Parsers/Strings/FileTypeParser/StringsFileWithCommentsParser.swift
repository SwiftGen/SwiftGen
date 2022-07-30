//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  struct StringsFileWithCommentsParser {
    private let data: String

    init?(file: Path) {
      guard let data: String = try? file.read() else { return nil }
      self.data = data
    }

    func enrich(entries: inout [String: Strings.Entry]) {
      let scanner = Scanner(string: data)

      while !scanner.isAtEnd {
        let comment = scanner.scanComment()
        if let key = scanner.scanQuotedString() {
          entries[key]?.comment = comment

          // Scan in the value and ignore it.
          scanner.scanUpTo(.quote, into: nil)
          scanner.scanQuotedString()
        }
      }
    }
  }
}

// MARK: - Scanner helpers

private extension String {
  static let startComment = "/*"
  static let endComment = "*/"
  static let quote = "\""
}

private extension Character {
  static let backslash: Character = "\\"
  static let quote: Character = "\""
}

private extension Scanner {
  /// Try to scan a comment (if found)
  func scanComment() -> String? {
    var optionalComment: NSString?

    scanUpTo(.startComment, into: nil)
    guard scanString(.startComment, into: nil),
      scanUpTo(.endComment, into: &optionalComment),
      let comment = optionalComment else {
      return nil
    }
    scanString(.endComment, into: nil)

    return comment.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Try to scan a string surrounded by quotes
  @discardableResult
  func scanQuotedString() -> String? {
    guard scanString(.quote, into: nil) else { return nil }

    var result = ""

    // temporarily disable skipping of characters (default is whitespace/newlines)
    let startingCharactersToBeSkipped = charactersToBeSkipped
    charactersToBeSkipped = nil
    defer { charactersToBeSkipped = startingCharactersToBeSkipped }

    while let character = scanCharacter(), character != .quote {
      if character == .backslash, let escapedCharacter = scanEscapedCharacter() {
        result.append(escapedCharacter)
      } else {
        result.append(character)
      }
    }
    scanString(.quote, into: nil)

    return result
  }

  /// Loosely based on
  /// https://opensource.apple.com/source/CF/CF-550/CFPropertyList.c.auto.html
  func scanEscapedCharacter() -> Character? {
    let character = scanCharacter()

    switch character {
    case "n":
      return "\n"
    case "t":
      return "\t"
    case "\"":
      return "\""
    default:
      return character
    }
  }

  func scanCharacter() -> Character? {
    guard let index = string.index(string.startIndex, offsetBy: scanLocation, limitedBy: string.endIndex) else {
      return nil
    }

    defer { scanLocation += 1 }
    return string[index]
  }
}
