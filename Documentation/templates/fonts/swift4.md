## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | fonts/swift4.stencil |
| Invocation example | `swiftgen fonts -t swift4 …` |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code

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
    static let black = FontConvertible(name: ".SFNSDisplay-Black", family: ".SF NS Display", path: "SFNSDisplay-Black.otf")
    static let bold = FontConvertible(name: ".SFNSDisplay-Bold", family: ".SF NS Display", path: "SFNSDisplay-Bold.otf")
    static let heavy = FontConvertible(name: ".SFNSDisplay-Heavy", family: ".SF NS Display", path: "SFNSDisplay-Heavy.otf")
    static let regular = FontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  enum ZapfDingbats {
    static let regular = FontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Fonts/swift4-context-defaults.swift)

## Usage example

```swift
// You can create fonts with the convenience constructor like this:
let displayRegular = UIFont(font: FontFamily.SFNSDisplay.regular, size: 20.0)
let dingbats = UIFont(font: FontFamily.ZapfDingbats.regular, size: 20.0)

// Or as an alternative, you can refer to enum instance and call .font on it:
let sameDisplayRegular = FontFamily.SFNSDisplay.regular.font(size: 20.0)
let sameDingbats = FontFamily.ZapfDingbats.regular.font(size: 20.0)
```
