//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension Storyboards {
  struct Storyboard {
    let name: String
    let platform: Platform
    let initialScene: Scene?
    let scenes: Set<Scene>
    let segues: Set<Segue>

    var modules: Set<String> {
      var result: [String] = scenes.compactMap { $0.module } +
        segues.compactMap { $0.module }

      if let module = initialScene?.module {
        result += [module]
      }

      return Set(result)
    }
  }
}

// MARK: - XML

private enum XML {
  static let initialVCXPath = "/*/@initialViewController"
  static let targetRuntimeXPath = "/*/@targetRuntime"

  static func initialSceneXPath(identifier: String) -> String {
    return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
  }
  static let sceneXPath = """
    /document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and \
    string-length(@storyboardIdentifier) > 0]
    """
  static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"

  static let placeholderTags = ["controllerPlaceholder", "viewControllerPlaceholder"]
}

extension Storyboards.Storyboard {
  init(with document: Kanna.XMLDocument, name: String) throws {
    self.name = name

    // TargetRuntime
    let targetRuntime = document.at_xpath(XML.targetRuntimeXPath)?.text ?? ""
    guard let platform = Storyboards.Platform(rawValue: targetRuntime) else {
      throw Storyboards.ParserError.unsupportedTargetRuntime(target: targetRuntime)
    }
    self.platform = platform

    // Initial VC
    let initialSceneID = document.at_xpath(XML.initialVCXPath)?.text ?? ""
    if let object = document.at_xpath(XML.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboards.Scene(with: object, platform: platform)
    } else {
      initialScene = nil
    }

    // Scenes
    scenes = Set<Storyboards.Scene>(document.xpath(XML.sceneXPath).compactMap {
      guard !XML.placeholderTags.contains($0.tagName ?? "") else { return nil }
      return Storyboards.Scene(with: $0, platform: platform)
    })

    // Segues
    segues = Set<Storyboards.Segue>(document.xpath(XML.segueXPath).map {
      Storyboards.Segue(with: $0, platform: platform)
    })
  }
}
