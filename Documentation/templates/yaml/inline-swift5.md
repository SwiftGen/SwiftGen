## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | yaml/inline-swift5.stencil |
| Configuration example | <pre>yaml:<br />  inputs: path/to/yaml/dir-or-file<br />  outputs:<br />    templateName: swift5<br />    output: YAML.swift</pre> |
| Language | Swift 5 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 5* code.
- Embeds the data from the YAML file directly in your Swift code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `documentName` | `Document` | Allows you to change the prefix of the generated `enum` for each document (in case of multiple documents). |
| `enumName` | `YAMLFiles` | Allows you to change the name of the generated `enum` containing all files. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all file paths. Use this if you added your data folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum YAMLFiles {
  internal enum Documents {
    internal enum Document1 {
      internal static let items: [String] = ["Mark McGwire", "Sammy Sosa", "Ken Griffey"]
    }
    internal enum Document2 {
      internal static let items: [String] = ["Chicago Cubs", "St Louis Cardinals"]
    }
  }
  internal enum GroceryList {
    internal static let items: [String] = ["Eggs", "Bread", "Milk"]
  }
  internal enum Mapping {
    internal static let car: Any? = nil
    internal static let foo: [String: Any] = ["bar": "banana", "baz": "orange"]
    internal static let hello: String = "world"
    internal static let weight: Double = 33.3
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/YAML/inline-swift5/all.swift)

## Usage example

```swift
// This will be an dictionary
let foo = YAMLFiles.Mapping.foo

// This will be an [String]
let bar = YAMLFiles.GroceryList.items
```
