// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable attributes
// swiftlint:disable vertical_whitespace_closing_braces

// swiftlint:disable identifier_name line_length type_body_length
// MARK: - AbstractEntity

@objc(AbstractEntity)
public class AbstractEntity: NSManagedObject {
  public class func entityName() -> String {
    return "AbstractEntity"
  }

  public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc public class func fetchRequest() -> NSFetchRequest<AbstractEntity> {
    return NSFetchRequest<AbstractEntity>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean
  // swiftlint:enable discouraged_optional_boolean
}

// MARK: - ChildEntity

@objc(ChildEntity)
public class ChildEntity: MainEntity {
  override public class func entityName() -> String {
    return "ChildEntity"
  }

  override public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc public class func fetchRequest() -> NSFetchRequest<ChildEntity> {
    return NSFetchRequest<ChildEntity>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean
  // swiftlint:enable discouraged_optional_boolean
}

// MARK: - MainEntity

@objc(MainEntity)
public class MainEntity: NSManagedObject {
  public class func entityName() -> String {
    return "MainEntity"
  }

  public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MainEntity> {
    return NSFetchRequest<MainEntity>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean
  @NSManaged public var attributedString: NSAttributedString?
  @NSManaged public var binaryData: Data?
  @NSManaged public var boolean: Bool
  @NSManaged public var date: Date?
  @NSManaged public var decimal: NSDecimalNumber?
  @NSManaged public var double: Double
  @NSManaged public var float: Float
  @NSManaged public var int16: Int16
  @NSManaged public var int32: Int32
  @NSManaged public var int64: Int64
  public var optionalBoolean: Bool? {
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
  public var optionalDouble: Double? {
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
  @NSManaged public var optionalFloat: Float
  public var optionalInt16: Int16? {
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
  @NSManaged public var optionalInt32: Int32
  public var optionalInt64: Int64? {
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
  @NSManaged public var optionalString: String?
  @NSManaged public var string: String!
  @NSManaged public var transformable: AnyObject?
  @NSManaged public var transient: String?
  @NSManaged public var uri: URL?
  @NSManaged public var uuid: UUID?
  @NSManaged public var manyToMany: Set<SecondaryEntity>
  @NSManaged public var oneToMany: NSOrderedSet
  @NSManaged public var oneToOne: SecondaryEntity?
  @NSManaged public var fetchedProperty: [NewEntity]
  // swiftlint:enable discouraged_optional_boolean
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

  class func fetchObjectIDFetchRequest(managedObjectContext: NSManagedObjectContext, name: String) throws -> [NSManagedObjectID] {
    guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
      fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
    }
    let model = persistentStoreCoordinator.managedObjectModel
    let substitutionVariables: [String: Any] = [
      "NAME": name
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

@objc(NewEntity)
public class NewEntity: AbstractEntity {
  override public class func entityName() -> String {
    return "NewEntity"
  }

  override public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc public class func fetchRequest() -> NSFetchRequest<NewEntity> {
    return NSFetchRequest<NewEntity>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean
  @NSManaged public var identifier: UUID?
  // swiftlint:enable discouraged_optional_boolean
}

// MARK: - SecondaryEntity

@objc(SecondaryEntity)
public class SecondaryEntity: NSManagedObject {
  public class func entityName() -> String {
    return "SecondaryEntity"
  }

  public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc public class func fetchRequest() -> NSFetchRequest<SecondaryEntity> {
    return NSFetchRequest<SecondaryEntity>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean
  @NSManaged public var name: String!
  @NSManaged public var manyToMany: Set<MainEntity>
  @NSManaged public var oneToMany: MainEntity?
  @NSManaged public var oneToOne: MainEntity?
  // swiftlint:enable discouraged_optional_boolean
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
