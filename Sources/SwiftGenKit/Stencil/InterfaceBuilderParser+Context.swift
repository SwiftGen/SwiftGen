//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import StoryboardCore

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/ib.md
//

extension InterfaceBuilder.Parser {
  public func stencilContext() -> [String: Any] {
    let storyboards = self.storyboards
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map(map(storyboard:))
    return [
      "modules": modules.sorted(),
      "storyboards": storyboards,
      "platform": platform ?? ""
    ]
  }

  private func map(storyboard: InterfaceBuilder.Storyboard) -> [String: Any] {
    var result: [String: Any] = [
      "name": storyboard.name,
      "scenes": storyboard.scenes
        .sorted { $0.identifier < $1.identifier }
        .map { map(scene: $0, storyboardName: storyboard.name) },
      "segues": storyboard.segues
        .sorted { $0.identifier < $1.identifier }
        .map(map(segue:)),
      "platform": storyboard.platform.name
    ]

    if let scene = storyboard.initialScene {
      result["initialScene"] = map(scene: scene, storyboardName: storyboard.name)
    }

    return result
  }

  private func map(scene: InterfaceBuilder.Scene, storyboardName: String) -> [String: Any] {
    var result: [String: Any]

    if let customClass = scene.customClass {
      result = [
        "identifier": scene.identifier,
        "customClass": customClass,
        "customModule": scene.customModule ?? "",
        "type": scene.type,
        "module": scene.module ?? "",
        "moduleIsPlaceholder": scene.moduleIsPlaceholder
      ]
    } else {
      result = [
        "identifier": scene.identifier,
        "baseType": scene.tag.uppercasedFirst(),
        "type": scene.type,
        "module": scene.module ?? "",
        "moduleIsPlaceholder": scene.moduleIsPlaceholder
      ]
    }

    if let primer = characterAtlas?.promptPrimer(forScene: scene.identifier, storyboardName: storyboardName) {
      let prompt = primer.renderPrompt()
      if !prompt.isEmpty {
        result["characterPrompt"] = prompt
      }
      result["characterAtlas"] = primer.contextDictionary()
    }

    return result
  }

  private func map(segue: InterfaceBuilder.Segue) -> [String: Any] {
    [
      "identifier": segue.identifier,
      "customClass": segue.customClass ?? "",
      "customModule": segue.customModule ?? "",
      "type": segue.type,
      "module": segue.module ?? "",
      "moduleIsPlaceholder": segue.moduleIsPlaceholder
    ]
  }
}
