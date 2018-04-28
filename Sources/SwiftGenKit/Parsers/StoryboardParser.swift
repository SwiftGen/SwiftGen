//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

func uppercaseFirst(_ string: String) -> String {
  guard let first = string.first else {
    return string
  }
  return String(first).uppercased() + String(string.dropFirst())
}

public enum StoryboardParserError: Error, CustomStringConvertible {
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

private enum XML {
  enum Scene {
    static let initialVCXPath = "/*/@initialViewController"
    static let targetRuntimeXPath = "/*/@targetRuntime"
    static func initialSceneXPath(identifier: String) -> String {
      return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
    }
    static func sceneXPath(initial: String) -> String {
      return """
        /document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and \
        string-length(@storyboardIdentifier) > 0]
        """
    }
    static let placeholderTags = ["controllerPlaceholder", "viewControllerPlaceholder"]
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
  enum Platform: String {
    case tvOS = "AppleTV"
    case iOS = "iOS.CocoaTouch"
    case macOS = "MacOSX.Cocoa"
    case watchOS = "watchKit"

    var name: String {
      switch self {
      case .tvOS:
        return "tvOS"
      case .iOS:
        return "iOS"
      case .macOS:
        return "macOS"
      case .watchOS:
        return "watchOS"
      }
    }

    var prefix: String {
      switch self {
      case .iOS, .tvOS, .watchOS:
        return "UI"
      case .macOS:
        return "NS"
      }
    }

    var module: String {
      switch self {
      case .iOS, .tvOS, .watchOS:
        return "UIKit"
      case .macOS:
        return "AppKit"
      }
    }
  }

  struct Scene {
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let platform: Platform

    init(with object: Kanna.XMLElement, platform: Platform) {
      identifier = object[XML.Scene.storyboardIdentifierAttribute] ?? ""
      tag = object.tagName ?? ""
      customClass = object[XML.Scene.customClassAttribute]
      customModule = object[XML.Scene.customModuleAttribute]
      self.platform = platform
    }

    private static let tagTypeMap = [
      "avPlayerViewController": "AVPlayerViewController",
      "glkViewController": "GLKViewController",
      "pagecontroller": "NSPageController"
    ]

    private static let tagModuleMap = [
      "avPlayerViewController": "AVKit",
      "glkViewController": "GLKit"
    ]

    var type: String {
      if let customClass = customClass {
        return customClass
      } else if let type = Scene.tagTypeMap[tag] {
        return type
      } else {
        return "\(platform.prefix)\(uppercaseFirst(tag))"
      }
    }

    var module: String? {
      if let customModule = customModule {
        return customModule
      } else if let type = Scene.tagModuleMap[tag] {
        return type
      } else if customClass == nil {
        return platform.module
      } else {
        return nil
      }
    }
  }

  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?
    let platform: Platform

    init(with object: Kanna.XMLElement, platform: Platform) {
      identifier = object[XML.Segue.identifierAttribute] ?? ""
      customClass = object[XML.Segue.customClassAttribute]
      customModule = object[XML.Segue.customModuleAttribute]
      self.platform = platform
    }

    var type: String {
      if let customClass = customClass {
        return customClass
      } else {
        return "\(platform.prefix)StoryboardSegue"
      }
    }

    var module: String? {
      if let customModule = customModule {
        return customModule
      } else if customClass == nil {
        return platform.module
      } else {
        return nil
      }
    }
  }

  let name: String
  let platform: Platform
  let initialScene: Scene?
  let scenes: Set<Scene>
  let segues: Set<Segue>

  init(with document: Kanna.XMLDocument, name: String) throws {
    self.name = name

    // TargetRuntime
    let targetRuntime = document.at_xpath(XML.Scene.targetRuntimeXPath)?.text ?? ""
    guard let platform = Platform(rawValue: targetRuntime) else {
      throw StoryboardParserError.unsupportedTargetRuntime(target: targetRuntime)
    }
    self.platform = platform

    // Initial VC
    let initialSceneID = document.at_xpath(XML.Scene.initialVCXPath)?.text ?? ""
    if let object = document.at_xpath(XML.Scene.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboard.Scene(with: object, platform: platform)
    } else {
      initialScene = nil
    }

    // Scenes
    scenes = Set<Storyboard.Scene>(document.xpath(XML.Scene.sceneXPath(initial: initialSceneID)).compactMap {
      guard !XML.Scene.placeholderTags.contains($0.tagName ?? "") else { return nil }
      return Storyboard.Scene(with: $0, platform: platform)
    })

    // Segues
    segues = Set<Storyboard.Segue>(document.xpath(XML.Segue.segueXPath).map {
      Storyboard.Segue(with: $0, platform: platform)
    })
  }

  var modules: Set<String> {
    var result: [String] = scenes.compactMap { $0.module } +
      segues.compactMap { $0.module }

    if let module = initialScene?.module {
      result += [module]
    }

    return Set(result)
  }
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
    do {
      let document = try Kanna.XML(xml: path.read(), encoding: .utf8)

      let name = path.lastComponentWithoutExtension
      let storyboard = try Storyboard(with: document, name: name)
      storyboards += [storyboard]
    } catch let error {
      throw StoryboardParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
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
