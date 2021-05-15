// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable superfluous_disable_command implicit_return
// swiftlint:disable sorted_imports
import CoreData
import Foundation

// swiftlint:disable attributes file_length vertical_whitespace_closing_braces
// swiftlint:disable identifier_name line_length type_body_length

// MARK: - AbstractEntity

class AbstractEntity: NSManagedObject {
  class var entityName: String {
    return "AbstractEntity"
  }

  class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc class func fetchRequest() -> NSFetchRequest<AbstractEntity> {
    return NSFetchRequest<AbstractEntity>(entityName: entityName)
  }

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<AbstractEntity> {
    return NSFetchRequest<AbstractEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - AutoClassGen

// Note: 'AutoClassGen' has codegen enabled for Xcode, skipping code generation.

// MARK: - AutoExtensionGen

// Note: 'AutoExtensionGen' has codegen enabled for Xcode, skipping code generation.

// MARK: - ChildEntity

class ChildEntity: MainEntity {
  override class var entityName: String {
    return "ChildEntity"
  }

  override class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc class func fetchRequest() -> NSFetchRequest<ChildEntity> {
    return NSFetchRequest<ChildEntity>(entityName: entityName)
  }

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<ChildEntity> {
    return NSFetchRequest<ChildEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - ImpossibleType

// Warning: 'We.Cannot.Handle.ImpossibleType' cannot be a valid type name, skipping code generation.

// MARK: - MainEntity

class MainEntity: NSManagedObject {
  class var entityName: String {
    return "MainEntity"
  }

  class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc class func fetchRequest() -> NSFetchRequest<MainEntity> {
    return NSFetchRequest<MainEntity>(entityName: entityName)
  }

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<MainEntity> {
    return NSFetchRequest<MainEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged var attributedString: NSAttributedString?
  @NSManaged var binaryData: Data?
  @NSManaged var boolean: Bool
  @NSManaged var date: Date?
  @NSManaged var decimal: NSDecimalNumber?
  @NSManaged var double: Double
  @NSManaged var float: Float
  @NSManaged var int16: Int16
  @NSManaged var int32: Int32
  @NSManaged var int64: Int64
  var integerEnum: IntegerEnum {
    get {
      let key = "integerEnum"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      guard let value = primitiveValue(forKey: key) as? IntegerEnum.RawValue,
        let result = IntegerEnum(rawValue: value) else {
        fatalError("Could not convert value for key '\(key)' to type 'IntegerEnum'")
      }
      return result
    }
    set {
      let key = "integerEnum"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue.rawValue, forKey: key)
    }
  }
  var optionalBoolean: Bool? {
    get {
      let key = "optionalBoolean"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Bool
    }
    set {
      let key = "optionalBoolean"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  var optionalDouble: Double? {
    get {
      let key = "optionalDouble"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Double
    }
    set {
      let key = "optionalDouble"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged var optionalFloat: Float
  var optionalInt16: Int16? {
    get {
      let key = "optionalInt16"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Int16
    }
    set {
      let key = "optionalInt16"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged var optionalInt32: Int32
  var optionalInt64: Int64? {
    get {
      let key = "optionalInt64"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Int64
    }
    set {
      let key = "optionalInt64"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged var optionalString: String?
  @NSManaged var string: String
  var stringEnum: StringEnum? {
    get {
      let key = "stringEnum"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      guard let value = primitiveValue(forKey: key) as? StringEnum.RawValue else {
        return nil
      }
      return StringEnum(rawValue: value)
    }
    set {
      let key = "stringEnum"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue?.rawValue, forKey: key)
    }
  }
  @NSManaged var transformable: AnyObject?
  @NSManaged var transformableCustomArray: CustomArray?
  @NSManaged var transformableCustomPolyline: CustomPolyline?
  @NSManaged var transient: String?
  @NSManaged var uri: URL?
  @NSManaged var uuid: UUID?
  @NSManaged var manyToMany: Set<SecondaryEntity>?
  @NSManaged var oneToMany: NSOrderedSet?
  @NSManaged var oneToOne: SecondaryEntity?
  @NSManaged var fetchedProperty: [NewEntity]
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: Relationship ManyToMany

extension MainEntity {
  @objc(addManyToManyObject:)
  @NSManaged public func addToManyToMany(_ value: SecondaryEntity)

  @objc(removeManyToManyObject:)
  @NSManaged public func removeFromManyToMany(_ value: SecondaryEntity)

  @objc(addManyToMany:)
  @NSManaged public func addToManyToMany(_ values: Set<SecondaryEntity>)

  @objc(removeManyToMany:)
  @NSManaged public func removeFromManyToMany(_ values: Set<SecondaryEntity>)
}

// MARK: Relationship OneToMany

extension MainEntity {
  @objc(insertObject:inOneToManyAtIndex:)
  @NSManaged public func insertIntoOneToMany(_ value: SecondaryEntity, at idx: Int)

  @objc(removeObjectFromOneToManyAtIndex:)
  @NSManaged public func removeFromOneToMany(at idx: Int)

  @objc(insertOneToMany:atIndexes:)
  @NSManaged public func insertIntoOneToMany(_ values: [SecondaryEntity], at indexes: NSIndexSet)

  @objc(removeOneToManyAtIndexes:)
  @NSManaged public func removeFromOneToMany(at indexes: NSIndexSet)

  @objc(replaceObjectInOneToManyAtIndex:withObject:)
  @NSManaged public func replaceOneToMany(at idx: Int, with value: SecondaryEntity)

  @objc(replaceOneToManyAtIndexes:withOneToMany:)
  @NSManaged public func replaceOneToMany(at indexes: NSIndexSet, with values: [SecondaryEntity])

  @objc(addOneToManyObject:)
  @NSManaged public func addToOneToMany(_ value: SecondaryEntity)

  @objc(removeOneToManyObject:)
  @NSManaged public func removeFromOneToMany(_ value: SecondaryEntity)

  @objc(addOneToMany:)
  @NSManaged public func addToOneToMany(_ values: NSOrderedSet)

  @objc(removeOneToMany:)
  @NSManaged public func removeFromOneToMany(_ values: NSOrderedSet)
}

// MARK: Fetch Requests

extension MainEntity {
  class func fetchDictionaryFetchRequest(managedObjectContext: NSManagedObjectContext) throws -> [[String: Any]] {
    guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
      fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
    }
    let model = persistentStoreCoordinator.managedObjectModel
    let substitutionVariables: [String: Any] = [
      :
    ]

    guard let fetchRequest = model.fetchRequestFromTemplate(withName: "DictionaryFetchRequest", substitutionVariables: substitutionVariables) else {
      fatalError("No fetch request template named 'DictionaryFetchRequest' found.")
    }

    guard let result = try managedObjectContext.fetch(fetchRequest) as? [[String: Any]] else {
      fatalError("Unable to cast fetch result to correct result type.")
    }

    return result
  }

  class func fetchObjectFetchRequest(managedObjectContext: NSManagedObjectContext, uuid: UUID) throws -> [MainEntity] {
    guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
      fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
    }
    let model = persistentStoreCoordinator.managedObjectModel
    let substitutionVariables: [String: Any] = [
      "UUID": uuid
    ]

    guard let fetchRequest = model.fetchRequestFromTemplate(withName: "ObjectFetchRequest", substitutionVariables: substitutionVariables) else {
      fatalError("No fetch request template named 'ObjectFetchRequest' found.")
    }

    guard let result = try managedObjectContext.fetch(fetchRequest) as? [MainEntity] else {
      fatalError("Unable to cast fetch result to correct result type.")
    }

    return result
  }

  class func fetchObjectIDFetchRequest(managedObjectContext: NSManagedObjectContext, name: String, needle: String) throws -> [NSManagedObjectID] {
    guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
      fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
    }
    let model = persistentStoreCoordinator.managedObjectModel
    let substitutionVariables: [String: Any] = [
      "NAME": name,
      "NEEDLE": needle
    ]

    guard let fetchRequest = model.fetchRequestFromTemplate(withName: "ObjectIDFetchRequest", substitutionVariables: substitutionVariables) else {
      fatalError("No fetch request template named 'ObjectIDFetchRequest' found.")
    }

    guard let result = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObjectID] else {
      fatalError("Unable to cast fetch result to correct result type.")
    }

    return result
  }

}

// MARK: - NewEntity

class NewEntity: AbstractEntity {
  override class var entityName: String {
    return "NewEntity"
  }

  override class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc class func fetchRequest() -> NSFetchRequest<NewEntity> {
    return NSFetchRequest<NewEntity>(entityName: entityName)
  }

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<NewEntity> {
    return NSFetchRequest<NewEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged var identifier: UUID?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - SecondaryEntity

class SecondaryEntity: NSManagedObject {
  class var entityName: String {
    return "SecondaryEntity"
  }

  class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc class func fetchRequest() -> NSFetchRequest<SecondaryEntity> {
    return NSFetchRequest<SecondaryEntity>(entityName: entityName)
  }

  @nonobjc class func makeFetchRequest() -> NSFetchRequest<SecondaryEntity> {
    return NSFetchRequest<SecondaryEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged var name: String
  @NSManaged var manyToMany: Set<MainEntity>?
  @NSManaged var oneToMany: MainEntity?
  @NSManaged var oneToOne: MainEntity?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: Relationship ManyToMany

extension SecondaryEntity {
  @objc(addManyToManyObject:)
  @NSManaged public func addToManyToMany(_ value: MainEntity)

  @objc(removeManyToManyObject:)
  @NSManaged public func removeFromManyToMany(_ value: MainEntity)

  @objc(addManyToMany:)
  @NSManaged public func addToManyToMany(_ values: Set<MainEntity>)

  @objc(removeManyToMany:)
  @NSManaged public func removeFromManyToMany(_ values: Set<MainEntity>)
}

// swiftlint:enable identifier_name line_length type_body_length
