# Core Data parser

## Input

The core data parser accepts a `xcdatamodeld` (or `xcdatamodel`) file. The parser will load all the configurations, entities, and fetch requests for each model.

## Output

The output context has the following structure:

 - `models`: `Array` — A list of parsed models, with each:
   - `configurations`: `Dictionary<String, Array<String>>` — Map of configuration names and the corresponding list of
     entity names
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

## Example

```yaml
models:
- configurations:
    Custom:
    - "NewEntity"
    Default:
    - "AbstractEntity"
    - "ChildEntity"
    - "MainEntity"
    - "NewEntity"
    - "SecondaryEntity"
  entities:
    AbstractEntity:
      attributes: []
      className: "AbstractEntity"
      fetchedProperties: []
      isAbstract: true
      name: "AbstractEntity"
      relationships: []
      superEntity: ""
      uniquenessConstraints: []
      userInfo: {}
    ChildEntity:
      attributes: []
      className: "ChildEntity"
      fetchedProperties: []
      isAbstract: false
      name: "ChildEntity"
      relationships: []
      superEntity: "MainEntity"
      uniquenessConstraints: []
      userInfo:
        key: "value"
    MainEntity:
      attributes:
      - customClassName: "NSAttributedString"
        isIndexed: false
        isOptional: true
        isTransient: false
        name: "attributedString"
        propertyType: "attribute"
        type: "Transformable"
        typeName: "NSAttributedString"
        userInfo: {}
        usesScalarValueType: false
      - customClassName: ""
        isIndexed: false
        isOptional: true
        isTransient: false
        name: "boolean"
        propertyType: "attribute"
        type: "Boolean"
        typeName: "Bool"
        userInfo: {}
        usesScalarValueType: true
      - customClassName: ""
        isIndexed: false
        isOptional: true
        isTransient: false
        name: "float"
        propertyType: "attribute"
        type: "Float"
        typeName: "Float"
        userInfo: {}
        usesScalarValueType: true
      - customClassName: ""
        isIndexed: false
        isOptional: true
        isTransient: false
        name: "int64"
        propertyType: "attribute"
        type: "Integer 64"
        typeName: "Int64"
        userInfo: {}
        usesScalarValueType: true
      className: "MainEntity"
      fetchedProperties:
      - fetchRequest:
          entity: "NewEntity"
          fetchBatchSize: 0
          fetchLimit: 0
          includePropertyValues: true
          includeSubentities: true
          includesPendingChanges: true
          name: "fetchedPropertyFetchRequest"
          predicateString: "true == true"
          resultType: "Object"
          returnDistinctResults: false
          returnsObjectsAsFaults: true
          substitutionVariables: {}
        isOptional: true
        name: "fetchedProperty"
        propertyType: "fetchedProperty"
        userInfo:
          key: "value"
      isAbstract: false
      name: "MainEntity"
      relationships:
      - destinationEntity: "SecondaryEntity"
        inverseRelationship:
          entityName: "SecondaryEntity"
          name: "manyToMany"
        isIndexed: false
        isOptional: true
        isOrdered: false
        isToMany: true
        isTransient: false
        name: "manyToMany"
        propertyType: "relationship"
        userInfo: {}
      superEntity: ""
      uniquenessConstraints: []
      userInfo:
        key: "value"
    NewEntity:
      attributes:
      - customClassName: ""
        isIndexed: false
        isOptional: true
        isTransient: false
        name: "identifier"
        propertyType: "attribute"
        type: "UUID"
        typeName: "UUID"
        userInfo: {}
        usesScalarValueType: false
      className: "NewEntity"
      fetchedProperties: []
      isAbstract: false
      name: "NewEntity"
      relationships: []
      superEntity: "AbstractEntity"
      uniquenessConstraints:
      - - "identifier"
      userInfo: {}
    SecondaryEntity:
      attributes:
      - customClassName: ""
        isIndexed: false
        isOptional: false
        isTransient: false
        name: "name"
        propertyType: "attribute"
        type: "String"
        typeName: "String"
        userInfo: {}
        usesScalarValueType: false
      className: "SecondaryEntity"
      fetchedProperties: []
      isAbstract: false
      name: "SecondaryEntity"
      relationships:
      - destinationEntity: "MainEntity"
        inverseRelationship:
          entityName: "MainEntity"
          name: "manyToMany"
        isIndexed: false
        isOptional: true
        isOrdered: false
        isToMany: true
        isTransient: false
        name: "manyToMany"
        propertyType: "relationship"
        userInfo: {}
      superEntity: ""
      uniquenessConstraints: []
      userInfo: {}
  fetchRequests:
    MainEntity:
    - entity: "MainEntity"
      fetchBatchSize: 0
      fetchLimit: 0
      includePropertyValues: true
      includeSubentities: true
      includesPendingChanges: true
      name: "ObjectIDFetchRequest"
      predicateString: "oneToOne.name == $NAME"
      resultType: "Object ID"
      returnDistinctResults: false
      returnsObjectsAsFaults: true
      substitutionVariables:
        NAME: "String"
```
