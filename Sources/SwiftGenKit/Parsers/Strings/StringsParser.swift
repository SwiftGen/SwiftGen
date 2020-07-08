//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Strings {
  public enum ParserError: Error, CustomStringConvertible {
    case duplicateTableFile(path: Path, existing: Path)
    case failureOnLoading(path: Path)
    case invalidFormat
    case invalidPlaceholder(previous: Strings.PlaceholderType, new: Strings.PlaceholderType)
    case invalidPluralFormat(missingVariableKey: String, pluralKey: String)
    case invalidVariableRuleValueType(variableName: String, valueType: String)
    case unsupportedFileType(path: Path, supported: [String])

    public var description: String {
      switch self {
      case .duplicateTableFile(let path, let existing):
        return """
        Duplicate file of the same type for table "\(path.lastComponentWithoutExtension)":
        Trying to load \(path) while we've already loaded \(existing)
        """
      case .failureOnLoading(let path):
        return "Failed to load a file at \"\(path)\""
      case .invalidFormat:
        return "Invalid strings file"
      case .invalidPlaceholder(let previous, let new):
        return "Invalid placeholder type \(new) (previous: \(previous))"
      case .invalidPluralFormat(let missingVariableKey, let pluralKey):
        return """
        The variable \"\(missingVariableKey)\" referenced in the NSStringLocalizedFormatKey is not \
        defined in the variables of the plural key \"\(pluralKey)\"
        """
      case .invalidVariableRuleValueType(let variableName, let valueType):
        return """
        The variable \"\(variableName)\" has sepcified \"\(valueType)\" as its NSStringFormatValueTypeKey. \
        The Stringsdict file format only supports format specifiers for a number.
        """
      case .unsupportedFileType(let path, let supported):
        return """
        Unsupported file type for \(path). \
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
    private typealias File = (path: Path, entries: [Entry])

    private let options: ParserOptionValues
    private var parsers = [String: StringsFileTypeParser.Type]()
    private var tableFiles = [String: [File]]()
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
      let extensions = Parser.subParsers.flatMap { $0.extensions }.sorted()
      return filterRegex(forExtensions: extensions)
    }

    public func parse(path: Path, relativeTo parent: Path) throws {
      guard let fileExtension = path.extension?.lowercased(), let parserType = parsers[fileExtension] else {
        throw ParserError.unsupportedFileType(path: path, supported: parsers.keys.sorted())
      }

      let name = path.lastComponentWithoutExtension
      let parser = parserType.init(options: options)

      var files = tableFiles[name] ?? []
      if let existing = files.first(where: { $0.path.extension?.lowercased() == fileExtension }) {
        throw ParserError.duplicateTableFile(path: path, existing: existing.path)
      } else {
        files.append((path: path, entries: try parser.parseFile(at: path)))
      }
      tableFiles[name] = files
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

    var tables: [String: [Entry]] {
      tableFiles.mapValues(collectEntries(in:))
    }

    /// Collect all entries spread over multiple files for a table into one collection. Entries from higher priority
    /// parsers will be chosen over other entries (from lower priority parsers) with the same key.
    private func collectEntries(in files: [File]) -> [Entry] {
      // sort files by parser priority (higher priority first)
      let files = files.sorted { lhs, rhs in
        let lhsPriority = parsers[lhs.path.extension?.lowercased() ?? ""]?.priority ?? 0
        let rhsPriority = parsers[rhs.path.extension?.lowercased() ?? ""]?.priority ?? 0
        return lhsPriority > rhsPriority
      }

      // reduce lists of entries into one list, ignoring duplicate keys of later lists
      let entries = files.reduce(into: [String: Entry]()) { result, file in
        for entry in file.entries where result[entry.key] == nil {
          result[entry.key] = entry
        }
      }

      return Array(entries.values)
    }
  }
}
