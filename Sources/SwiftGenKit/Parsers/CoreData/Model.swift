//
//  Model.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Kanna

extension CoreData {
  public struct Model {
    public let entities: [Entity]

  }
}

private enum XML {
  static let entitiesPath = "/model/entity"
}

extension CoreData.Model {
  init(with document: Kanna.XMLDocument) throws {
    entities = try document.xpath(XML.entitiesPath).map(CoreData.Entity.init(with:))

    let entitiesByName = Dictionary(entities.map { ($0.name, $0) }) { first, _ in first }

    try entities.forEach { entity in
      entity.superentity = entity.superentityName.flatMap { entitiesByName[$0] }

      try entity.relationships.forEach { relationship in
        relationship.destinationEntity = entitiesByName[relationship.destinationEntityName]

        if let inverseRelationshipInformation = relationship.inverseRelationshipInformation {
          let inverseRelationshipEntityName = inverseRelationshipInformation.entityName
          guard let inverseRelationshipEntity = entitiesByName[inverseRelationshipEntityName] else {
            throw CoreData.ParserError.invalidFormat(
              reason: "Unknown entity name \(inverseRelationshipEntityName) found as inverse relationship entity"
            )
          }

          let inverseRelationshipName = inverseRelationshipInformation.name
          guard let inverseRelationship = inverseRelationshipEntity.relationships
                                            .first(where: { $0.name == inverseRelationshipInformation.name }) else {
            throw CoreData.ParserError.invalidFormat(
              reason: "Unknown relationship \(inverseRelationshipName) found as inverse realtionship name"
            )
          }

          relationship.inverseRelationship = inverseRelationship
          inverseRelationship.inverseRelationship = relationship
        }
      }
    }
  }
}
