//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

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
        .map(map(scene:)),
      "segues": storyboard.segues
        .sorted { $0.identifier < $1.identifier }
        .map(map(segue:)),
      "platform": storyboard.platform.name
    ]

    if let scene = storyboard.initialScene {
      result["initialScene"] = map(scene: scene)
    }

    return result
  }

  private func map(scene: InterfaceBuilder.Scene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "identifier": scene.identifier,
        "customClass": customClass,
        "customModule": scene.customModule ?? "",
        "type": scene.type,
        "module": scene.module ?? "",
        "moduleIsPlaceholder": scene.moduleIsPlaceholder
      ]
    } else {
      return [
        "identifier": scene.identifier,
        "baseType": scene.tag.uppercasedFirst(),
        "type": scene.type,
        "module": scene.module ?? "",
        "moduleIsPlaceholder": scene.moduleIsPlaceholder
      ]
    }
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
