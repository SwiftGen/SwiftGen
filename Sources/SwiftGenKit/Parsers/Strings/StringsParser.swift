//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Strings {
  public enum ParserError: Error, CustomStringConvertible {
    case duplicateKeysInTable(name: String, extensions: [String], keys: [String])
    case failureOnLoading(path: String)
    case invalidFormat
    case invalidPlaceholder(previous: Strings.PlaceholderType, new: Strings.PlaceholderType)
    case unsupportedFileType(path: Path, supported: [String])

    public var description: String {
      switch self {
      case .duplicateKeysInTable(let name, let extensions, let keys):
        // swiftlint:disable:next line_length
        return "Table \"\(name)\" already loaded by other parser, the parser for [\(extensions.map({ ".\($0)" }).joined(separator: ", "))] files cannot modify existing keys:\n\(keys.joined(separator: "\n"))"
      case .failureOnLoading(let path):
        return "Failed to load a file at \"\(path)\""
      case .invalidFormat:
        return "Invalid strings file"
      case .invalidPlaceholder(let previous, let new):
        return "Invalid placeholder type \(new) (previous: \(previous))"
      case .unsupportedFileType(let path, let supported):
        return """
        error: Unsupported file type for \(path). \
        The supported file types are: \(supported.joined(separator: ", "))
        """
      }
    }
  }

  public enum Option {
    static let separator = ParserOption(
      key: "separator",
      defaultValue: ".",
      help: "Separator used to split keys into components"
    )
  }

  public final class Parser: SwiftGenKit.Parser {
    private let options: ParserOptionValues
    private var parsers = [String: StringsFileTypeParser.Type]()
    var tables = [String: [Entry]]()
    public var warningHandler: Parser.MessageHandler?

    private static let subParsers: [StringsFileTypeParser.Type] = [
      StringsFileParser.self,
      StringsDictFileParser.self
    ]

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler

      for parser in Parser.subParsers {
        register(parser: parser)
      }
    }

    public static let allOptions: ParserOptionList = [Option.separator]
    public static var defaultFilter: String {
      let extensions = Parser.subParsers
        .flatMap { subParser in
          subParser.extensions.map { NSRegularExpression.escapedPattern(for: $0) }
        }
        .sorted()
        .joined(separator: "|")
      return "[^/]\\.(?i:\(extensions))$"
    }

    // Localizable.strings files are generally UTF16, not UTF8!
    public func parse(path: Path, relativeTo parent: Path) throws {
      guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
        throw ParserError.unsupportedFileType(path: path, supported: parsers.keys.sorted())
      }

      let name = path.lastComponentWithoutExtension
      let parser = parserType.init(options: options)

      let entries: [Entry]
      if let existingEntries = tables[name], !existingEntries.isEmpty {
        let newEntries = try parser.parseFile(at: path)
        let allEntries = [existingEntries, newEntries].joined()
        let allKeys = allEntries.map { $0.key }

        var duplicateKeys = [String]()
        let mergedEntries = Dictionary(zip(allKeys, allEntries)) { existing, new in
          duplicateKeys.append(existing.key)
          return parser.shouldOverwriteValuesInExistingTable ? new : existing
        }

        if !duplicateKeys.isEmpty && !parser.shouldOverwriteValuesInExistingTable {
          warningHandler?(
            ParserError.duplicateKeysInTable(
              name: name,
              extensions: parserType.extensions,
              keys: duplicateKeys.sorted()
            ).description,
            #file,
            #line
          )
        }

        entries = Array(mergedEntries.values)
      } else {
        entries = try parser.parseFile(at: path)
      }

      tables[name] = entries
    }

    func register(parser: StringsFileTypeParser.Type) {
      for ext in parser.extensions {
        if let old = parsers[ext] {
          warningHandler?(
            """
            error: Parser \(parser) tried to register the file type '\(ext)' already \
            registered by \(old).
            """,
            #file,
            #line
          )
        }
        parsers[ext] = parser
      }
    }
  }
}
