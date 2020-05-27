# SwiftGen 6.0 Migration Guide

If you're moving from SwiftGen 5.x to SwiftGen 6.0, you'll need to be aware that some templates have been renamed, removed or merged with others. Follow this Migration Guide to use the new name for SwiftGen 6.x of the templates you were previously using with SwiftGen 5.x.

## Deprecated templates in SwiftGen 6.0

### Colors

| Old | New | Reason |
| --- | --- | ------ |
| `literals-swift3` | ✅ `literals-swift3` | |
| `literals-swift4` | ✅ `literals-swift4` | |
| `swift2` | ❌ _deleted_ | Really old Swift version |
| `swift3` | ✅ `swift3` | |
| `swift4` | ✅ `swift4` | |

### Fonts

| Old | New | Reason |
| --- | --- | ------ |
| `swift2` | ❌ _deleted_ | Really old Swift version |
| `swift3` | ✅ `swift3` | |
| `swift4` | ✅ `swift4` | |

### Storyboards / IB

The templates have been split up into separate templates for each specific functionality, in preparation of future functionalities such as accessibility identifiers.
- One template to generate scene information.
- One template to generate segue information.

| Old | New | Reason |
| --- | --- | ------ |
| `swift2` | ❌ _deleted_ | Really old Swift version |
| `swift3` | ➡️ `scenes-swift3`/`segues-swift3` | Split up into separate templates for the scenes and segues functionality |
| `swift4` | ➡️ `scenes-swift4`/`segues-swift4` | Split up into separate templates for the scenes and segues functionality |

