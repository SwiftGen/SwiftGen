## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | colors/swift4.stencil |
| Configuration example | <pre>colors:<br />  inputs: path/to/colors-file.txt<br />  outputs:<br />    templateName: swift4<br />    output: Colors.swift</pre> |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code.
- Supports _multiple_ color names with the _same_ value.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `colorAliasName` | `Color` | Allows you to change the name of the generated `typealias` for the platform specific color type. |
| `enumName` | `ColorName` | Allows you to change the name of the generated `enum` containing all colors. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#339666"></span>
  /// Alpha: 100% <br/> (0x339666ff)
  internal static let articleBody = ColorName(rgbaValue: 0x339666ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff66cc"></span>
  /// Alpha: 100% <br/> (0xff66ccff)
  internal static let articleFootnote = ColorName(rgbaValue: 0xff66ccff)
}
```

[Full generated code](../../../Tests/Fixtures/Generated/Colors/swift4/defaults.swift)

## Usage example

```swift
// You can create colors with the convenience constructor like this:
let title = UIColor(named: .articleBody)
let footnote = UIColor(named: .articleFootnote)

// Or as an alternative, you can refer to enum instance and call .color on it:
let sameTitle = ColorName.articleBody.color
let sameFootnote = ColorName.articleFootnote.color
```
