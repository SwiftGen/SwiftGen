## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | coredata/swift3.stencil |
| Configuration example | <pre>coredata:<br />  inputs: path/to/model.xcdatamodeld<br />  outputs:<br />    templateName: swift3<br />    output: CoreData.swift</pre> |
| Language | Swift 3 |
| Author | Grant J. Butler |

## When to use it

- When you need to generate *Swift 3* code.

Note: the template will only generate code for entities that have set the `Codegen` property to "Manual/None". This is to avoid conflicts with Xcode, which will automatically generate code for the other options.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `extraImports`| N/A | With this you can provide additional modules to import, for example if you have properties with types from external modules. |
| `generateObjcName`| N/A | If set, the generated types will have an `@objc(...)` annotation with their class name. |
| `publicAccess` | N/A | If set, the generated types will be marked as `public`. Otherwise, they'll be declared `internal`. |

## UserInfo Keys

This template also make use of UserInfo keys that you can set on your Data Model's entities, attributes, relationships and fetched properties:

| Scope | UserInfo Key | Description |
|-------|--------------|-------------|
| Attribute | `enumType` | The name of the `enum` to associate to this attribute's type. The `enum` in question is expected to be declared in your code (SwiftGen won't generate it) or in an external module (see the`extraImports` parameter).<br />The `enum` must be `RawRepresentable` (e.g. `enum Foo: Int` or `enum Foo: String`) and its `RawValue` must match the attribute's type in your Data Model. |

## Generated Code

**Extract:**

```swift
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

[Full generated code](../../../Tests/Fixtures/Generated/CoreData/swift3/defaults.swift)

## Usage example

```swift
// Fetch all the instances of MainEntity
let request = MainEntity.fetchRequest()
let mainItems = try myContext.execute(request)

// Type-safe relationships: `relatedItem` will be a `SecondaryEntity?` in this case
let relatedItem = myMainItem.manyToMany.first
```
