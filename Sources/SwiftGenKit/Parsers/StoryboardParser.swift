//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

private enum XML {
  enum Scene {
    static let initialVCXPath = "/*/@initialViewController"
    static let targetRuntimeXPath = "/*/@targetRuntime"
    static func initialSceneXPath(identifier: String) -> String {
      return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
    }
    static func sceneXPath(initial: String) -> String {
      return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and " +
        "string-length(@storyboardIdentifier) > 0]"
    }
    static let placeholderTag = "viewControllerPlaceholder"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
    static let storyboardIdentifierAttribute = "storyboardIdentifier"
  }
  enum Segue {
    static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"
    static let identifierAttribute = "identifier"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
  }
}

struct Storyboard {
  struct Scene {
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?

    init(with object: Kanna.XMLElement) {
      identifier = object[XML.Scene.storyboardIdentifierAttribute] ?? ""
      tag = object.tagName ?? ""
      customClass = object[XML.Scene.customClassAttribute]
      customModule = object[XML.Scene.customModuleAttribute]
    }
  }

  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?

    init(with object: Kanna.XMLElement) {
      identifier = object[XML.Segue.identifierAttribute] ?? ""
      customClass = object[XML.Segue.customClassAttribute]
      customModule = object[XML.Segue.customModuleAttribute]
    }
  }

  let name: String
  let platform: String
  let initialScene: Scene?
  let scenes: Set<Scene>
  let segues: Set<Segue>
}

public final class StoryboardParser: Parser {
  var storyboards = [Storyboard]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    if path.extension == "storyboard" {
      try addStoryboard(at: path)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

      for file in dirChildren where file.extension == "storyboard" {
        try addStoryboard(at: file)
      }
    }
  }

  func addStoryboard(at path: Path) throws {
    let document: Kanna.XMLDocument
    do {
      document = try Kanna.XML(xml: path.read(), encoding: .utf8)
    } catch let error {
      throw ColorsParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
    }

    // Initial VC
    let initialSceneID = document.at_xpath(XML.Scene.initialVCXPath)?.text ?? ""
    var initialScene: Storyboard.Scene? = nil
    if let object = document.at_xpath(XML.Scene.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboard.Scene(with: object)
    }

    // Scenes
    let scenes = Set<Storyboard.Scene>(document.xpath(XML.Scene.sceneXPath(initial: initialSceneID)).flatMap {
      guard $0.tagName != XML.Scene.placeholderTag else { return nil }
      return Storyboard.Scene(with: $0)
    })

    // Segues
    let segues = Set<Storyboard.Segue>(document.xpath(XML.Segue.segueXPath).map {
      Storyboard.Segue(with: $0)
    })

    // TargetRuntime
    let mapping = [
      "AppleTV": "tvOS",
      "iOS.CocoaTouch": "iOS",
      "MacOSX.Cocoa": "macOS",
      "watchKit": "watchOS"
    ]
    let targetRuntime = document.at_xpath(XML.Scene.targetRuntimeXPath)?.text ?? ""
    let platform = mapping[targetRuntime] ?? targetRuntime

    storyboards += [Storyboard(name: path.lastComponentWithoutExtension,
                               platform: platform,
                               initialScene: initialScene,
                               scenes: scenes,
                               segues: segues)]
  }

  var modules: Set<String> {
    return Set<String>(storyboards.flatMap(collectModules(from:)))
  }

  private func collectModules(from storyboard: Storyboard) -> [String] {
    var result: [String] = storyboard.scenes.flatMap { $0.customModule } +
      storyboard.segues.flatMap { $0.customModule }

    if let module = storyboard.initialScene?.customModule {
      result += [module]
    }

    return result
  }

  var platform: String? {
    let platforms = Set<String>(storyboards.map { $0.platform })

    if platforms.count > 1 {
      return nil
    } else {
      return platforms.first
    }
  }
}

extension Storyboard.Scene: Equatable { }
func == (lhs: Storyboard.Scene, rhs: Storyboard.Scene) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.tag == rhs.tag &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension Storyboard.Scene: Hashable {
  var hashValue: Int {
    return identifier.hashValue ^ tag.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}

extension Storyboard.Segue: Equatable { }
func == (lhs: Storyboard.Segue, rhs: Storyboard.Segue) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension Storyboard.Segue: Hashable {
  var hashValue: Int {
    return identifier.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}
