import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable attributes

// swiftlint:disable identifier_name line_length type_body_length
@objc(ChildEntity)
open public class ChildEntity: MainEntity {

    override open public class func entityName() -> String {
        return "ChildEntity"
    }

    override open public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChildEntity> {
        return NSFetchRequest<ChildEntity>(entityName: entityName())
    }

}


@objc(MainEntity)
open public class MainEntity: NSManagedObject {

    open public class func entityName() -> String {
        return "MainEntity"
    }

    open public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainEntity> {
        return NSFetchRequest<MainEntity>(entityName: entityName())
    }

    @NSManaged open public var binaryData: Data?

    @NSManaged open public var boolean: Bool

    @NSManaged open public var color: UIColor?

    @NSManaged open public var date: Date?

    @NSManaged open public var decimal: NSDecimalNumber?

    @NSManaged open public var double: Double

    @NSManaged open public var float: Float

    @NSManaged open public var int16: Int16

    @NSManaged open public var int32: Int32

    @NSManaged open public var int64: Int64

    @NSManaged open public var nonOptional: String?

    @NSManaged open public var string: String?

    @NSManaged open public var transformable: AnyObject?

    @NSManaged open public var transient: String?

    @NSManaged open public var uri: URL?

    @NSManaged open public var uuid: UUID?

    @NSManaged open public var manyToMany: NSSet

    @NSManaged open public var oneToMany: NSOrderedSet

    @NSManaged open public var oneToOne: SecondaryEntity?

    @NSManaged open public let fetchedProperty: [NewEntity]
}

extension MainEntity {

    @objc(addManyToManyObject:)
    @NSManaged public func addToManyToMany(_ value: SecondaryEntity)

    @objc(removeManyToManyObject:)
    @NSManaged public func removeFromManyToMany(_ value: SecondaryEntity)

    @objc(addManyToMany:)
    @NSManaged public func addToManyToMany(_ values: NSSet)

    @objc(removeManyToMany:)
    @NSManaged public func removeFromManyToMany(_ values: NSSet)

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

    class func fetchDictionaryFetchRequest(managedObjectContext: NSManagedObjectContext) throws -> [MainEntity] {

    }
    class func fetchObjectFetchRequest(managedObjectContext: NSManagedObjectContext, UUID: UUID) throws -> [MainEntity] {

    }
    class func fetchObjectIDFetchRequest(managedObjectContext: NSManagedObjectContext, NAME: String) throws -> [MainEntity] {

    }

}
@objc(SecondaryEntity)
open public class SecondaryEntity: NSManagedObject {

    open public class func entityName() -> String {
        return "SecondaryEntity"
    }

    open public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecondaryEntity> {
        return NSFetchRequest<SecondaryEntity>(entityName: entityName())
    }

    @NSManaged open public var name: String?

    @NSManaged open public var manyToMany: NSSet

    @NSManaged open public var oneToMany: MainEntity?

    @NSManaged open public var oneToOne: MainEntity?

}

extension SecondaryEntity {

    @objc(addManyToManyObject:)
    @NSManaged public func addToManyToMany(_ value: MainEntity)

    @objc(removeManyToManyObject:)
    @NSManaged public func removeFromManyToMany(_ value: MainEntity)

    @objc(addManyToMany:)
    @NSManaged public func addToManyToMany(_ values: NSSet)

    @objc(removeManyToMany:)
    @NSManaged public func removeFromManyToMany(_ values: NSSet)

}


@objc(AbstractEntity)
open public class AbstractEntity: NSManagedObject {

    open public class func entityName() -> String {
        return "AbstractEntity"
    }

    open public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AbstractEntity> {
        return NSFetchRequest<AbstractEntity>(entityName: entityName())
    }

}


@objc(NewEntity)
open public class NewEntity: AbstractEntity {

    override open public class func entityName() -> String {
        return "NewEntity"
    }

    override open public class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewEntity> {
        return NSFetchRequest<NewEntity>(entityName: entityName())
    }

}


// swiftlint:enable identifier_name line_length type_body_length
