//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct Storyboard {
    let name: String
    let platform: Platform
    let initialScene: Scene?
    let scenes: Set<Scene>
    let segues: Set<Segue>
    let placeholders: Set<ScenePlaceholder>

    var modules: Set<String> {
      var result: [String] = [platform.module] +
        scenes.filter { !$0.moduleIsPlaceholder }.compactMap { $0.module } +
        segues.filter { !$0.moduleIsPlaceholder }.compactMap { $0.module }

      if let scene = initialScene, let module = scene.module, !scene.moduleIsPlaceholder {
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
    "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
  }
  static let sceneXPath = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
  static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"

  static let placeholderTags = ["controllerPlaceholder", "viewControllerPlaceholder"]
}

extension InterfaceBuilder.Storyboard {
  init(with document: Kanna.XMLDocument, name: String) throws {
    self.name = name

    // TargetRuntime
    let targetRuntime = document.at_xpath(XML.targetRuntimeXPath)?.text ?? ""
    guard let platform = InterfaceBuilder.Platform(runtime: targetRuntime) else {
      throw InterfaceBuilder.ParserError.unsupportedTargetRuntime(target: targetRuntime)
    }
    self.platform = platform

    // Initial VC
    let initialSceneID = document.at_xpath(XML.initialVCXPath)?.text ?? ""
    if let object = document.at_xpath(XML.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = InterfaceBuilder.Scene(with: object, platform: platform)
    } else {
      initialScene = nil
    }

    // Scenes
    var scenes = Set<InterfaceBuilder.Scene>()
    var placeholders = Set<InterfaceBuilder.ScenePlaceholder>()
    for node in document.xpath(XML.sceneXPath) {
      if XML.placeholderTags.contains(node.tagName ?? "") {
        placeholders.insert(InterfaceBuilder.ScenePlaceholder(with: node, storyboard: name))
      } else {
        scenes.insert(InterfaceBuilder.Scene(with: node, platform: platform))
      }
    }
    self.scenes = scenes
    self.placeholders = placeholders

    // Segues
    segues = Set<InterfaceBuilder.Segue>(
      document.xpath(XML.segueXPath).map {
        InterfaceBuilder.Segue(with: $0, platform: platform)
      }
    )
  }
}
