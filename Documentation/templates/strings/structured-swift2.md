## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | strings/structured-swift2.stencil |
| Invocation example | `swiftgen strings -t structured-swift2 …` |
| Language | Swift 2 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 2* code
- If you use "structured" keys for your strings, that is components separated by the `.` character, for example:

```
"some.deep.structure"
"some.deep.something"
"hello.world"
```
- **Warning**: Swift 2 is no longer actively supported, so we cannot guarantee that there won't be issues with the generated code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `L10n` | Allows you to change the name of the generated `enum` containing all string tables. |
| `noComments` | N/A | Setting this parameter will disable the comments describing the translation of a key. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
enum L10n {
  /// Some alert body there
  static let AlertMessage = L10n.tr("alert_message")
  /// Title of the alert
  static let AlertTitle = L10n.tr("alert_title")
  
  enum Apples {
    /// You have %d apples
    static func Count(p1: Int) -> String {
      return L10n.tr("apples.count", p1)
    }
  }

  enum Bananas {
    /// Those %d bananas belong to %@.
    static func Owner(p1: Int, p2: String) -> String {
      return L10n.tr("bananas.owner", p1, p2)
    }
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Strings/structured-swift2-context-localizable.swift)

## Usage example

```swift
// Simple strings
let message = L10n.AlertMessage
let title = L10n.AlertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.Apples.Count(3)
let bananas = L10n.Bananas.Owner(5, "Olivier")
```
