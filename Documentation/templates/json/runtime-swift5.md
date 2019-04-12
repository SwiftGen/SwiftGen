## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | json/runtime-swift5.stencil |
| Configuration example | <pre>json:<br />  inputs: path/to/json/dir-or-file<br />  outputs:<br />    templateName: runtime-swift5<br />    output: JSON.swift</pre> |
| Language | Swift 5 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 5* code.
- Loads the data from the JSON file in the current bundle at runtime.
- If you need other functionality, such as loading a file in your `Documents` folder, or handling `Optional` properties, you should write your own custom template ([guide](../../Creating-your-templates.md)).

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `JSONFiles` | Allows you to change the name of the generated `enum` containing all files. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all file paths. Use this if you added your data folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum JSONFiles {
  internal enum Configuration {
    private static let _document = JSONDocument(path: "configuration.json")
    internal static let apiVersion: String = _document["api-version"]
    internal static let country: Any? = _document["country"]
    internal static let environment: String = _document["environment"]
    internal static let options: [String: Any] = _document["options"]
  }
  internal enum GroceryList {
    internal static let items: [String] = objectFromJSON(at: "grocery-list.yaml")
  }
  internal enum Version {
    internal static let value: String = objectFromJSON(at: "version.yaml")
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/JSON/runtime-swift5/all.swift)

## Usage example

```swift
// This will be an dictionary
let foo = JSONFiles.Configuration.options

// This will be an [String]
let bar = JSONFiles.GroceryList.items
```
