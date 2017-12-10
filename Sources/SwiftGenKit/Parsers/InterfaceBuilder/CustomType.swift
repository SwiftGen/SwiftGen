//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension InterfaceBuilder {
  struct CustomType: InterfaceBuilderSwiftType {
    let type: String
    let module: String?
    let moduleIsPlaceholder: Bool
    var segues = Set<Segue>()
    var destinations = [Segue: Scene]()

    init(scene: Scene) {
      type = scene.type
      module = scene.moduleIsPlaceholder ? "<placeholder>" : scene.module
      moduleIsPlaceholder = scene.moduleIsPlaceholder
    }

    mutating func add(segue: Segue, destination: Scene?, warningHandler: Parser.MessageHandler?) {
      segues.insert(segue)

      // store destination, or check it's at least the same type
      if let destination = destination {
        if let current = destinations[segue] {
          if !areEqual(current, destination) {
            let message = "warning: The segue with identifier '\(segue.identifier)' in \(module ?? "").\(type) has " +
              "multiple destination types: \(destination.module ?? "").\(destination.type) and " +
              "\(destination.module ?? "").\(destination.type)."
            warningHandler?(message, #file, #line)
          }
        } else {
          destinations[segue] = destination
        }
      }
    }

    private func areEqual(_ lhs: Scene, _ rhs: Scene) -> Bool {
      lhs.tag != rhs.tag ||
        lhs.customClass != rhs.customClass ||
        lhs.customModule != rhs.customModule
    }
  }
}

extension InterfaceBuilder.Parser {
  var customSceneTypes: [InterfaceBuilder.CustomType] {
    var result: [String: InterfaceBuilder.CustomType] = [:]

    // collect scenes by custom type
    for storyboard in storyboards {
      for scene in storyboard.scenes where scene.customClass != nil {
        let key = InterfaceBuilder.Parser.identifier(for: scene)
        var customType = result[key] ?? InterfaceBuilder.CustomType(scene: scene)

        for segue in scene.segues {
          let destination = self.destination(for: segue.destination, in: storyboard)
          customType.add(segue: segue, destination: destination, warningHandler: warningHandler)
        }

        result[key] = customType
      }
    }

    return result
      .sorted { $0.0 < $1.0 }
      .map { _, value in value }
  }

  private static func identifier(for scene: InterfaceBuilder.Scene) -> String {
    let module = scene.moduleIsPlaceholder ? "<placeholder>" : scene.module
    return "\(module ?? "").\(scene.type)"
  }
}
