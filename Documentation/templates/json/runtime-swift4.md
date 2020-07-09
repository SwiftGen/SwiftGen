## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | json/runtime-swift4.stencil |
| Configuration example | <pre>json:<br />  inputs: path/to/json/dir-or-file<br />  outputs:<br />    templateName: runtime-swift4<br />    output: JSON.swift</pre> |
| Language | Swift 4 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 4* code.
- Loads the data from the JSON file in the current bundle at runtime.
- If you need other functionality, such as loading a file in your `Documents` folder, or handling `Optional` properties, you should write your own custom template ([guide](../../Articles/Creating-custom-templates.md)).

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `bundle` | `BundleToken.bundle` | Allows you to set from which bundle JSON files are loaded from. By default, it'll point to the same bundle as where the generated code is. Note: ignored if `lookupFunction` parameter is set. |
| `enumName` | `JSONFiles` | Allows you to change the name of the generated `enum` containing all files. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `lookupFunction` | N/A¹ | Allows you to set your own custom lookup function. The function needs to have as signature: `(path: String) -> URL?`. The parameters of your function can have any name (or even no external name), but if it has named parameters, you must provide the complete function signature, including those named parameters – e.g. `myJSONFinder(path:)`. Note: if you define this parameter, the `bundle` parameter will be ignored. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all file paths. Use this if you added your data folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

1. _If you don't provide a `lookupFunction`, we will use `url(forResource:withExtension:)` on the `bundle` parameter instead._

## Generated Code

**Extract:**

```swift
internal enum JSONFiles {
  internal enum Array {
    internal static let items: [String] = objectFromJSON(at: "array.json")
  }
  internal enum Configuration {
    private static let _document = JSONDocument(path: "configuration.json")
    internal static let apiVersion: String = _document["api-version"]
    internal static let country: Any? = _document["country"]
    internal static let environment: String = _document["environment"]
    internal static let options: [String: Any] = _document["options"]
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/JSON/runtime-swift4/all.swift)

## Usage example

```swift
// This will be an dictionary
let foo = JSONFiles.Configuration.options

// This will be an [String]
let bar = JSONFiles.GroceryList.items
```
