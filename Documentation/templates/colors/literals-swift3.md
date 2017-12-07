## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | colors/literals-swift3.stencil |
| Invocation example | `swiftgen colors -t literals-swift3 …` |
| Language | Swift 3 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 3* code
- Supports _multiple_ color names with the _same_ value
- Uses `#colorLiteral`s for easy preview of the actual color

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `ColorName` | Allows you to change the name of the generated `enum` containing all colors. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

Note: if you use `--param enumName=UIColor` (or `NSColor` on macOS) then the color constants will be generated as an extension of the `UIColor` (iOS) / `NSColor` (macOS) type directly without creating a separate `enum` type for namespacing those color constants.

## Generated Code

**Extract:**

```swift
extension ColorName {
  /// 0x339666ff (r: 51, g: 150, b: 102, a: 255)
  static let articleBody = #colorLiteral(red: 0.2, green: 0.588235, blue: 0.4, alpha: 1.0)
  /// 0xff66ccff (r: 255, g: 102, b: 204, a: 255)
  static let articleFootnote = #colorLiteral(red: 1.0, green: 0.4, blue: 0.8, alpha: 1.0)
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Colors/literals-swift3-context-defaults.swift)

## Usage example

```swift
// To reference a color, simpy reference its static instance by name:
let title = ColorName.articleBody
let footnote = ColorName.articleFootnote
```
