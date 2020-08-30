//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import CoreServices
import Foundation
import PathKit

public enum Files {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidFile(path: Path, reason: String)

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "Unable to parse file at \(path). \(reason)"
      }
    }
  }

  public enum Option {
    static let relativeTo = ParserOption(
      key: "relativeTo",
      defaultValue: "",
      help: "Directory which files should be referenced in relation to"
    )
    static let compact = ParserOption(
      key: "compact",
      defaultValue: false,
      help: "Exclude common ancestor directories when parsing a deep hierarchy"
    )
  }

  // MARK: Files Parser

  public final class Parser: SwiftGenKit.Parser {
    internal let options: ParserOptionValues
    var files: [File] = []
    public var warningHandler: Parser.MessageHandler?

    public required init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler
    }

    public static let allOptions: ParserOptionList = [Option.relativeTo, Option.compact]
    public static let defaultFilter: String = ".*"

    public func parse(path: Path, relativeTo parent: Path) throws {
      let option = options[Option.relativeTo]
      let relativeTo = (!option.isEmpty ? option : parent.string)
      try parseInternal(path: path, relativeTo: Path(relativeTo))
    }

    private func parseInternal(path: Path, relativeTo parent: Path) throws {
      if path.isDirectory {
        try path.children().forEach { childPath in
          try parse(path: childPath, relativeTo: parent)
        }
      } else {
        files.append(try File(path: path, relativeTo: parent))
      }
    }
  }
}
