## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | json/inline-swift4.stencil |
| Configuration example | <pre>json:<br />  inputs: path/to/json/dir-or-file<br />  outputs:<br />    templateName: inline-swift4<br />    output: JSON.swift</pre> |
| Language | Swift 4 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 4* code.
- Embeds the data from the JSON file directly in your Swift code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `JSONFiles` | Allows you to change the name of the generated `enum` containing all files. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all file paths. Use this if you added your data folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum JSONFiles {
  internal enum Array {
    internal static let items: [String] = ["Anna", "Bob"]
  }
  internal enum Configuration {
    internal static let apiVersion: String = "2"
    internal static let country: Any? = nil
    internal static let environment: String = "staging"
    internal static let options: [String: Any] = ["screen-order": ["1", "2", "3"]]
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/JSON/inline-swift4/all.swift)

## Usage example

```swift
// This will be an dictionary
let foo = JSONFiles.Configuration.options

// This will be an [String]
let bar = JSONFiles.Array.items
```
