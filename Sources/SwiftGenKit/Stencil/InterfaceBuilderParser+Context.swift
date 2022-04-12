//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension Dictionary {
  fileprivate func merging(_ other: [Key: Value]) -> [Key: Value] {
    merging(other) { current, _ in
      current
    }
  }
}

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
      "customSceneTypes": customSceneTypes
        .map { map(customType: $0) },
      "platform": platform ?? ""
    ]
  }

  private func map(storyboard: InterfaceBuilder.Storyboard) -> [String: Any] {
    var result: [String: Any] = [
      "name": storyboard.name,
      "scenes": Array(storyboard.scenes)
        .filter { !$0.identifier.isEmpty }
        .sorted { $0.identifier < $1.identifier }
        .map { map(scene: $0) },
      "segues": Array(storyboard.segues)
        .filter { !$0.identifier.isEmpty }
        .sorted { $0.identifier < $1.identifier }
        .map { map(segue: $0, in: storyboard) },
      "platform": storyboard.platform.name
    ]

    if let scene = storyboard.initialScene {
      result["initialScene"] = map(scene: scene)
    }

    return result
  }

  private func map(scene: InterfaceBuilder.Scene) -> [String: Any] {
    let result = map(swiftType: scene)

    if let customClass = scene.customClass {
      return result.merging(
        [
          "identifier": scene.identifier,
          "customClass": customClass,
          "customModule": scene.customModule ?? ""
        ]
      )
    } else {
      return result.merging(
        [
          "identifier": scene.identifier,
          "baseType": scene.tag.uppercasedFirst()
        ]
      )
    }
  }

  private func map(segue: InterfaceBuilder.Segue, in storyboard: InterfaceBuilder.Storyboard) -> [String: Any] {
    let scene = destination(for: segue.destination, in: storyboard)
    return map(segue: segue, destination: scene)
  }

  private func map(segue: InterfaceBuilder.Segue, destination: InterfaceBuilder.Scene?) -> [String: Any] {
    var result = map(swiftType: segue).merging(
      [
        "identifier": segue.identifier,
        "kind": segue.kind,
        "customClass": segue.customClass ?? "",
        "customModule": segue.customModule ?? ""
      ]
    )

    if let destination = destination {
      result["destination"] = map(scene: destination)
    }

    return result
  }

  private func map(customType: InterfaceBuilder.CustomType) -> [String: Any] {
    let sortedSegues = customType.segues
      .sorted { $0.identifier < $1.identifier }
      .map { segue -> Any in
        let destination = customType.destinations[segue]
        return map(segue: segue, destination: destination)
      }

    return map(swiftType: customType).merging(["segues": sortedSegues])
  }

  private func map(swiftType: InterfaceBuilderSwiftType) -> [String: Any] {
    [
      "type": swiftType.type,
      "module": swiftType.module ?? "",
      "moduleIsPlaceholder": swiftType.moduleIsPlaceholder
    ]
  }
}
