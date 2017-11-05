## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | xcassets/swift2.stencil |
| Invocation example | `swiftgen xcassets -t swift2 …` |
| Language | Swift 2 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 2* code
- **Warning**: Swift 2 is no longer actively supported, so we cannot guarantee that there won't be issues with the generated code.

It also takes into account any namespacing folder in your Assets Catalogs (i.e. if you create a folder in your Assets Catalog, select it, and check the "Provides Namespace" checkbox on the Attributes Inspector panel on the right)

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `Asset` | Allows you to change the name of the generated `enum` containing all assets. |
| `imageAliasName` | `Image` | Allows you to change the name of the generated `typealias` for the platform specific image type. |
| `colorTypeName` | `ColorAsset` | Allows you to change the name of the struct type representing a color. |
| `imageTypeName` | `ImageAsset` | Allows you to change the name of the struct type representing an image. |
| `noAllValues` | N/A | Setting this parameter will disable generation of the `allColors` and `allImages` constants. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

**Extract:**

```swift
enum Asset {
  enum Exotic {
    static let Banana = ImageAsset(value: "Exotic/Banana")
    static let Mango = ImageAsset(value: "Exotic/Mango")
  }
  static let Private = ImageAsset(value: "private")
  enum Theme {
  	static let Primary = ColorAsset(value: "Theme/Primary")
  	static let Background = ColorAsset(value: "Theme/Background")
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/XCAssets/swift2-context-all.swift)

## Usage example

```swift
// You can create new images by referring to the enum instance and calling `.image` on it:
let bananaImage = Asset.Exotic.Banana.image
let privateImage = Asset.Private.image

// Or as an alternative, you use the convenience constructor like this:
let sameBananaImage = UIImage(asset: Asset.Exotic.Banana)
let samePrivateImage = UIImage(asset: Asset.Private)
```

Note: This swift 2 template does not support named colors. To use those, you'll need to use a more recent swift version.
