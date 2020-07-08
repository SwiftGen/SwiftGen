## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | ib/segues-swift4.stencil |
| Configuration example | <pre>ib:<br />  inputs: dir/to/search/for/storyboards<br />  outputs:<br />    templateName: segues-swift4<br />    output: Storyboard Segues.swift</pre> |
| Language | Swift 4 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 4* code for your storyboard *segues*.
- The generated code supports both UIKit platforms (iOS, tvOS and watchOS) and AppKit platform (macOS).
- Note: if you also need to generate code for your storyboard scenes, you can use [scenes-swift4](../scenes-swift4.md) in addition to this one.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `enumName` | `StoryboardSegue` | Allows you to change the name of the generated `enum` containing all storyboard segues. |
| `ignoreTargetModule` | N/A | Setting this parameter will disable the behaviour of prefixing classes with their module name for (only) the target module. |
| `module` | N/A | By default, the template will import the needed modules for custom classes, but won’t import the target’s module to avoid an import warning — using the `PRODUCT_MODULE_NAME` environment variable to detect it. Should you need to ignore an additional module, you can provide it here. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

Note: the generated code may look differently depending on the platform the storyboard file is targeting.

**Extract:**

```swift
internal enum StoryboardSegue {
  internal enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
  }
}
```

[Full generated code](../../../Tests/Fixtures/Generated/IB-iOS/swift4/all.swift)

## Usage example

```swift
// You can perform segues using:
vc.perform(segue: StoryboardSegue.Message.embed)

// or match them (in prepareForSegue):
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
