//
//  Relationship.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/19/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

extension CoreData {
  public final class Relationship {
    typealias InverseRelationshipInformation = (name: String, entityName: String)

    public let name: String
    public let isIndexed: Bool
    public let isOptional: Bool
    public var isTransient: Bool

    public let isToMany: Bool
    public let isOrdered: Bool

    public weak internal(set) var destinationEntity: Entity?
    public weak internal(set) var inverseRelationship: Relationship?

    let destinationEntityName: String
    let inverseRelationshipInformation: InverseRelationshipInformation?

    init(
      name: String,
      isIndexed: Bool,
      isOptional: Bool,
      isTransient: Bool,
      isToMany: Bool,
      isOrdered: Bool,
      destinationEntityName: String,
      inverseRelationshipInformation: InverseRelationshipInformation?
      ) {
      self.name = name
      self.isIndexed = isIndexed
      self.isOptional = isOptional
      self.isTransient = isTransient
      self.isToMany = isToMany
      self.isOrdered = isOrdered
      self.destinationEntityName = destinationEntityName
      self.inverseRelationshipInformation = inverseRelationshipInformation
    }
  }
}

private enum XML {
  static let nameAttribute = "name"
  static let isIndexedAttribute = "indexed"
  static let isOptionalAttribute = "optional"
  static let isTransientAttribute = "transient"

  static let isToManyAttribute = "toMany"
  static let isOrderedAttribute = "ordered"

  static let destinationEntityNameAttribute = "destinationEntity"
  static let inverseRelationshipNameAttribute = "inverseName"
  static let inverseRelationshipEntityNameAttribute = "inverseEntity"
}

extension CoreData.Relationship {
  convenience init(with object: Kanna.XMLElement) throws {
    let name = object[XML.nameAttribute] ?? ""
    let isIndexed = object[XML.isIndexedAttribute].flatMap(Bool.init(from:)) ?? false
    let isOptional = object[XML.isOptionalAttribute].flatMap(Bool.init(from:)) ?? false
    let isTransient = object[XML.isTransientAttribute].flatMap(Bool.init(from:)) ?? false

    let isToMany = object[XML.isToManyAttribute].flatMap(Bool.init(from:)) ?? false
    let isOrdered = object[XML.isOrderedAttribute].flatMap(Bool.init(from:)) ?? false

    guard let destinationEntityName = object[XML.destinationEntityNameAttribute] else {
      throw CoreData.ParserError.invalidFormat(reason: "Missing required destination entity name")
    }

    let inverseRelationshipName = object[XML.inverseRelationshipNameAttribute]
    let inverseRelationshipEntityName = object[XML.inverseRelationshipEntityNameAttribute]

    let inverseRelationshipInformation: InverseRelationshipInformation?
    switch (inverseRelationshipName, inverseRelationshipEntityName) {
    case (.none, .none):
      inverseRelationshipInformation = nil
    case (.none, _), (_, .none):
      throw CoreData.ParserError.invalidFormat(
        reason: "Both the name and entity name are required for inverse relationships"
      )
    case let (.some(name), .some(entityName)):
      inverseRelationshipInformation = (name: name, entityName: entityName)
    }

    self.init(
      name: name,
      isIndexed: isIndexed,
      isOptional: isOptional,
      isTransient: isTransient,
      isToMany: isToMany,
      isOrdered: isOrdered,
      destinationEntityName: destinationEntityName,
      inverseRelationshipInformation: inverseRelationshipInformation
    )
  }
}
