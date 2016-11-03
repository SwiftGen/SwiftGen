//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public enum StringsFileParserError: ErrorType, CustomStringConvertible {
  case FailureOnLoading(path: String)
  case InvalidFormat

  public var description: String {
    switch self {
    case .FailureOnLoading(let path):
      return "Failed to load a file at \"\(path)\""
    case .InvalidFormat:
      return "Invalid strings file"
    }
  }
}

public final class StringsFileParser {
  var entries = [Entry]()

  public init() {}

  public func addEntry(entry: Entry) {
    entries.append(entry)
  }

  // Localizable.strings files are generally UTF16, not UTF8!
  public func parseStringsFile(path: String) throws {
    guard let data = NSData(contentsOfFile: path) else {
      throw StringsFileParserError.FailureOnLoading(path: path)
    }

    let plist = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListReadOptions.Immutable, format: nil)

    guard let dict = plist as? Dictionary<String, String> else {
      throw StringsFileParserError.InvalidFormat
    }

    var encoding: NSStringEncoding = NSUTF16StringEncoding
    let fileContent = try NSString(contentsOfFile: path, usedEncoding: &encoding)

    func extractKey(line: String) -> String? {
      let regex: NSRegularExpression = {
        do {
          return try NSRegularExpression(pattern: "^\"([^\"]+)\"[ \t]*=", options: [])
        } catch {
          fatalError("Error while building Regular Expression for strings file parsing")
        }
      }()

      let range = NSRange(location: 0, length: (line as NSString).length)
      if let match = regex.firstMatchInString(line, options: [], range: range) {
        return (line as NSString).substringWithRange(match.rangeAtIndex(1))
      }
      return nil
    }

    let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

    for case let key? in lines.map(extractKey) {
      if let translation = dict[key] {
        addEntry(Entry(key: key, translation: translation))
      }
    }
  }

  // MARK: - Public Enum types

  public enum PlaceholderType: String {
    case Object = "String"
    case Float = "Float"
    case Int = "Int"
    case Char = "Character"
    case CString = "UnsafePointer<unichar>"
    case Pointer = "UnsafePointer<Void>"
    case Unknown = "UnsafePointer<()>"

    init?(formatChar char: Character) {
      guard let lcChar = String(char).lowercaseString.characters.first else {
        return nil
      }
      switch lcChar {
      case "@":
        self = .Object
      case "a", "e", "f", "g":
        self = .Float
      case "d", "i", "o", "u", "x":
        self = .Int
      case "c":
        self = .Char
      case "s":
        self = .CString
      case "p":
        self = .Pointer
      default:
        return nil
      }
    }

    public static func fromFormatString(format: String) -> [PlaceholderType] {
      return StringsFileParser.typesFromFormatString(format)
    }
  }

  public struct Entry {
    let key: String
    var keyStructure: [String] {
        return key.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
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

    public init(key: String, translation: String) {
      let types = PlaceholderType.fromFormatString(translation)
      self.init(key: key, translation: translation, types: types)
    }

    private static let lineRegEx: NSRegularExpression = {
      do {
        return try NSRegularExpression(pattern: "^\"([^\"]+)\"[ \t]*=[ \t]*\"(.*)\"[ \t]*;", options: [])
      } catch {
        fatalError("Error while building Regular Expression for strings file parsing")
      }
    }()

    public init?(line: String) {
      let range = NSRange(location: 0, length: (line as NSString).length)
      if let match = Entry.lineRegEx.firstMatchInString(line, options: [], range: range) {
        let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))

        let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
        let types = PlaceholderType.fromFormatString(translation)

        self = Entry(key: key, translation: translation, types: types)
      } else {
        return nil
      }
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
        pattern: "(?<!%)%\(position)\(precision)(@|\(pattern_int)|\(pattern_float)|[csp])",
        options: [.CaseInsensitive]
      )
    } catch {
      fatalError("Error building the regular expression used to match string formats")
    }
    }()

  // "I give %d apples to %@" --> [.Int, .String]
  private static func typesFromFormatString(formatString: String) -> [PlaceholderType] {
    let range = NSRange(location: 0, length: (formatString as NSString).length)

    // Extract the list of chars (conversion specifiers) and their optional positional specifier
    let chars = formatTypesRegEx.matchesInString(formatString, options: [], range: range)
      .map({ match -> (String, Int?) in
        let range: NSRange
        if match.rangeAtIndex(3).location != NSNotFound {
          // [dioux] are in range #3 because in #2 there may be length modifiers (like in "lld")
          range = match.rangeAtIndex(3)
        } else {
          // otherwise, no length modifier, the conversion specifier is in #2
          range = match.rangeAtIndex(2)
        }
        let char = (formatString as NSString).substringWithRange(range)

        let posRange = match.rangeAtIndex(1)
        if posRange.location == NSNotFound {
          // No positional specifier
          return (char, nil)
        } else {
          // Remove the "$" at the end of the positional specifier, and convert to Int
          let posRange1 = NSRange(location: posRange.location, length: posRange.length-1)
          let pos = (formatString as NSString).substringWithRange(posRange1)
          return (char, Int(pos))
        }
        }
    )

    // enumerate the conversion specifiers and their optionally forced position
    // and build the array of PlaceholderTypes accordingly
    var list = [PlaceholderType]()
    var nextNonPositional = 1
    for (str, pos) in chars {
      if let char = str.characters.first, p = PlaceholderType(formatChar: char) {
        let insertionPos: Int
        if let pos = pos {
          insertionPos = pos
        } else {
          insertionPos = nextNonPositional
          nextNonPositional += 1
        }
        if insertionPos > 0 {
          while list.count <= insertionPos-1 {
            list.append(.Unknown)
          }
          list[insertionPos-1] = p
        }
      }
    }
    return list
  }
}
