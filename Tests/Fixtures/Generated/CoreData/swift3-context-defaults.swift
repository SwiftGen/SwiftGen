import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable attributes

// swiftlint:disable identifier_name line_length type_body_length
@objc(ChildEntity)
open internal class ChildEntity: MainEntity {

    override open internal class func entityName() -> String {
        return "ChildEntity"
    }

    override open internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<ChildEntity> {
        return NSFetchRequest<ChildEntity>(entityName: entityName())
    }

}

@objc(MainEntity)
open internal class MainEntity: NSManagedObject {

    open internal class func entityName() -> String {
        return "MainEntity"
    }

    open internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<MainEntity> {
        return NSFetchRequest<MainEntity>(entityName: entityName())
    }

    @NSManaged open internal var binaryData: Data?

    @NSManaged open internal var boolean: Bool

    @NSManaged open internal var color: UIColor?

    @NSManaged open internal var date: Date?

    @NSManaged open internal var decimal: NSDecimalNumber?

    @NSManaged open internal var double: Double

    @NSManaged open internal var float: Float

    @NSManaged open internal var int16: Int16

    @NSManaged open internal var int32: Int32

    @NSManaged open internal var int64: Int64

    @NSManaged open internal var string: String?

    @NSManaged open internal var transformable: AnyObject?

    @NSManaged open internal var transient: String?

    @NSManaged open internal var uri: URL?

    @NSManaged open internal var uuid: UUID?

    @NSManaged open internal var manyToMany: NSSet

    @NSManaged open internal var oneToMany: NSOrderedSet

    @NSManaged open internal var oneToOne: SecondaryEntity?

    @NSManaged open internal let fetchedProperty: [NewEntity]
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

@objc(SecondaryEntity)
open internal class SecondaryEntity: NSManagedObject {

    open internal class func entityName() -> String {
        return "SecondaryEntity"
    }

    open internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<SecondaryEntity> {
        return NSFetchRequest<SecondaryEntity>(entityName: entityName())
    }

    @NSManaged open internal var manyToMany: NSSet

    @NSManaged open internal var oneToMany: MainEntity?

    @NSManaged open internal var oneToOne: MainEntity?

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
open internal class AbstractEntity: NSManagedObject {

    open internal class func entityName() -> String {
        return "AbstractEntity"
    }

    open internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<AbstractEntity> {
        return NSFetchRequest<AbstractEntity>(entityName: entityName())
    }

}

@objc(NewEntity)
open internal class NewEntity: AbstractEntity {

    override open internal class func entityName() -> String {
        return "NewEntity"
    }

    override open internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
    }

    @nonobjc internal class func fetchRequest() -> NSFetchRequest<NewEntity> {
        return NSFetchRequest<NewEntity>(entityName: entityName())
    }

}

// swiftlint:enable identifier_name line_length type_body_length
