//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

func uppercaseFirst(_ string: String) -> String {
  guard let first = string.first else {
    return string
  }
  return String(first).uppercased() + String(string.dropFirst())
}

extension Storyboard {
  struct Scene {
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let platform: Platform

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
}

// MARK: - XML

private enum XML {
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let storyboardIdentifierAttribute = "storyboardIdentifier"
}

extension Storyboard.Scene {
  init(with object: Kanna.XMLElement, platform: Storyboard.Platform) {
    identifier = object[XML.storyboardIdentifierAttribute] ?? ""
    tag = object.tagName ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    self.platform = platform
  }
}

// MARK: - Hashable

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
