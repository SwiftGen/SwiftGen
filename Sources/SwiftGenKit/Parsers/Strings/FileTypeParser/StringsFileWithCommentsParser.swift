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
      let scanner = Scanner(data: data)
      scanner.parse { key, comment in
        entries[key]?.comment = comment
      }
    }
  }
}

// MARK: - Scanner

private struct Scanner {
  let data: String

  func parse(handler: (_ key: String, _ comment: String?) -> Void) {
    var scratchpad = Scratchpad()
    var lastCharacter: Character?

    for character in data {
      scratchpad.process(character: character, last: lastCharacter, handler: handler)
      lastCharacter = character
    }
  }
}

// MARK: - Scan Processor

private struct Scratchpad {
  enum Mode {
    case nothing
    case comment
    case key
    case beforeValue
    case value
  }

  private var mode: Mode = .nothing
  private var temp: String = ""
  private var comment: String?
}

extension Scratchpad {
  typealias ItemHandler = (_ key: String, _ comment: String?) -> Void

  // swiftlint:disable:next cyclomatic_complexity
  mutating func process(character: Character, last: Character?, handler: ItemHandler) {
    switch mode {
    case .nothing:
      if character == .quote {
        start(.key)
      } else if [last, character] == Character.startComment {
        start(.comment)
      }
    case .comment:
      append(character)
      if [last, character] == Character.endComment {
        finishedComment()
      }
    case .key:
      if character == .quote && last != .backslash {
        handler(temp, comment)
        finishedKey()
      } else {
        append(character, unescape: last == .backslash)
      }
    case .beforeValue:
      if character == .quote {
        start(.value)
      }
    case .value:
      if character == .quote && last != .backslash {
        finishedValue()
      } else {
        append(character, unescape: last == .backslash)
      }
    }
  }
}

private extension Scratchpad {
  mutating func append(_ character: Character, unescape: Bool = false) {
    if unescape {
      temp.removeLast()
      temp.append(character.unescaped)
    } else {
      temp.append(character)
    }
  }

  mutating func start(_ mode: Mode) {
    self.mode = mode
  }

  mutating func finishedComment() {
    comment = temp.dropLast(2).trimmingCharacters(in: .whitespacesAndNewlines)
    temp = ""
    mode = .nothing
  }

  mutating func finishedKey() {
    temp = ""
    comment = nil
    mode = .beforeValue
  }

  mutating func finishedValue() {
    temp = ""
    mode = .nothing
  }
}

// MARK: - Used delimiters

private extension Character {
  static let startComment: [Character] = ["/", "*"]
  static let endComment: [Character] = ["*", "/"]
  static let quote: Character = "\""
  static let backslash: Character = "\\"

  var unescaped: Character {
    switch self {
    case "n":
      return "\n"
    case "t":
      return "\t"
    default:
      return self
    }
  }
}
