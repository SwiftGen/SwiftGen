// swiftlint:disable all

import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable attributes

// swiftlint:disable identifier_name line_length type_body_length
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

}


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

    @NSManaged public var binaryData: Data?

    @NSManaged public var boolean: Bool

    @NSManaged public var color: UIColor?

    @NSManaged public var date: Date?

    @NSManaged public var decimal: NSDecimalNumber?

    @NSManaged public var double: Double

    @NSManaged public var float: Float

    @NSManaged public var int16: Int16

    @NSManaged public var int32: Int32

    @NSManaged public var int64: Int64

    @NSManaged public var nonOptional: String!

    @NSManaged public var string: String?

    @NSManaged public var transformable: AnyObject?

    @NSManaged public var transient: String?

    @NSManaged public var uri: URL?

    @NSManaged public var uuid: UUID?

    @NSManaged public var manyToMany: Set<SecondaryEntity>

    @NSManaged public var oneToMany: NSOrderedSet

    @NSManaged public var oneToOne: SecondaryEntity?

    @NSManaged public let fetchedProperty: [NewEntity]
}

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


extension MainEntity {

    class func fetchDictionaryFetchRequest(managedObjectContext: NSManagedObjectContext) throws -> [[String: Any]] {
        guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
            fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
        }
        let model = persistentStoreCoordinator.model
        let substitutionVariables: [String: Any] = [
            :
        ]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "DictionaryFetchRequest", substitutionVariables: substitutionVariables) else {
            fatalError("No fetch request template named 'DictionaryFetchRequest' found.")
        }

        return try managedObjectContext.fetch(fetchRequest) as! [[String: Any]]
    }
    class func fetchObjectFetchRequest(managedObjectContext: NSManagedObjectContext, uuid: UUID) throws -> [MainEntity] {
        guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
            fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
        }
        let model = persistentStoreCoordinator.model
        let substitutionVariables: [String: Any] = [
            "UUID": uuid
        ]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "ObjectFetchRequest", substitutionVariables: substitutionVariables) else {
            fatalError("No fetch request template named 'ObjectFetchRequest' found.")
        }

        return try managedObjectContext.fetch(fetchRequest) as! [MainEntity]
    }
    class func fetchObjectIDFetchRequest(managedObjectContext: NSManagedObjectContext, name: String) throws -> [NSManagedObjectID] {
        guard let persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator else {
            fatalError("Managed object context has no persistent store coordinator for getting fetch request templates")
        }
        let model = persistentStoreCoordinator.model
        let substitutionVariables: [String: Any] = [
            "NAME": name
        ]

        guard let fetchRequest = model.fetchRequestFromTemplate(withName: "ObjectIDFetchRequest", substitutionVariables: substitutionVariables) else {
            fatalError("No fetch request template named 'ObjectIDFetchRequest' found.")
        }

        return try managedObjectContext.fetch(fetchRequest) as! [NSManagedObjectID]
    }

}
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

    @NSManaged public var name: String!

    @NSManaged public var manyToMany: Set<MainEntity>

    @NSManaged public var oneToMany: MainEntity?

    @NSManaged public var oneToOne: MainEntity?

}

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

}


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

    @NSManaged public var identifier: UUID?

}


// swiftlint:enable identifier_name line_length type_body_length
