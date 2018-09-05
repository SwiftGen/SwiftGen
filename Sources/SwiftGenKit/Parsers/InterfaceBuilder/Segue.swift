//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?
    let moduleIsPlaceholder: Bool
    let platform: Platform

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
}

// MARK: - XML

private enum XML {
  static let identifierAttribute = "identifier"
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let customModuleProviderAttribute = "customModuleProvider"
  static let targetValue = "target"
}

extension InterfaceBuilder.Segue {
  init(with object: Kanna.XMLElement, platform: InterfaceBuilder.Platform) {
    identifier = object[XML.identifierAttribute] ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    moduleIsPlaceholder = object[XML.customModuleProviderAttribute] == XML.targetValue
    self.platform = platform
  }
}

// MARK: - Hashable

extension InterfaceBuilder.Segue: Equatable { }
func == (lhs: InterfaceBuilder.Segue, rhs: InterfaceBuilder.Segue) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule &&
    lhs.moduleIsPlaceholder == rhs.moduleIsPlaceholder &&
    lhs.platform == rhs.platform
}

extension InterfaceBuilder.Segue: Hashable {
  var hashValue: Int {
    let part1: Int = identifier.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
    let part2: Int = moduleIsPlaceholder.hashValue ^ platform.hashValue
    return part1 ^ part2
  }
}
