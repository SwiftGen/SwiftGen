//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Colors {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidHexColor(path: Path, string: String, key: String?)
    case invalidFile(path: Path, reason: String)
    case unsupportedFileType(path: Path, supported: [String])

    public var description: String {
      switch self {
      case .invalidHexColor(let path, let string, let key):
        let keyInfo = key.flatMap { " for key \"\($0)\"" } ?? ""
        return "error: Invalid hex color \"\(string)\" found\(keyInfo) (\(path))."
      case .invalidFile(let path, let reason):
        return "error: Unable to parse file at \(path). \(reason)"
      case .unsupportedFileType(let path, let supported):
        return """
          error: Unsupported file type for \(path). \
          The supported file types are: \(supported.joined(separator: ", "))
          """
      }
    }
  }

  public final class Parser: SwiftGenKit.Parser {
    private var parsers = [String: ColorsFileTypeParser.Type]()
    private let options: ParserOptionValues
    var palettes = [Palette]()
    public var warningHandler: Parser.MessageHandler?

    private static let subParsers: [ColorsFileTypeParser.Type] = [
      CLRFileParser.self,
      JSONFileParser.self,
      TextFileParser.self,
      XMLFileParser.self
    ]

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler

      for parser in Parser.subParsers {
        register(parser: parser)
      }
    }

    public static var defaultFilter: String {
      let extensions = Parser.subParsers.flatMap { $0.extensions }.sorted().joined(separator: "|")
      return "[^/]\\.(?i:\(extensions))$"
    }

    public static var allOptions: ParserOptionList {
      return ParserOptionList(lists: Parser.subParsers.map { $0.allOptions })
    }

    public func parse(path: Path, relativeTo parent: Path) throws {
      guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
        throw ParserError.unsupportedFileType(path: path, supported: parsers.keys.sorted())
      }

      let parser = parserType.init(options: options)
      let palette = try parser.parseFile(at: path)
      palettes += [palette]
    }

    func register(parser: ColorsFileTypeParser.Type) {
      for ext in parser.extensions {
        if let old = parsers[ext] {
          warningHandler?("""
            error: Parser \(parser) tried to register the file type '\(ext)' already \
            registered by \(old).
            """,
            #file,
            #line)
        }
        parsers[ext] = parser
      }
    }
  }
}