⚠️ The `storybards` parser command from SwiftGen 5.x has been renamed `ib` in SwiftGen 6.0, so be sure to put those templates in a `ib` subfolder and not an `storyboards` subfolder. Also be sure to read the paragraph in [the general Migration Guide](../MigrationGuide.md#commands-can-have-multiple-outputs) about how to generate multiple outputs (from multiple templates) for a single input (a single set of input IB files).

### Strings

| Old | New | Reason |
| --- | --- | ------ |
| `flat-swift2` | ❌ _deleted_ | Really old Swift version |
| `flat-swift3` | ✅ `flat-swift3` | |
| `flat-swift4` | ✅ `flat-swift4` | |
| `structured-swift2` | ❌ _deleted_ | Really old Swift version |
| `structured-swift3` | ✅ `structured-swift3` | |
| `structured-swift4` | ✅ `structured-swift4` | |

### XCAssets

| Old | New | Reason |
| --- | --- | ------ |
| `swift2` | ❌ _deleted_ | Really old Swift version |
| `swift3` | ✅ `swift3` | |
| `swift4` | ✅ `swift4` | |

## Functionality changes in SwiftGen 6.0

All templates now have `swiftlint:disable all` at the top, so `swiftlint` users no longer need to ignore the generated files, although this is still highly recommended.

SwiftGen 6.0 uses the latest [Stencil](https://github.com/stencilproject/Stencil/blob/master/CHANGELOG.md#0131) and [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit/blob/master/CHANGELOG.md#270) libraries, so there are plenty of new features for template writers, such as variable subscripting, an `indent` filter, better error reporting, ...

### Fonts

The template now provides a `registerAllCustomFonts()` function, which can be useful if you use custom fonts in your Interface Builder files. Just call it when your application starts. Otherwise, fonts will still auto-register when they're first used in code.

Note that if you call this method, you don't need to list the custom fonts under the `UIAppFonts` key of your `Info.plist` anymore. Calling this method instead of listing your custom fonts in your `Info.plist` thus has two advantages: you don't have to maintain the list up-to-date anymore when you add/remove a custom font, and it also works well with custom fonts you might embed in your frameworks (which don't have that `UIAppFonts` key in their own `Info.plist`).

### Storyboards / IB

The segues template now generates a handy initializer on `SegueType` for use in `prepareForSegue`, for example:

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  switch StoryboardSegue.Message(segue) {
  case .embed?:
    // Prepare for your custom segue transition, passing information to the destionation VC
  case .customBack?:
    // Prepare for your custom segue transition, passing information to the destionation VC
  default:
    // Other segues from other scenes, not handled by this VC
    break
  }
}
```

The templates now handle the "Inherit module from target" setting in Interface Builder, so you may no longer need to set the `module: ...` parameter anymore if you have multiple targets.

### Strings

A thing of note for some users is that the SwiftGen parser no longer consolidates keys with different casing. This may affect you if you have `strings` files with inconsistent keys. See the [contexts Migration Guide](../SwiftGen%20Contexts.md#swiftgen-60-migration-guide) for more information.

### XCAssets

All groups (folders) are no longer namespaced by default. A group will now only be namespaced if you've enabled the corresponding "provides namespace" for that group in Xcode. To enable the old behaviour again, use the `forceProvidesNamespaces` parameter in your config file.

The template now supports `NSDataAsset` sets, so you can now safely access items such as JSON files or any other data files from your asset catalog.

Some smaller changes:
* The template no longer generates `allXXX` constants by default. This can be turned on again with the `allValues` parameter in your config file.
* Together with the previous item, the `noAllValues` parameter has been removed in favour of the `allValues` parameter in your config file.
* The old `allValues` constant (which was an alias for `allImages`) has been removed, use `allImages` instead.
* The deprecated `Image` typealias (to `UIImage`/`NSImage`) has been renamed to `AssetImageTypeAlias`.


# Templates 2.1 Migration Guide

<details>
<summary>Migration Guide</summary>

## Functionality changes in 2.1 (SwiftGen 5.1)

### XCAssets

The static `allValues` constant has been deprecated in favor of the `allImages` and `allColors` constants. This is because we've added support for named colors in asset catalogs.

</details>

# Templates 2.0 Migration Guide

<details>
<summary>Migration Guide</summary>

If you're moving from SwiftGen 4.x to SwiftGen 5.0, you'll need to be aware that some templates have been renamed, removed or merged with others. Follow this Migration Guide to use the new name for SwiftGen 5.x of the templates you were previously using with SwiftGen 4.x.

## Deprecated templates in 2.0 (SwiftGen 5.0)

The two general themes for this version are:

- Templates now reside in the subfolder corresponding to their parser (`colors`, `fonts`, ...) instead of the filename being prefixed with it.
- The `default` template doesn't exist anymore, templates now specify which swift version they support.

Below is a list of renamed ("➡️") and removed ("❌") templates, grouped by parser. If your template hasn't been renamed or removed, you don't need to do anything ("✅"). You still might want to review the documentation for that template, as there might be new features you may be interested in.

### Colors

| Old | New | Reason |
| --- | --- | ------ |
| `default` | ➡️ `swift2` | |
| `rawvalues` | ❌ _deleted_ | Seldomly used |
| `swift3` | ✅ `swift3` | |

### Fonts

| Old | New | Reason |
| --- | --- | ------ |
| `default` | ➡️ `swift2` | |
| `swift3` | ✅ `swift3` | |

### Images / XCAssets

| Old | New | Reason |
| --- | --- | ------ |
| `allvalues` | ➡️ `swift2`/`swift3` | All templates by default now generate an `allValues` static constant |
| `default` | ⚠️ `swift2` | Now integrates the recursive features of the previously named `dot-syntax` template |
| `dot-syntax` | ➡️ `swift2` | |
| `dot-syntax-swift3` | ➡️ `swift3` | |
| `swift3` | ⚠️ `swift3` | Now integrates the recursive features of the previously named `dot-syntax-swift3` template |

⚠️ The `images` parser command from SwiftGen 4.x has been renamed `xcassets` in SwiftGen 5.0, so be sure to put those templates in a `xcassets` subfolder and not an `images` subfolder.

### Storyboards

| Old | New | Reason |
| --- | --- | ------ |
| `default` | ➡️ `swift2` | |
| `lowercase` | ❌ _deleted_ | No longer needed since we prefix classes with their module |
| `osx-default` | ➡️ `swift2` | Unified with the iOS template, just use `swift2` |
| `osx-lowercase` | ❌ _deleted_ | No longer needed since we prefix classes with their module |
| `osx-swift3` | ➡️ `swift3` | Unified with the iOS template, just use `swift3` |
| `swift3` | ⚠️ `swift3` | You'll probably need to adapt your call sites. See below. |
| `uppercase` | ❌ _deleted_ | No longer needed since we prefix classes with their module |

### Strings

| Old | New | Reason |
| --- | --- | ------ |
| `default` | ➡️ `flat-swift2` | |
| `dot-syntax` | ➡️ `structured-swift2` | |
| `dot-syntax-swift3` | ➡️ `structured-swift3` | |
| `genstrings` | ❌ _deleted_ | Seldomly used |
| `no-comments-swift3` | ❌ _deleted_ | The other templates now support a `noComments` parameter |
| `structured` | ❌ _deleted_ | Deprecated by `dot-syntax` (now called `structured-swift2/3`) |
| `swift3` | ➡️ `flat-swift3` | |

## Functionality changes in 2.0 (SwiftGen 5.0)

### Storyboards

You'll probably notice that your old codebase won't work with the new generated code. This is because we use a new, swiftier way of generating types for storyboard scenes. What it boils down to is that, if you had the following line in your code base:

```swift
StoryboardScene.Message.instantiateMessageList()
```

It should now become:

```swift
StoryboardScene.Message.messageList.instantiate()
```

💡 Tip: to help you do this transition, you may be interested in using the ["compatibility template"](https://github.com/SwiftGen/templates/wiki/SwiftGen-5.0-Migration:-compatibility-template) we suggest here. It will allow you to generate compatibility code for the old storyboard function calls, generating **depreciation warnings + renaming fix-its** for that SwiftGen 4.x API. This way you could then **use Xcode's "Fix all in scope" feature** to let Xcode do the renaming and migration for you!

</details>
