//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import Stencil

public final class StringEnumBuilder {
  private var parsedLines = [Entry]()

  public init() {}
  
  public func addEntry(entry: Entry) {
    parsedLines.append(entry)
  }
  
  // Localizable.strings files are generally UTF16, not UTF8!
  public func parseLocalizableStringsFile(path: String) throws {
    var encoding: NSStringEncoding = NSUTF16StringEncoding
    let fileContent = try NSString(contentsOfFile: path, usedEncoding: &encoding)
    let lines = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    
    for case let entry? in lines.map(Entry.init) {
      addEntry(entry)
    }
  }
  
  public func stencilContext() -> Context {
    let strings = parsedLines.map { (entry: Entry) -> [String:AnyObject] in
      if entry.types.count > 0 {
        let params = [
          "count": entry.types.count,
          "types": entry.types.map { $0.rawValue },
          "declarations": (0..<entry.types.count).map { "let p\($0)" },
          "names": (0..<entry.types.count).map { "p\($0)" }
        ]
        return ["key": entry.key, "params":params]
      } else {
        return ["key": entry.key]
      }
    }
    return Context(dictionary: ["enumName":"L10n", "strings":strings])
  }
  
  
  // MARK: - Public Enum types
  
  public enum PlaceholderType : String {
    case Object = "String"
    case Float = "Float"
    case Int = "Int"
    case Char = "Character"
    case CString = "UnsafePointer<unichar>"
    case Pointer = "UnsafePointer<Void>"
    case Unknown = "Any"
    
    init?(formatChar char: Character) {
      let lcChar = String(char).lowercaseString.characters.first!
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
      return StringEnumBuilder.typesFromFormatString(format)
    }
  }
  
  public struct Entry {
    let key: String
    let types: [PlaceholderType]
    
    public init(key: String, types: [PlaceholderType]) {
      self.key = key
      self.types = types
    }
    
    public init(key: String, types: PlaceholderType...) {
      self.key = key
      self.types = types
    }
    
    private static let lineRegEx = try! NSRegularExpression(pattern: "^\"([^\"]+)\"[ \t]*=[ \t]*\"(.*)\"[ \t]*;", options: [])
    
    public init?(line: String) {
      let range = NSRange(location: 0, length: (line as NSString).length)
      if let match = Entry.lineRegEx.firstMatchInString(line, options: [], range: range) {
        let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
        
        let translation = (line as NSString).substringWithRange(match.rangeAtIndex(2))
        let types = PlaceholderType.fromFormatString(translation)
        
        self = Entry(key: key, types: types)
      } else {
        return nil
      }
    }
  }
  
  
  
  // MARK: - Private Helpers
  
  private static let formatTypesRegEx : NSRegularExpression = {
    let pattern_int = "(?:h|hh|l|ll|q|z|t|j)?([dioux])" // %d/%i/%o/%u/%x with their optional length modifiers like in "%lld"
    let pattern_float = "[aefg]"
    let position = "([1-9]\\d*\\$)?" // like in "%3$" to make positional specifiers
    let precision = "[-+]?\\d?(?:\\.\\d)?" // precision like in "%1.2f"
    return try! NSRegularExpression(pattern: "(?<!%)%\(position)\(precision)(@|\(pattern_int)|\(pattern_float)|[csp])", options: [.CaseInsensitive])
    }()
  
  // "I give %d apples to %@" --> [.Int, .String]
  private static func typesFromFormatString(formatString: String) -> [PlaceholderType] {
    let range = NSRange(location: 0, length: (formatString as NSString).length)
    
    // Extract the list of chars (conversion specifiers) and their optional positional specifier
    let chars = formatTypesRegEx.matchesInString(formatString, options: [], range: range).map { match -> (String, Int?) in
      let range : NSRange
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
      }
      else {
        // Remove the "$" at the end of the positional specifier, and convert to Int
        let posRange1 = NSRange(location: posRange.location, length: posRange.length-1)
        let pos = (formatString as NSString).substringWithRange(posRange1)
        return (char, Int(pos))
      }
    }
    
    // enumerate the conversion specifiers and their optionally forced position and build the array of PlaceholderTypes accordingly
    var list = [PlaceholderType]()
    var nextNonPositional = 1
    for (str, pos) in chars {
      if let char = str.characters.first, let p = PlaceholderType(formatChar: char) {
        let insertionPos = pos ?? nextNonPositional++
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
