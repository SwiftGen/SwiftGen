//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct Scene {
    let sceneID: String
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let moduleIsPlaceholder: Bool
    let segues: Set<Segue>
    let platform: Platform
  }
}

// MARK: - SwiftType

extension InterfaceBuilder.Scene: InterfaceBuilderSwiftType {
  private static let tagTypeMap = [
    "avPlayerViewController": (type: "AVPlayerViewController", module: "AVKit"),
    "glkViewController": (type: "GLKViewController", module: "GLKit"),
    "pagecontroller": (type: "NSPageController", module: nil)
  ]

  var type: String {
    if let customClass = customClass {
      return customClass
    } else if let type = InterfaceBuilder.Scene.tagTypeMap[tag]?.type {
      return type
    } else {
      return "\(platform.prefix)\(tag.uppercasedFirst())"
    }
  }

  var module: String? {
    if let customModule = customModule {
      return customModule
    } else if let type = InterfaceBuilder.Scene.tagTypeMap[tag]?.module {
      return type
    } else if customClass == nil {
      return platform.module
    } else {
      return nil
    }
  }
}

// MARK: - XML

private enum XML {
  static let segueXPath = "//connections/segue"
  static let idAttribute = "id"
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let customModuleProviderAttribute = "customModuleProvider"
  static let storyboardIdentifierAttribute = "storyboardIdentifier"
  static let targetValue = "target"
}

extension InterfaceBuilder.Scene {
  init(with object: Kanna.XMLElement, platform: InterfaceBuilder.Platform) {
    sceneID = object[XML.idAttribute] ?? ""
    identifier = object[XML.storyboardIdentifierAttribute] ?? ""
    tag = object.tagName ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    moduleIsPlaceholder = object[XML.customModuleProviderAttribute] == XML.targetValue
    segues = Set(
      object.xpath(XML.segueXPath).map {
        InterfaceBuilder.Segue(with: $0, platform: platform)
      }
    )
    self.platform = platform
  }
}

// MARK: - Hashable

extension InterfaceBuilder.Scene: Equatable {
  static func == (lhs: InterfaceBuilder.Scene, rhs: InterfaceBuilder.Scene) -> Bool {
    lhs.sceneID == rhs.sceneID
  }
}

extension InterfaceBuilder.Scene: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(sceneID)
  }
}
