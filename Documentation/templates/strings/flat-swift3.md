## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | strings/flat-swift3.stencil |
| Invocation example | `swiftgen strings -t flat-swift3 …` |
| Language | Swift 3 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 3* code
- If you use unstructured key names for your strings, or a structure that we don't support (yet). If you use "dot-syntax" keys, please check out the [structured-swift3](structured-swift3.md) template.

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
  static let alertMessage = L10n.tr("Localizable", "alert_message")
  /// Title of the alert
  static let alertTitle = L10n.tr("Localizable", "alert_title")
  /// You have %d apples
  static func applesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  static func bananasOwner(_ p1: Int, _ p2: String) -> String {
    return L10n.tr("Localizable", "bananas.owner", p1, p2)
  }
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Strings/flat-swift3-context-localizable.swift)

## Usage example

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.applesCount(3)
let bananas = L10n.bananasOwner(5, "Olivier")
```
