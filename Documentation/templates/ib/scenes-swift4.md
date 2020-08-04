## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | ib/scenes-swift4.stencil |
| Configuration example | <pre>ib:<br />  inputs: dir/to/search/for/storyboards<br />  outputs:<br />    templateName: scenes-swift4<br />    output: Storyboard Scenes.swift</pre> |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code for your storyboard *scenes*.
- The generated code supports both UIKit platforms (iOS, tvOS and watchOS) and AppKit platform (macOS).
- Note: if you also need to generate code for your storyboard segues, you can use [segues-swift4](../segues-swift4.md) in addition to this one.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `bundle` | `BundleToken.bundle` | Allows you to set from which storyboard files are loaded from. By default, it'll point to the same bundle as where the generated code is. Note: ignored if `lookupFunction` parameter is set. |
| `enumName` | `StoryboardScene` | Allows you to change the name of the generated `enum` containing all storyboard scenes. |
| `ignoreTargetModule` | N/A | Setting this parameter will disable the behaviour of prefixing classes with their module name for (only) the target module. |
| `lookupFunction` | N/A¹ | Allows you to set your own custom lookup function. The function needs to have as signature: `(name: NSStoryboard.Name) -> NSStoryboard` on macOS, and `(name: String) -> UIStoryboard` on other platforms. The parameters of your function can have any name (or even no external name), but if it has named parameters, you must provide the complete function signature, including those named parameters – e.g. `myStoryboardFinder(name:)`. Note: if you define this parameter, the `bundle` parameter will be ignored. |
| `module` | N/A | By default, the template will import the needed modules for custom classes, but won’t import the target’s module to avoid an import warning — using the `PRODUCT_MODULE_NAME` environment variable to detect it. Should you need to ignore an additional module, you can provide it here. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

1. _If you don't provide a `lookupFunction`, we will use `NS/UIStoryboard(name:bundle:)` with the `bundle` parameter instead._

## Generated Code

Note: the generated code may look differently depending on the platform the storyboard file is targeting.

**Extract:**

```swift
internal enum StoryboardScene {
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let dependent = SceneType<ExtraModule.ValidatePasswordViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: Message.self)

    internal static let messagesList = SceneType<UITableViewController>(storyboard: Message.self, identifier: "MessagesList")
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/IB-iOS/scenes-swift4/all.swift)

## Usage example

```swift
// You can instantiate scenes using the `instantiate` method:
let vc = StoryboardScene.Dependency.dependent.instantiate()

// The initial scene of a storyboard can be instantiated using:
let initial = StoryboardScene.Message.initialScene.instantiate()
```
