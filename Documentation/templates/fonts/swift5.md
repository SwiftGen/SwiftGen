## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | fonts/swift5.stencil |
| Configuration example | <pre>fonts:<br />  inputs: path/to/font/dir<br />  outputs:<br />    templateName: swift5<br />    output: Fonts.swift</pre> |
| Language | Swift 5 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 5* code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `FontFamily` | Allows you to change the name of the generated `enum` containing all font families. |
| `fontTypeName` | `FontConvertible` | Allows you to change the name of the struct type representing a font. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all font paths. Use this if you added your font folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |
| `fontAliasName` | `Font` | **Deprecated** Allows you to change the name of the `typealias` representing a font. Useful when working with SwiftUI, which defines it's own `Font` type. |

## Generated Code

**Extract:**

```swift
internal enum FontFamily {
  internal enum SFNSDisplay {
    internal static let black = FontConvertible(name: ".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    internal static let bold = FontConvertible(name: ".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    internal static let heavy = FontConvertible(name: ".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    internal static let regular = FontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  internal enum ZapfDingbats {
    internal static let regular = FontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/Fonts/swift5/defaults.swift)

## Usage example

```swift
// You can create fonts with the convenience constructor like this:
let displayRegular = UIFont(font: FontFamily.SFNSDisplay.regular, size: 20.0)
let dingbats = UIFont(font: FontFamily.ZapfDingbats.regular, size: 20.0)

// Or as an alternative, you can refer to enum instance and call .font on it:
let sameDisplayRegular = FontFamily.SFNSDisplay.regular.font(size: 20.0)
let sameDingbats = FontFamily.ZapfDingbats.regular.font(size: 20.0)
```
