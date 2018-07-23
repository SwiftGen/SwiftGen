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
    public let configurations: [String: [Entity]]
    public let fetchRequests: [FetchRequest]
    public let fetchRequestsByEntityName: [String: [FetchRequest]]
  }
}

private enum XML {
  static let entitiesPath = "/model/entity"
  static let configurationsPath = "/model/configuration"
  static let fetchRequestsPath = "/model/fetchRequest"
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

    configurations = try document.xpath(XML.configurationsPath)
                                .reduce(into: ["Default": entities]) { configurations, element in
                                  let (name, entityNames) = try CoreData.Configuration.parse(from: element)
                                  configurations[name] = try entityNames.map { entityName in
                                    guard let entity = entitiesByName[entityName] else {
                                      throw CoreData.ParserError.invalidFormat(reason: "Unknown entity \(entityName).")
                                    }

                                    return entity
                                  }
                                }

    fetchRequests = try document.xpath(XML.fetchRequestsPath).map(CoreData.FetchRequest.init(with:))
    try fetchRequests.forEach { fetchRequest in
      guard let entity = entitiesByName[fetchRequest.entityName] else {
        throw CoreData.ParserError.invalidFormat(reason: "Unknown entity \(fetchRequest.entityName).")
      }

      fetchRequest.entity = entity
    }

    fetchRequestsByEntityName = Dictionary(grouping: fetchRequests) { $0.entityName }
  }
}
