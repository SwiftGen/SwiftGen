//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit
import StoryboardCore

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
    let characterAtlas: CharacterAtlas?
    var storyboards = [Storyboard]()
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Self.allOptions)
      self.warningHandler = warningHandler
      let atlasPath = self.options[Option.characterAtlas].trimmingCharacters(in: .whitespacesAndNewlines)
      if atlasPath.isEmpty {
        characterAtlas = nil
      } else {
        let path = Path(atlasPath)
        do {
          characterAtlas = try CharacterAtlasLoader.load(at: path)
        } catch {
          throw ParserError.invalidFile(path: path, reason: "Character atlas error: \(error)")
        }
      }
    }

    public static let defaultFilter = filterRegex(forExtensions: ["storyboard"])

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
      Set<String>(storyboards.flatMap { $0.modules })
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

extension InterfaceBuilder.Parser {
  enum Option {
    static let characterAtlas = ParserOption<String>(
      key: "characterAtlas",
      defaultValue: "",
      help: "Path to a character atlas file describing characters, voice samples, and relationships."
    )
  }

  public static let allOptions: ParserOptionList = [
    Option.characterAtlas
  ]
}
