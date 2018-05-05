## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | plist/swift4.stencil |
| Invocation example | `swiftgen plist -t swift4 …` |
| Language | Swift 4 |
| Author | David Jennes |

## When to use it

- When you need to generate *Swift 4* code

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `documentName` | `Document` | Allows you to change the prefix of the generated `enum` for each document. |
| `enumName` | `Plist` | Allows you to change the name of the generated `enum` containing all files. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum Plist {
  internal enum Test {
    internal static let items: [String] = arrayFromPlist(at: "array.plist")
  }
  internal enum Stuff {
    private static let _document = PlistDocument(path: "dictionary.plist")
    internal static let key1: Int = _document["key1"]
    internal static let key2: [String: Any] = _document["key2"]
  }
}
```

[Full generated code](https://github.com/SwiftGen/SwiftGen/blob/master/Tests/Fixtures/Generated/Plist/swift4-context-all.swift)

## Usage example

```swift
// This will be an array
let foo = Plist.Test.items

// This will be an Int
let bar = Plist.Stuff.key1
```
