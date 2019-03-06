## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | xcassets/simple-swift4.stencil |
| Configuration example | <pre>xcassets:<br />  inputs: dir/to/search/for/imageset/assets<br />  outputs:<br />    templateName: simple-swift4<br />    output: Assets.swift</pre> |
| Language | Swift 4 |
| Author | Cihat Gündüz |

## When to use it

- When you need to generate *Swift 4* code.
- When you don't need trait collections.
- When you want to keep your calls short.

It also takes into account any namespacing folder in your Assets Catalogs (i.e. if you create a folder in your Assets Catalog, select it, and check the "Provides Namespace" checkbox on the Attributes Inspector panel on the right)

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `Asset` | Allows you to change the name of the generated `enum` containing all assets. |
| `allValues` | N/A | Setting this parameter will enable the generation of the `allColors`, `allImages` and other such constants. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |
| `forceProvidesNamespaces` | N/A | If set, generates namespaces even for non namespacing asset folders (i.e. "Provides Namespace" is unchecked) |

## Generated Code

**Extract:**

```swift
internal typealias Docs = Asset.Docs
internal typealias Exotic = Asset.Exotic
internal typealias Theme = Asset.Theme

enum Asset {
  enum Docs {
  	static let readme = NSDataAsset(name: "Readme", bundle: Bundle(for: BundleToken.self))!.data
  }
  enum Exotic {
    static let banana = UIImage(named: "Exotic/Banana", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    static let mango = UIImage(named: "Exotic/Mango", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  }
  static let json = NSDataAsset(name: "JSON", bundle: Bundle(for: BundleToken.self))!.data
  static let `private` = UIImage(named: "private", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  enum Theme {
  	static let primary = UIColor(named: "Theme/Primary", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  	static let background = UIColor(named: "Theme/Background", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/XCAssets/simple-swift4/all.swift)

## Usage example

```swift
// You can create new images by referring to the enum instance (via typealias if available):
let bananaImage: UIImage = Exotic.banana
let privateImage: UIImage = Asset.private

// You can create data items by referring to the enum instance (via typealias if available):
let json: Data = Asset.json
let readme: Data = Docs.readme

// You can create colors by referring to the enum instance and calling `.color` on it:
let primaryColor: UIColor = Theme.primary
let backgroundColor: UIColor = Theme.background
```
