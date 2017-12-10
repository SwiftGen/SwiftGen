//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct Segue {
    let identifier: String
    let kind: String
    let customClass: String?
    let customModule: String?
    let moduleIsPlaceholder: Bool
    let destination: String
    let platform: Platform
  }
}

// MARK: - SwiftType

extension InterfaceBuilder.Segue: InterfaceBuilderSwiftType {
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

// MARK: - XML

private enum XML {
  static let identifierAttribute = "identifier"
  static let kindAttribute = "kind"
  static let customClassAttribute = "customClass"
  static let customModuleAttribute = "customModule"
  static let customModuleProviderAttribute = "customModuleProvider"
  static let targetValue = "target"
  static let destinationAttribute = "destination"
}

extension InterfaceBuilder.Segue {
  init(with object: Kanna.XMLElement, platform: InterfaceBuilder.Platform) {
    identifier = object[XML.identifierAttribute] ?? ""
    kind = object[XML.kindAttribute] ?? ""
    customClass = object[XML.customClassAttribute]
    customModule = object[XML.customModuleAttribute]
    moduleIsPlaceholder = object[XML.customModuleProviderAttribute] == XML.targetValue
    destination = object[XML.destinationAttribute] ?? ""
    self.platform = platform
  }
}

// MARK: - Hashable

extension InterfaceBuilder.Segue: Equatable {}
extension InterfaceBuilder.Segue: Hashable {}
