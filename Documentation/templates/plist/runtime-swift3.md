## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | plist/runtime-swift3.stencil |
| Invocation example | `swiftgen plist -t runtime-swift3 …` |
| Language | Swift 3 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 3* code.
- Loads the data from the Plist file in the current bundle at runtime.
- If you need other functionality, such as loading a file in your `Documents` folder, or handling `Optional` properties, you should write your own custom template ([guide](../../Creating-your-templates.md)).

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `PlistFiles` | Allows you to change the name of the generated `enum` containing all files. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all file paths. Use this if you added your data folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum PlistFiles {
  internal enum Configuration {
    private static let _document = PlistDocument(path: "configuration.plist")
    internal static let environment: String = _document["Environment"]
    internal static let options: [String: Any] = _document["Options"]
  }
  internal enum ShoppingList {
    internal static let items: [String] = arrayFromPlist(at: "shopping-list.plist")
  }
}
```

[Full generated code](https://github.com/SwiftGen/SwiftGen/blob/master/Tests/Fixtures/Generated/Plist/runtime-swift3-context-all.swift)

## Usage example

```swift
// This will be an array
let foo = PlistFiles.ShoppingList.items

// This will be an String
let bar = PlistFiles.Configuration.environment
```
