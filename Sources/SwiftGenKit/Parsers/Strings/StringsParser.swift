//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Strings {
  public enum ParserError: Error, CustomStringConvertible {
    case duplicateTable(name: String)
    case failureOnLoading(path: String)
    case invalidFormat
    case invalidPlaceholder(previous: Strings.PlaceholderType, new: Strings.PlaceholderType)

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

  private enum Option {
    static let separator = "separator"
  }

  public final class Parser: SwiftGenKit.Parser {
    var tables = [String: [Entry]]()
    public var warningHandler: Parser.MessageHandler?
    private let keyStructureSeparator: String

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
      self.keyStructureSeparator = (options[Option.separator] as? String) ?? Entry.defaultSeparator
    }

    public static let defaultFilter = "[^/]\\.strings$"
    public static let allOptions = ParserOptionList()

    // Localizable.strings files are generally UTF16, not UTF8!
    public func parse(path: Path, relativeTo parent: Path) throws {
      let name = path.lastComponentWithoutExtension

      guard tables[name] == nil else {
        throw ParserError.duplicateTable(name: name)
      }
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }

      let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
      guard let dict = plist as? [String: String] else {
        throw ParserError.invalidFormat
      }

      tables[name] = try dict.map { key, translation in
        try Entry(key: key, translation: translation, keyStructureSeparator: keyStructureSeparator)
      }
    }
  }
}
