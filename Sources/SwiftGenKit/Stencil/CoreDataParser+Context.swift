//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/coredata.md
//

extension CoreData.Parser {
  public func stencilContext() -> [String: Any] {
    [
      "models": models.map(map)
    ]
  }

  private func map(model: CoreData.Model) -> [String: Any] {
    [
      "configurations": model.configurations.mapValues { $0.sorted() },
      "entities": model.entities.mapValues { map(entity: $0, in: model) },
      "fetchRequests": model.fetchRequestsByEntityName.mapValues { $0.map { map(fetchRequest: $0, in: model) } }
    ]
  }

  private func map(entity: CoreData.Entity, in model: CoreData.Model) -> [String: Any] {
    [
      "name": entity.name,
      "className": entity.className,
      "isAbstract": entity.isAbstract,
      "userInfo": entity.userInfo,
      "superEntity": entity.superEntity ?? "",
      "attributes": entity.attributes.map { map(attribute: $0, in: model) },
      "relationships": entity.relationships.map { map(relationship: $0, in: model) },
      "fetchedProperties": entity.fetchedProperties.map { map(fetchedProperty: $0, in: model) },
      "uniquenessConstraints": entity.uniquenessConstraints,
      "shouldGenerateCode": entity.shouldGenerateCode
    ]
  }

  private func map(attribute: CoreData.Attribute, in model: CoreData.Model) -> [String: Any] {
    [
      "name": attribute.name,
      "propertyType": "attribute",
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

  private func map(relationship: CoreData.Relationship, in model: CoreData.Model) -> [String: Any] {
    [
      "name": relationship.name,
      "propertyType": "relationship",
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

  private func map(fetchedProperty: CoreData.FetchedProperty, in model: CoreData.Model) -> [String: Any] {
    [
      "name": fetchedProperty.name,
      "propertyType": "fetchedProperty",
      "isOptional": fetchedProperty.isOptional,
      "fetchRequest": map(fetchRequest: fetchedProperty.fetchRequest, in: model),
      "userInfo": fetchedProperty.userInfo
    ]
  }

  private func map(fetchRequest: CoreData.FetchRequest, in model: CoreData.Model) -> [String: Any] {
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
      "resultType": map(resultType: fetchRequest.resultType),
      "includeSubentities": fetchRequest.includeSubentities,
      "includePropertyValues": fetchRequest.includePropertyValues,
      "includesPendingChanges": fetchRequest.includesPendingChanges,
      "returnsObjectsAsFaults": fetchRequest.returnsObjectsAsFaults,
      "returnDistinctResults": fetchRequest.returnDistinctResults
    ]
  }

  private func map(resultType: CoreData.FetchRequest.ResultType) -> String {
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
    guard !predicateString.isEmpty else { return [:] }

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
