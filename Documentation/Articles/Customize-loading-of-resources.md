# Customize loading of resources

By default, the built-in templates provided by SwiftGen will load resources from the same bundle as where the generated code is located at:
- If your generated code is in the main app, it will load resources from the `main` bundle.
- If your generated code is in a Framework, it will load resources from that Framework's bundle.

This works for most users, but there may be sitations where you'll need a more advanced solution.

## Override the default Bundle

Let's say you are developing a CocoaPods Pod for example. CocoaPods recommends the use of the `resource_bundles` option ([more info](https://guides.cocoapods.org/syntax/podspec.html#resource_bundles)) for adding resources to your Pod. Using this option, your resources will be grouped into a separate bundle.

The advantage of this is that, no matter how an end-user adds your Pod to their project, your resources won't ever clash with their resources. This is especially important with static linking, where CocoaPods won't generate a Framework for each Pod and add everything to the main App bundle of a user.

The disadvantage is that your resources are no longer located in the same bundle as your generated code, but in (for example) a sub-bundle `MyAwesomePodResources.bundle`. The generated code by SwiftGen will no longer work.

### Solution

To fix this, you can set the `bundle` template parameter to point to something in your code that represents your resources bundle.

Let's say you have the following Swift code somewhere in your app:

```swift
final class MyAwesomePod {
  // This is the bundle where your code resides in
  static let bundle = Bundle(for: MyAwesomePod.self)

  // Your resources bundle is inside that bundle
  static let resourcesBundle: Bundle = {
    guard let url = bundle.url(forResource: "MyAwesomePodResources", withExtension: "bundle"),
      let bundle = Bundle(url: url) else {
      fatalError("Can't find 'MyAwesomePodResources' bundle")
    }
    return bundle
  }()
}
```

You want SwiftGen to generate code to load resources from `MyAwesomePod.resourcesBundle`. Update your configuration file and add the `bundle` parameter, like so:
Since you want SwiftGen to generate code to load resources (localized strings and fonts for example) from `MyAwesomePod.resourcesBundle`, you can update your configuration file to add the `bundle` parameter, like so:

```yaml
input_dir: Resources
output_dir: Sources
fonts:
  inputs: Fonts
  outputs:
    templateName: swift5
    output: Generated/Fonts.swift
    params:
      bundle: MyAwesomePod.resourcesBundle
strings:
  inputs: en.lproj/Localizable.strings
  outputs:
    templateName: structured-swift5
    output: Generated/Strings.swift
    params:
      bundle: MyAwesomePod.resourcesBundle
```

Run SwiftGen again to update the generated code, and voila! Your generated code will now load the localised strings and fonts from that resources bundle instead of the bundle where the generated code is.

Consult each [templates documentation](../templates/) to learn more about this parameter and ensure it's supported by the template you want to use.

## Override the lookup function

If you need a more advanced solution than just changing the bundle used for loading resources, you can override the "lookup function".

For example you may want to override the way localisation strings are loaded, if you want to override the device's language by some language chosen in your app. Another use case is if your project is organised in multiple white-label app targets, all using the same framework, and you want to allow the app target to override a translation otherwise provided by the common framework, etc…

Another more complex example: lets say you have a system where you have a set strings localisation files for your application. These are of course embedded in your application as they always are. But you also want to be able to update these translations on-the-fly, by having your app regularly check and download newer versions of these translation files.

### Solution

What you want is SwiftGen to first check the updated translations if available, and otherwise fallback to the embedded translations.

Let's say you have the following Swift code somewhere in your app:

```swift
final class TranslationService {
  static let shared = TranslationService()

  private typealias TranslationTable = [String: String]
  private var updatedTables: [String: TranslationTable] = [:]

  func lookupTranslation(forKey key: String, inTable table: String) -> String {
    if let table = updatedTables[table], let translation = table[key] {
      return translation
    } else {
      return Bundle.main.localizedString(forKey: key, value: nil, table: table)
    }
  }
}
```

We leave the implementation of how to update and load `updatedTables` as an exercise to the reader. You now want SwiftGen to use the `lookupTranslation` function. Update your configuration file and add the `lookupFunction` parameter, like so:

```yaml
input_dir: Resources
output_dir: Sources
strings:
  inputs: en.lproj/Localizable.strings
  outputs:
    templateName: structured-swift5
    output: Generated/Strings.swift
    params:
      lookupFunction: TranslationService.shared.lookupTranslation(forKey:inTable:)
```

Note that we provided the full signature of the function.

- The signature of this `lookupFunction` depends on which parser & template you're using. It will be different for `strings` templates vs `font` templates for example.
- Note that this parameter currently is not available for `xcassets` templates (because XCAssets don't have just one but multiple methods used depending on the asset type).
- Check [each template's dedicated documentation](../templates/) for more information.
