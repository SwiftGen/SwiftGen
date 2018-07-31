//
//  CoreDataContext.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

extension CoreData.Parser {
  public func stencilContext() -> [String: Any] {
    return [
      "models": models.map(map)
    ]
  }

  private func map(_ model: CoreData.Model) -> [String: Any] {
    return [
      "configurations": model.configurations,
      "entities": model.entities.mapValues(map),
      "fetchRequests": model.fetchRequests.map(map),
      "fetchRequestsByEntityName": model.fetchRequestsByEntityName.mapValues { $0.map(map) }
    ]
  }

  private func map(_ entity: CoreData.Entity) -> [String: Any] {
    return [
      "name": entity.name,
      "className": entity.className,
      "isAbstract": entity.isAbstract,
      "userInfo": entity.userInfo,
      "superentity": entity.superentity ?? "",
      "attributes": entity.attributes.map(map),
      "relationships": entity.relationships.map(map)
    ]
  }

  private func map(_ attribute: CoreData.Attribute) -> [String: Any] {
    return [
      "name": attribute.name,
      "isIndexed": attribute.isIndexed,
      "isOptional": attribute.isOptional,
      "isTransient": attribute.isTransient,
      "usesScalarValueType": attribute.usesScalarValueType,
      "type": attribute.type.rawValue,
      "customClassName": attribute.customClassName ?? "",
      "typeName": attribute.typeName,
      "userInfo": attribute.userInfo
    ]
  }

  private func map(_ relationship: CoreData.Relationship) -> [String: Any] {
    return [
      "name": relationship.name,
      "isIndexed": relationship.isIndexed,
      "isOptional": relationship.isOptional,
      "isTransient": relationship.isTransient,
      "isToMany": relationship.isToMany,
      "isOrdered": relationship.isOrdered,
      "destinationEntity": relationship.destinationEntity,
      "inverseRelationship": relationship.inverseRelationship.map {
        [
          "name": $0.name,
          "entityName": $0.entityName
        ]
      } as Any,
      "userInfo": relationship.userInfo
    ]
  }

  private func map(_ fetchRequest: CoreData.FetchRequest) -> [String: Any] {
    return [
      "name": fetchRequest.name,
      "entity": fetchRequest.entity,
      "fetchLimit": fetchRequest.fetchLimit,
      "fetchBatchSize": fetchRequest.fetchBatchSize,
      "predicateString": fetchRequest.predicateString,
      "resultType": map(fetchRequest.resultType),
      "includeSubentities": fetchRequest.includeSubentities,
      "includePropertyValues": fetchRequest.includePropertyValues,
      "includesPendingChanges": fetchRequest.includesPendingChanges,
      "returnsObjectsAsFaults": fetchRequest.returnsObjectsAsFaults,
      "returnDistinctResults": fetchRequest.returnDistinctResults
    ]
  }

  private func map(_ resultType: CoreData.FetchRequest.ResultType) -> String {
    switch resultType {
    case .object:
      return "Object"
    case .objectID:
      return "Object ID"
    case .dictionary:
      return "Dictionary"
    }
  }
}
