# Customise loading of resources

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

```yaml
input_dir: Resources
output_dir: Sources
strings:
  inputs: en.lproj/Localizable.strings
  outputs:
    templateName: structured-swift5
    output: Generated/Strings.swift
    params:
      bundle: MyAwesomePod.resourcesBundle
```

Run SwiftGen again to update the generated coide, and voila! Your generated code now works with a resources bundle.

## Override the lookup function

TODO
