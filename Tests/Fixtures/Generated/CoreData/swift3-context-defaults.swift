import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable discouraged_optional_boolean

// swiftlint:disable identifier_name line_length type_body_length
open internal class ChildEntity: MainEntity {

    override open class func entityName() -> String {
        return "ChildEntity"
    }

    override open class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

}

open internal class MainEntity: NSManagedObject {

    open class func entityName() -> String {
        return "MainEntity"
    }

    open class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @NSManaged open var binaryData: Data?

    @NSManaged open var boolean: Bool?

    @NSManaged open var color: UIColor?

    @NSManaged open var date: Date?

    @NSManaged open var decimal: NSDecimalNumber?

    @NSManaged open var double: Double?

    @NSManaged open var float: Float?

    @NSManaged open var int16: Int16?

    @NSManaged open var int32: Int32?

    @NSManaged open var int64: Int64?

    @NSManaged open var string: String?

    @NSManaged open var transformable: AnyObject?

    @NSManaged open var transient: String?

    @NSManaged open var uri: URL?

    @NSManaged open var uuid: UUID?

    @NSManaged open var manyToMany: NSSet

    @NSManaged open var oneToMany: NSOrderedSet

    @NSManaged open var oneToOne: SecondaryEntity?

}

open internal class SecondaryEntity: NSManagedObject {

    open class func entityName() -> String {
        return "SecondaryEntity"
    }

    open class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @NSManaged open var manyToMany: NSSet

    @NSManaged open var oneToMany: MainEntity?

    @NSManaged open var oneToOne: MainEntity?

}

open internal class AbstractEntity: NSManagedObject {

    open class func entityName() -> String {
        return "AbstractEntity"
    }

    open class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

}

open internal class NewEntity: AbstractEntity {

    override open class func entityName() -> String {
        return "NewEntity"
    }

    override open class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

}

// swiftlint:enable identifier_name line_length type_body_length
