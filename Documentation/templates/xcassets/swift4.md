## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | xcassets/swift4.stencil |
| Invocation example | `swiftgen xcassets -t swift4 …` |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code

It also takes into account any namespacing folder in your Assets Catalogs (i.e. if you create a folder in your Assets Catalog, select it, and check the "Provides Namespace" checkbox on the Attributes Inspector panel on the right)

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `Asset` | Allows you to change the name of the generated `enum` containing all assets. |
| `colorAliasName` | `AssetColorTypeAlias` | Allows you to change the name of the generated `typealias` for the platform specific color type. |
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
    static let banana = ImageAsset(value: "Exotic/Banana")
    static let mango = ImageAsset(value: "Exotic/Mango")
  }
  static let `private` = ImageAsset(value: "private")
  enum Theme {
  	static let primary = ColorAsset(value: "Theme/Primary")
  	static let background = ColorAsset(value: "Theme/Background")
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/XCAssets/swift4-context-all.swift)

## Usage example

```swift
// You can create new images by referring to the enum instance and calling `.image` on it:
let bananaImage = Asset.Exotic.banana.image
let privateImage = Asset.private.image

// Or as an alternative, you use the convenience constructor like this:
let sameBananaImage = UIImage(asset: Asset.Exotic.banana)
let samePrivateImage = UIImage(asset: Asset.private)

// similarly, you can create colors by referring to the enum instance and calling `.color` on it:
let primaryColor = Asset.Theme.primary.color
let backgroundColor = Asset.Theme.background.color

// Or as an alternative, you use the convenience constructor like this:
let samePrimaryColor = UIColor(asset: Asset.Theme.primary)
let sameBackgroundColor = UIColor(asset: Asset.Theme.background)
```
