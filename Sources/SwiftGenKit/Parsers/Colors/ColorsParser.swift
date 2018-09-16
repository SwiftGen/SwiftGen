//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
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
    var palettes = [Palette]()
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler

      register(parser: CLRFileParser.self)
      register(parser: JSONFileParser.self)
      register(parser: TextFileParser.self)
      register(parser: XMLFileParser.self)
    }

    public func parse(path: Path) throws {
      guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
        throw ParserError.unsupportedFileType(path: path, supported: Array(parsers.keys))
      }

      let parser = parserType.init()
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
