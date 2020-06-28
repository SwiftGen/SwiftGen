## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | strings/structured-swift5.stencil |
| Configuration example | <pre>strings:<br />  inputs: path/to/Localizable.strings<br />  outputs:<br />    templateName: structured-swift5<br />    output: Strings.swift</pre> |
| Language | Swift 5 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 5* code.
- If you use "structured" keys for your strings, that is components separated by the `.` character, for example:

```
"some.deep.structure"
"some.deep.something"
"hello.world"
```

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `L10n` | Allows you to change the name of the generated `enum` containing all string tables. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `lookupFunction` | N/A | Allows you to set your own custom localization function. The function needs to accepts 2 parameters: the localization key (`String`), and the localization table (`String`). If the function has named parameters, you must provide the complete function signature, including those named parameters – e.g. `yourFunctionName(forKey:table:)`. Note: overrides `bundle` parameter. |
| `noComments` | N/A | Setting this parameter will disable the comments describing the translation of a key. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal enum L10n {
  /// Some alert body there
  internal static let alertMessage = L10n.tr("alert_message")
  /// Title of the alert
  internal static let alertTitle = L10n.tr("alert_title")

  internal enum Apples {
    /// You have %d apples
    internal static func count(_ p1: Int) -> String {
      return L10n.tr("apples.count", p1)
    }
  }

  internal enum Bananas {
    /// Those %d bananas belong to %@.
    internal static func owner(_ p1: Int, _ p2: Any) -> String {
      return L10n.tr("bananas.owner", p1, String(describing: p2))
    }
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/Strings/structured-swift5/localizable.swift)

## Usage example

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.Apples.count(3)
let bananas = L10n.Bananas.owner(5, "Olivier")
```
