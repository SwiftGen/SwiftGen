//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct Scene {
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let moduleIsPlaceholder: Bool
    let platform: Platform

    private static let tagTypeMap = [
      "avPlayerViewController": (type: "AVPlayerViewController", module: "AVKit"),
      "glkViewController": (type: "GLKViewController", module: "GLKit"),
      "pagecontroller": (type: "NSPageController", module: nil)
    ]

    var type: String {
      if let customClass = customClass {
        return customClass
      } else if let type = Scene.tagTypeMap[tag]?.type {
        return type
      } else {
        return "\(platform.prefix)\(tag.uppercasedFirst())"
      }
    }

    var module: String? {
      if let customModule = customModule {
        return customModule
      } else if let type = Scene.tagTypeMap[tag]?.module {
        return type
      } else if customClass == nil {
        return platform.module
      } else {
        return nil
      }
    }
  }
}

// MARK: - XML

private enum XML {
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let customModuleProviderAttribute = "customModuleProvider"
  static let storyboardIdentifierAttribute = "storyboardIdentifier"
  static let targetValue = "target"
}

extension InterfaceBuilder.Scene {
  init(with object: Kanna.XMLElement, platform: InterfaceBuilder.Platform) {
    identifier = object[XML.storyboardIdentifierAttribute] ?? ""
    tag = object.tagName ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    moduleIsPlaceholder = object[XML.customModuleProviderAttribute] == XML.targetValue
    self.platform = platform
  }
}

// MARK: - Hashable

extension InterfaceBuilder.Scene: Equatable { }
func == (lhs: InterfaceBuilder.Scene, rhs: InterfaceBuilder.Scene) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.tag == rhs.tag &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule &&
    lhs.moduleIsPlaceholder == rhs.moduleIsPlaceholder &&
    lhs.platform == rhs.platform
}

extension InterfaceBuilder.Scene: Hashable {
  var hashValue: Int {
    let part1: Int = identifier.hashValue ^ tag.hashValue
    let part2: Int = (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
    let part3: Int = moduleIsPlaceholder.hashValue ^ platform.hashValue
    return part1 ^ part2 ^ part3
  }
}
