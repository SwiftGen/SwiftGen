//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

public enum InterfaceBuilder {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidFile(path: Path, reason: String)
    case unsupportedTargetRuntime(target: String)

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "error: Unable to parse file at \(path). \(reason)"
      case .unsupportedTargetRuntime(let target):
        return "Unsupported target runtime `\(target)`."
      }
    }
  }

  public final class Parser: SwiftGenKit.Parser {
    private let options: ParserOptionValues
    var storyboards = [Storyboard]()
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Parser.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = "[^/]\\.storyboard$"

    public func parse(path: Path, relativeTo parent: Path) throws {
      try addStoryboard(at: path)
    }

    func addStoryboard(at path: Path) throws {
      do {
        let document = try Kanna.XML(xml: path.read(), encoding: .utf8)

        let name = path.lastComponentWithoutExtension
        let storyboard = try Storyboard(with: document, name: name)
        storyboards += [storyboard]
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
      }
    }

    var modules: Set<String> {
      return Set<String>(storyboards.flatMap { $0.modules })
    }

    var platform: String? {
      let platforms = Set<String>(storyboards.map { $0.platform.name })

      if platforms.count > 1 {
        return nil
      } else {
        return platforms.first
      }
    }
  }
}
