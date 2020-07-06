//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

extension CoreData {
  public struct Relationship {
    public typealias InverseRelationship = (name: String, entityName: String)

    public let name: String
    public let isIndexed: Bool
    public let isOptional: Bool
    public var isTransient: Bool
    public let isToMany: Bool
    public let isOrdered: Bool
    public let userInfo: [String: Any]
    public let destinationEntity: String
    public let inverseRelationship: InverseRelationship?
  }
}

private enum XML {
  fileprivate enum Attributes {
    static let name = "name"
    static let isIndexed = "indexed"
    static let isOptional = "optional"
    static let isTransient = "transient"
    static let isToMany = "toMany"
    static let isOrdered = "ordered"
    static let destinationEntity = "destinationEntity"
    static let inverseRelationshipName = "inverseName"
    static let inverseRelationshipEntityName = "inverseEntity"
  }

  static let userInfoPath = "userInfo"
}

extension CoreData.Relationship {
  init(with object: Kanna.XMLElement) throws {
    guard let name = object[XML.Attributes.name] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required relationship name.")
    }

    guard let destinationEntity = object[XML.Attributes.destinationEntity] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required destination entity name")
    }

    let isIndexed = object[XML.Attributes.isIndexed].flatMap(Bool.init(from:)) ?? false
    let isOptional = object[XML.Attributes.isOptional].flatMap(Bool.init(from:)) ?? false
    let isTransient = object[XML.Attributes.isTransient].flatMap(Bool.init(from:)) ?? false
    let isToMany = object[XML.Attributes.isToMany].flatMap(Bool.init(from:)) ?? false
    let isOrdered = object[XML.Attributes.isOrdered].flatMap(Bool.init(from:)) ?? false

    let inverseRelationshipName = object[XML.Attributes.inverseRelationshipName]
    let inverseRelationshipEntityName = object[XML.Attributes.inverseRelationshipEntityName]
    let inverseRelationship: InverseRelationship?
    switch (inverseRelationshipName, inverseRelationshipEntityName) {
    case (.none, .none):
      inverseRelationship = nil
    case (.none, _), (_, .none):
      throw CoreData.ParserError.invalidFormat(
        reason: "Both the name and entity name are required for inverse relationships"
      )
    case let (.some(name), .some(entityName)):
      inverseRelationship = (name: name, entityName: entityName)
    }

    let userInfo = try object.at_xpath(XML.userInfoPath).map { try CoreData.UserInfo.parse(from: $0) } ?? [:]

    self.init(
      name: name,
      isIndexed: isIndexed,
      isOptional: isOptional,
      isTransient: isTransient,
      isToMany: isToMany,
      isOrdered: isOrdered,
      userInfo: userInfo,
      destinationEntity: destinationEntity,
      inverseRelationship: inverseRelationship
    )
  }
}
