## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | fonts/swift2.stencil |
| Invocation example | `swiftgen fonts -t swift2 …` |
| Language | Swift 2 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 2* code
- **Warning**: Swift 2 is no longer actively supported, so we cannot guarantee that there won't be issues with the generated code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `FontFamily` | Allows you to change the name of the generated `enum` containing all font families. |
| `preservePath` | N/A | Setting this parameter will disable the basename filter applied to all font paths. Use this if you added your font folder as a "folder reference" in your Xcode project, making that folder hierarchy preserved once copied in the build app bundle. The path will be relative to the folder you provided to SwiftGen. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
enum FontFamily {
  enum SFNSDisplay {
    static let Black = FontConvertible(".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    static let Bold = FontConvertible(".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    static let Heavy = FontConvertible(".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    static let Regular = FontConvertible(".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  enum ZapfDingbats {
    static let Regular = FontConvertible("ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Fonts/swift2-context-defaults.swift)

## Usage example

```swift
// You can create fonts with the convenience constructor like this:
let displayRegular = UIFont(FontFamily.SFNSDisplay.Regular, size: 20.0)
let dingbats = UIFont(FontFamily.ZapfDingbats.Regular, size: 20.0)

// Or as an alternative, you can refer to enum instance and call .font on it:
let sameDisplayRegular = FontFamily.SFNSDisplay.Regular.font(20.0)
let sameDingbats = FontFamily.ZapfDingbats.Regular.font(20.0)
```
