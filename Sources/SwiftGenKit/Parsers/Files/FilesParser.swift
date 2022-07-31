//
// SwiftGenKit
// Copyright © 2022 SwiftGen
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

  // MARK: Files Parser

  public final class Parser: SwiftGenKit.Parser {
    var files: [String: [File]] = [:]
    internal let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public required init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Self.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter: String = ".*"

    public func parse(path: Path, relativeTo parent: Path) throws {
      files[parent.lastComponent, default: []].append(try File(path: path, relativeTo: parent))
    }
  }
}
