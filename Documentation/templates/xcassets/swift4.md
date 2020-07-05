## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | xcassets/swift4.stencil |
| Configuration example | <pre>xcassets:<br />  inputs: dir/to/search/for/imageset/assets<br />  outputs:<br />    templateName: swift4<br />    output: Assets.swift</pre> |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code.

It also takes into account any namespacing folder in your Assets Catalogs (i.e. if you create a folder in your Assets Catalog, select it, and check the "Provides Namespace" checkbox on the Attributes Inspector panel on the right)

Note: the template will generate a sub-`enum` per catalog, except if there's only one catalog. As mentioned above, sub-`enum`s will only be generated for namespaced folders. You can override this behaviour with the `forceProvidesNamespaces` parameter described [below](#customization).

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `allValues` | N/A | Setting this parameter will enable the generation of the `allColors`, `allImages` and other such constants. |
| `arResourceGroupTypeName` | `ARResourceGroupAsset` | Allows you to change the name of the struct type representing an AR resource group. |
| `colorTypeName` | `ColorAsset` | Allows you to change the name of the struct type representing a color. |
| `dataTypeName` | `DataAsset` | Allows you to change the name of the struct type representing a data asset. |
| `enumName` | `Asset` | Allows you to change the name of the generated `enum` containing all assets. |
| `forceFileNameEnum` | N/A | Setting this parameter will generate an `enum <FileName>` _even if_ only one FileName was provided as input. |
| `forceProvidesNamespaces` | N/A | If set, generates namespaces even for non namespacing asset folders (i.e. "Provides Namespace" is unchecked) |
| `imageTypeName` | `ImageAsset` | Allows you to change the name of the struct type representing an image. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |
| `colorAliasName` | `AssetColorTypeAlias` | **Deprecated** Allows you to change the name of the generated `typealias` for the platform specific color type. |
| `imageAliasName` | `AssetImageTypeAlias` | **Deprecated** Allows you to change the name of the generated `typealias` for the platform specific image type. |

## Generated Code

**Extract:**

```swift
enum Asset {
  enum Files {
    static let data = DataAsset(value: "Data")
    static let readme = DataAsset(value: "README")
  }
  enum Food {
    enum Exotic {
      static let banana = ImageAsset(value: "Exotic/Banana")
      static let mango = ImageAsset(value: "Exotic/Mango")
    }
    static let `private` = ImageAsset(value: "private")
  }
  enum Styles {
    enum Vengo {
      static let primary = ColorAsset(value: "Vengo/Primary")
      static let tint = ColorAsset(value: "Vengo/Tint")
    }
  }
  enum Targets {
    internal static let bottles = ARResourceGroupAsset(name: "Bottles")
    internal static let paintings = ARResourceGroupAsset(name: "Paintings")
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/XCAssets/swift4/all.swift)

## Usage example

```swift
// You can create new images by referring to the enum instance and calling `.image` on it:
let bananaImage = Asset.Exotic.banana.image
let sameBananaImage = UIImage(asset: Asset.Exotic.banana)
let privateImage = Asset.private.image
let samePrivateImage = UIImage(asset: Asset.private)

// You can create colors by referring to the enum instance and calling `.color` on it:
let primaryColor = Asset.Styles.Vengo.primary.color
let samePrimaryColor = UIColor(asset: Asset.Styles.Vengo.primary)
let tintColor = Asset.Styles.Vengo.tint.color
let sameTintColor = UIColor(asset: Asset.Styles.Vengo.tint)

// You can create data items by referring to the enum instance and calling `.data` on it:
let data = Asset.data.data
let sameData = NSDataAsset(asset: Asset.data)
let readme = Asset.readme.data
let sameReadme = NSDataAsset(asset: Asset.readme)

// you can load an AR resource group's items using:
let bottles = Asset.Targets.bottles.referenceObjects
let sameBottles = ARReferenceImage.referenceImages(in: Asset.Targets.bottles)
let paintings = Asset.Targets.paintings.referenceImages
let samePosters = ARReferenceObject.referenceObjects(in: Asset.Targets.paintings)
```
