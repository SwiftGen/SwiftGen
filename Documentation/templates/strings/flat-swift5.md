## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | strings/flat-swift5.stencil |
| Configuration example | <pre>strings:<br />  inputs: path/to/Localizable.strings<br />  outputs:<br />    templateName: flat-swift5<br />    output: Strings.swift</pre> |
| Language | Swift 5 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 5* code.
- If you use unstructured key names for your strings, or a structure that we don't support (yet). If you use "dot-syntax" keys, please check out the [structured-swift5](structured-swift5.md) template.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `bundle` | `BundleToken.bundle` | Allows you to set from which bundle strings are loaded from. By default, it'll point to the same bundle as where the generated code is. Note: ignored if `lookupFunction` parameter is set. |
| `enumName` | `L10n` | Allows you to change the name of the generated `enum` containing all string tables. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `lookupFunction` | N/A¹ | Allows you to set your own custom localization function. The function needs to have as signature: `(key: String, table: String) -> String`. The parameters of your function can have any name (or even no external name), but if it has named parameters, you must provide the complete function signature, including those named parameters – e.g. `yourFunctionName(forKey:table:)`. Note: if you define this parameter, the `bundle` parameter will be ignored. |
| `stringLocale` | N/A | If you use bundle or lookupFunction to customize the string format, and the locale of the string format is different from the current locale of the system, using the plural in stringDict will always return the plural characters pointed to by other, you can use stringLocale to specify the same as string format locale. |
| `noComments` | N/A | Setting this parameter will disable the comments describing the translation of a key. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

1. _If you don't provide a `lookupFunction`, we will use `localizedString(forKey:value:table:)` on the `bundle` parameter instead._

## Generated Code

**Extract:**

```swift
internal enum L10n {
  /// Some alert body there
  internal static let alertMessage = L10n.tr("Localizable", "alert__message")
  /// Title of the alert
  internal static let alertTitle = L10n.tr("Localizable", "alert__title")
  /// You have %d apples
  internal static func applesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  internal static func bananasOwner(_ p1: Int, _ p2: Any) -> String {
    return L10n.tr("Localizable", "bananas.owner", p1, String(describing: p2))
  }
}
```

[Full generated code](../../../Sources/TestUtils/Fixtures/Generated/Strings/flat-swift5/localizable.swift)

## Usage example

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.applesCount(3)
let bananas = L10n.bananasOwner(5, "Olivier")
```
