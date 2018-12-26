//
//  CoreDataContext.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

/*
 - `models`: `Array` — A list of parsed models, with each:
   - `configurations`: `Dictionary<Array<String>>` — Map of configurations and the corresponding list of entity names
   - `entities`: `Dictionary` – Map of all the entities in the model, each key being the entity's name, and
     corresponding value is a dictionary described below:
     - `name`: `String` - Entity name
     - `className`: `String` - Class name as specified by the user (usually the same as `name`)
     - `isAbstract`: `Bool` - Whether the entity is an abstract or not
     - `superEntity`: `String` - Name of the super (parent) entity
     - `uniquenessConstraints`: `Array<Array<String>>` - List of uniqueness constraints, each being a list of
       attributes
     - `attributes`: `Array` - List of attributes (see `Entity Attribute`)
     - `relationships`: `Array` - List of relationships (see `Entity Relationship`)
     - `fetchedProperties`: `Array` - List of fetched properties (see `Entity Fetched Property`)
   - `fetchRequests`: `Dictionary` - All fetch requests, grouped by entity. Each key will be an entity name, each value
     will be a list of corresponding fetch requests (see `Fetch Request`)

An `Entity Attribute` will have the following properties:

 - `name`: `String` - Attribute name
 - `customClassName`: `String` - Custom class name (if one has been defined)
 - `isIndexed`: `Bool` - Whether the property is indexed or not.
 - `isOptional`: `Bool` - Whether the property is optional or not.
 - `isTransient`: `Bool` - Whether the property is transient or not.
 - `propertyType`: `String` - Property type, will be "attribute"
 - `shouldGenerateCode`: `Bool` - Whether the template should generate code or not (Xcode will take care of it)
 - `type`: `String` - Type of the attribute (Transformable, Binary, Boolean, ...)
 - `typeName`: `String` - Actual attribute type, based on the values for `type`, `usesScalarValueType` and
   `customClassName`
 - `usesScalarValueType`: `Bool` - Whether the property should use scalar value types or not.
 - `userInfo`: `Dictionary` - Dictionary of keys/values defined by the user

An `Entity Relationship` will have the following properties:

 - `name`: `String` - Relationship name
 - `destinationEntity`: `String` - The name of the destination's entity.
 - `inverseRelationship`: `Dictionary` - The inverse of this relationship:
   - `name`: `String`: The name of the inverse relationship.
   - `destinationEntity`: `String` - The name of the inverse relationship's entity.
 - `isIndexed`: `Bool` - Whether the property is indexed or not.
 - `isOptional`: `Bool` - Whether the property is optional or not.
 - `isOrdered`: `Bool` - Whether the relationship is ordered or unordered.
 - `isToMany`: `Bool` - Whether the relationship targets one or more instances.
 - `isTransient`: `Bool` - Whether the property is transient or not.
 - `propertyType`: `String` - Property type, will be "relationship"
 - `userInfo`: `Dictionary` - Dictionary of keys/values defined by the user

An `Entity Fetched Property` will have the following properties:

 - `name`: `String` - Fetched property name
 - `fetchRequest`: `Dictionary` - The fetch request (see `Fetch Request`)
 - `isOptional`: `Bool` - Whether the property is optional or not.
 - `propertyType`: `String` - Property type, will be "fetchedProperty"
 - `userInfo`: `Dictionary` - Dictionary of keys/values defined by the user

A `Fetch Request` will have the following properties:

 - `name`: `String` - Fetch request name
 - `entity`: `String` - Requested entity name
 - `fetchBatchSize`: `Int` - Request batch size
 - `fetchLimit`: `Int` - Request fetch limit
 - `includePropertyValues`: `Bool` - Whether to include property values or not
 - `includesPendingChanges`: `Bool` - Whether to include pending changes or not
 - `includeSubentities`: `Bool` - Whether to include sub-entities or not
 - `predicateString`: `String` - Predicate string for filtering
 - `resultType`: `String` - Type of the fetch result
 - `returnDistinctResults`: `Bool` - Whether to return only the unique results or not
 - `returnsObjectsAsFaults`: `Bool` - Whether to return results as faults or not
 - `substitutionVariables`: `Dictionary` - Substitution variables (for the `predicate`), each key being the variable
   name, and as value the expected type.
 */
extension CoreData.Parser {
  public func stencilContext() -> [String: Any] {
    return [
      "models": models.map(map)
    ]
  }

  private func map(model: CoreData.Model) -> [String: Any] {
    return [
      "configurations": model.configurations.mapValues { $0.sorted() },
      "entities": model.entities.mapValues { map(entity: $0, in: model) },
      "fetchRequests": model.fetchRequestsByEntityName.mapValues { $0.map { map(fetchRequest: $0, in: model) } }
    ]
  }

  private func map(entity: CoreData.Entity, in model: CoreData.Model) -> [String: Any] {
    return [
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
    return [
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
    return [
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
    return [
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
