## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | coredata/swift4.stencil |
| Configuration example | <pre>coredata:<br />  inputs: path/to/model.xcdatamodeld<br />  outputs:<br />    templateName: swift4<br />    output: CoreData.swift</pre> |
| Language | Swift 4 |
| Author | Grant J. Butler |

## When to use it

- When you need to generate *Swift 4* code.

Note: the template will only generate code for entities that have set the `Codegen` property to "Manual/None". This is to avoid conflicts with Xcode, which will automatically generate code for the other options.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `publicAccess` | N/A | If set, the generated types will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
@objc(MainEntity)
internal class MainEntity: NSManagedObject {
  internal class func entityName() -> String {
    return "MainEntity"
  }

  internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc internal class func fetchRequest() -> NSFetchRequest<MainEntity> {
    return NSFetchRequest<MainEntity>(entityName: entityName())
  }

  @NSManaged internal var attributedString: NSAttributedString?
  @NSManaged internal var binaryData: Data?
  @NSManaged internal var boolean: Bool
  @NSManaged internal var date: Date?
  @NSManaged internal var float: Float
  @NSManaged internal var int64: Int64
  @NSManaged internal var manyToMany: Set<SecondaryEntity>
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
```

[Full generated code](../../../Tests/Fixtures/Generated/CoreData/swift4-context-defaults.swift)

## Usage example

```swift
// Fetch all the instances of MainEntity
let request = MainEntity.fetchRequest()
let mainItems = try myContext.execute(request)

// Type-safe relationships: `relatedItem` will be a `SecondaryEntity?` in this case
let relatedItem = myMainItem.manyToMany.first
```
