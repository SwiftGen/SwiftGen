## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | xcassets/swift3.stencil |
| Configuration example | <pre>xcassets:<br />  inputs: dir/to/search/for/imageset/assets<br />  outputs:<br />    templateName: swift3<br />    output: Assets.swift</pre> |
| Language | Swift 3 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 3* code.
- **Warning**: Swift 3 is no longer actively supported, so we cannot guarantee that there won't be issues with the generated code.

It also takes into account any namespacing folder in your Assets Catalogs (i.e. if you create a folder in your Assets Catalog, select it, and check the "Provides Namespace" checkbox on the Attributes Inspector panel on the right)

Note: the template will generate a sub-`enum` per catalog, except if there's only one catalog. As mentioned above, sub-`enum`s will only be generated for namespaced folders. You can override this behaviour with the `forceProvidesNamespaces` parameter described [below](#customization).

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `Asset` | Allows you to change the name of the generated `enum` containing all assets. |
| `colorAliasName` | `AssetColorTypeAlias` | Allows you to change the name of the generated `typealias` for the platform specific color type. |
| `imageAliasName` | `AssetImageTypeAlias` | Allows you to change the name of the generated `typealias` for the platform specific image type. |
| `colorTypeName` | `ColorAsset` | Allows you to change the name of the struct type representing a color. |
| `dataTypeName` | `DataAsset` | Allows you to change the name of the struct type representing a data asset. |
| `imageTypeName` | `ImageAsset` | Allows you to change the name of the struct type representing an image. |
| `allValues` | N/A | Setting this parameter will enable the generation of the `allColors`, `allImages` and other such constants. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |
| `forceProvidesNamespaces` | N/A | If set, generates namespaces even for non namespacing asset folders (i.e. "Provides Namespace" is unchecked) |

## Generated Code

**Extract:**

```swift
enum Asset {
  enum Docs {
  	static let readme = DataAsset(value: "Readme")
  }
  enum Exotic {
    static let banana = ImageAsset(value: "Exotic/Banana")
    static let mango = ImageAsset(value: "Exotic/Mango")
  }
  static let json = DataAsset(value: "JSON")
  static let `private` = ImageAsset(value: "private")
  enum Theme {
  	static let primary = ColorAsset(value: "Theme/Primary")
  	static let background = ColorAsset(value: "Theme/Background")
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/XCAssets/swift3/all.swift)

## Usage example

```swift
// You can create new images by referring to the enum instance and calling `.image` on it:
let bananaImage = Asset.Exotic.banana.image
let privateImage = Asset.private.image

// Or as an alternative, you use the convenience constructor like this:
let sameBananaImage = UIImage(asset: Asset.Exotic.banana)
let samePrivateImage = UIImage(asset: Asset.private)

// You can create data items by referring to the enum instance and calling `.data` on it:
let json = Asset.json.data
let readme = Asset.Docs.readme.data

// Or as an alternative, you use the convenience constructor like this:
let sameJson = NSDataAsset(asset: Asset.json)
let sameReadme = NSDataAsset(asset: Asset.Docs.readme)

// You can create colors by referring to the enum instance and calling `.color` on it:
let primaryColor = Asset.Theme.primary.color
let backgroundColor = Asset.Theme.background.color

// Or as an alternative, you use the convenience constructor like this:
let samePrimaryColor = UIColor(asset: Asset.Theme.primary)
let sameBackgroundColor = UIColor(asset: Asset.Theme.background)
```
