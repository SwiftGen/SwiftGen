//
//  Relationship.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/19/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

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

