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
      "entities": model.entities.mapValues { map($0, in: model) },
      "fetchRequests": model.fetchRequests.map { map($0, in: model) },
      "fetchRequestsByEntityName": model.fetchRequestsByEntityName.mapValues { $0.map { map($0, in: model) } }
    ]
  }

  private func map(_ entity: CoreData.Entity, in model: CoreData.Model) -> [String: Any] {
    return [
      "name": entity.name,
      "className": entity.className,
      "isAbstract": entity.isAbstract,
      "userInfo": entity.userInfo,
      "superentity": entity.superentity ?? "",
      "attributes": entity.attributes.map { map($0, in: model) },
      "relationships": entity.relationships.map { map($0, in: model) },
      "fetchedProperties": entity.fetchedProperties.map { map($0, in: model) }
    ]
  }

  private func map(_ attribute: CoreData.Attribute, in model: CoreData.Model) -> [String: Any] {
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

  private func map(_ relationship: CoreData.Relationship, in model: CoreData.Model) -> [String: Any] {
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

  private func map(_ fetchedProperty: CoreData.FetchedProperty, in model: CoreData.Model) -> [String: Any] {
    return [
      "name": fetchedProperty.name,
      "isOptional": fetchedProperty.isOptional,
      "fetchRequest": map(fetchedProperty.fetchRequest, in: model),
      "userInfo": fetchedProperty.userInfo
    ]
  }

  private func map(_ fetchRequest: CoreData.FetchRequest, in model: CoreData.Model) -> [String: Any] {
    guard let entity = model.entities[fetchRequest.entity] else {
      return [:]
    }

    return [
      "name": fetchRequest.name,
      "entity": fetchRequest.entity,
      "fetchLimit": fetchRequest.fetchLimit,
      "fetchBatchSize": fetchRequest.fetchBatchSize,
      "predicateString": fetchRequest.predicateString,
      "substitutionVariables": substitutionVariables(
        in: fetchRequest.predicateString,
        baseEntity: entity,
        model: model
      ),
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

  private func substitutionVariables(
    in predicateString: String,
    baseEntity: CoreData.Entity,
    model: CoreData.Model
  ) -> [String: String] {
    if predicateString.isEmpty { return [:] }
    let predicate = NSPredicate(format: predicateString, argumentArray: nil)
    return substitutionVariables(in: predicate, baseEntity: baseEntity, model: model)
  }

  private func substitutionVariables(
    in predicate: NSPredicate,
    baseEntity: CoreData.Entity,
    model: CoreData.Model
  ) -> [String: String] {
    if let compoundPredicate = predicate as? NSCompoundPredicate {
      return compoundPredicate.subpredicates.reduce(into: [:]) { variables, subpredicate in
        guard let subpredicate = subpredicate as? NSPredicate else { return }
        let subpredicateVariables = substitutionVariables(in: subpredicate, baseEntity: baseEntity, model: model)
        variables.merge(subpredicateVariables) { existing, _ in existing }
      }
    } else if let comparisonPredicate = predicate as? NSComparisonPredicate {
      let lhs = comparisonPredicate.leftExpression
      let rhs = comparisonPredicate.rightExpression

      guard rhs.expressionType == .variable else { return [:] }

      let typeName = resolveType(forKeyPath: lhs.keyPath, baseEntity: baseEntity, in: model)
      return [rhs.variable: typeName]
    } else {
      return [:]
    }
  }

  private func resolveType(
    forKeyPath keyPath: String,
    baseEntity: CoreData.Entity,
    in model: CoreData.Model
  ) -> String {
    let components = keyPath.split(separator: ".")

    var entity = baseEntity
    for component in components {
      if let attribute = entity.attributes.first(where: { $0.name == component }) {
        return attribute.typeName
      } else if let relationship = entity.relationships.first(where: { $0.name == component }) {
        guard let destinationEntity = model.entities[relationship.destinationEntity] else {
          return ""
        }
        entity = destinationEntity
      }
    }

    return entity.className
  }
}
