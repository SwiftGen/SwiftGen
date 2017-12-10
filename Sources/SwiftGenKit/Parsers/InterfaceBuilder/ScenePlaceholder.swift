//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension InterfaceBuilder {
  struct ScenePlaceholder {
    let sceneID: String
    let storyboardName: String
    let referencedIdentifier: String?
  }
}

// MARK: - XML

private enum XML {
  static let idAttribute = "id"
  static let storyboardNameAttribute = "storyboardName"
  static let referencedIdentifierAttribute = "referencedIdentifier"
}

extension InterfaceBuilder.ScenePlaceholder {
  init(with object: Kanna.XMLElement, storyboard: String) {
    sceneID = object[XML.idAttribute] ?? ""
    storyboardName = object[XML.storyboardNameAttribute] ?? storyboard
    referencedIdentifier = object[XML.referencedIdentifierAttribute]
  }
}

// MARK: - Hashable

extension InterfaceBuilder.ScenePlaceholder: Equatable {
  static func == (lhs: InterfaceBuilder.ScenePlaceholder, rhs: InterfaceBuilder.ScenePlaceholder) -> Bool {
    lhs.sceneID == rhs.sceneID
  }
}

extension InterfaceBuilder.ScenePlaceholder: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(sceneID)
  }
}
