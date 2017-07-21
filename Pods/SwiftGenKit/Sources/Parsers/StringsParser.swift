//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum StringsParserError: Error, CustomStringConvertible {
  case duplicateTable(name: String)
  case failureOnLoading(path: String)
  case invalidFormat
  case invalidPlaceholder(previous: StringsParser.PlaceholderType, new: StringsParser.PlaceholderType)

  public var description: String {
    switch self {
    case .duplicateTable(let name):
      return "Table \"\(name)\" already loaded, cannot add it again"
    case .failureOnLoading(let path):
      return "Failed to load a file at \"\(path)\""
    case .invalidFormat:
      return "Invalid strings file"
    case .invalidPlaceholder(let previous, let new):
      return "Invalid placeholder type \(new) (previous: \(previous))"
    }
  }
}

public final class StringsParser: Parser {
  var tables = [String: [Entry]]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  // Localizable.strings files are generally UTF16, not UTF8!
  public func parse(path: Path) throws {
    let name = path.lastComponentWithoutExtension

    guard tables[name] == nil else {
      throw StringsParserError.duplicateTable(name: name)
    }
    guard let data = try? path.read() else {
      throw StringsParserError.failureOnLoading(path: path.string)
    }

    let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
    guard let dict = plist as? [String: String] else {
      throw StringsParserError.invalidFormat
    }

    tables[name] = try dict.map { key, translation in
      try Entry(key: key, translation: translation)
    }
  }

  // MARK: - Public Enum types

  public enum PlaceholderType: String {
    case object = "String"
    case float = "Float"
    case int = "Int"
    case char = "Character"
    case cString = "UnsafePointer<unichar>"
    case pointer = "UnsafePointer<Void>"
    case unknown = "UnsafePointer<()>"

    init?(formatChar char: Character) {
      guard let lcChar = String(char).lowercased().characters.first else {
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

    public static func placeholders(fromFormat str: String) throws -> [PlaceholderType] {
      return try StringsParser.placeholders(fromFormat:  str)
    }
  }

  public struct Entry {
    let key: String
    var keyStructure: [String] {
        return key.components(separatedBy: CharacterSet(charactersIn: "."))
    }
    let translation: String
    let types: [PlaceholderType]

    public init(key: String, translation: String, types: [PlaceholderType]) {
      self.key = key
      self.translation = translation
      self.types = types
    }

    public init(key: String, translation: String, types: PlaceholderType...) {
      self.init(key: key, translation: translation, types: types)
    }

    public init(key: String, translation: String) throws {
      let types = try PlaceholderType.placeholders(fromFormat: translation)
      self.init(key: key, translation: translation, types: types)
    }
  }

  // MARK: - Private Helpers

  private static let formatTypesRegEx: NSRegularExpression = {
    // %d/%i/%o/%u/%x with their optional length modifiers like in "%lld"
    let pattern_int = "(?:h|hh|l|ll|q|z|t|j)?([dioux])"
    // valid flags for float
    let pattern_float = "[aefg]"
    // like in "%3$" to make positional specifiers
    let position = "([1-9]\\d*\\$)?"
    // precision like in "%1.2f"
    let precision = "[-+]?\\d?(?:\\.\\d)?"

    do {
      return try NSRegularExpression(
        pattern: "(?:^|(?<!%)(?:%%)*)%\(position)\(precision)(@|\(pattern_int)|\(pattern_float)|[csp])",
        options: [.caseInsensitive]
      )
    } catch {
      fatalError("Error building the regular expression used to match string formats")
    }
  }()

  // "I give %d apples to %@" --> [.Int, .String]
  private static func placeholders(fromFormat formatString: String) throws -> [PlaceholderType] {
    let range = NSRange(location: 0, length: (formatString as NSString).length)

    // Extract the list of chars (conversion specifiers) and their optional positional specifier
    let chars = formatTypesRegEx.matches(in: formatString, options: [], range: range)
      .map({ match -> (String, Int?) in
        let range: NSRange
        if match.rangeAt(3).location != NSNotFound {
          // [dioux] are in range #3 because in #2 there may be length modifiers (like in "lld")
          range = match.rangeAt(3)
        } else {
          // otherwise, no length modifier, the conversion specifier is in #2
          range = match.rangeAt(2)
        }
        let char = (formatString as NSString).substring(with: range)

        let posRange = match.rangeAt(1)
        if posRange.location == NSNotFound {
          // No positional specifier
          return (char, nil)
        } else {
          // Remove the "$" at the end of the positional specifier, and convert to Int
          let posRange1 = NSRange(location: posRange.location, length: posRange.length-1)
          let pos = (formatString as NSString).substring(with: posRange1)
          return (char, Int(pos))
        }
    })

    // enumerate the conversion specifiers and their optionally forced position
    // and build the array of PlaceholderTypes accordingly
    var list = [PlaceholderType]()
    var nextNonPositional = 1
    for (str, pos) in chars {
      if let char = str.characters.first, let p = PlaceholderType(formatChar: char) {
        let insertionPos: Int
        if let pos = pos {
          insertionPos = pos
        } else {
          insertionPos = nextNonPositional
          nextNonPositional += 1
        }
        if insertionPos > 0 {
          while list.count <= insertionPos-1 {
            list.append(.unknown)
          }
          let previous = list[insertionPos-1]
          guard previous == .unknown || previous == p else {
            throw StringsParserError.invalidPlaceholder(previous: previous, new: p)
          }
          list[insertionPos-1] = p
        }
      }
    }
    return list
  }
}
