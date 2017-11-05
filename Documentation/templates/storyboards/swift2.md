## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File name | storyboards/swift2.stencil |
| Invocation example | `swiftgen storyboards -t swift2 …` |
| Language | Swift 2 |
| Author | Olivier Halligon |

## When to use it

- When you need to generate *Swift 2* code
- The generated code supports both UIKit platforms (iOS, tvOS and watchOS) and AppKit platform (macOS)
- **Warning**: Swift 2 is no longer actively supported, so we won't maintain this template and don't unit-test the generated code for it anymore.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen` in the command line, using `--param <paramName>=<newValue>`

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `sceneEnumName` | `StoryboardScene` | Allows you to change the name of the generated `enum` containing all storyboard scenes. |
| `segueEnumName` | `StoryboardSegue` | Allows you to change the name of the generated `enum` containing all storyboard segues. |
| `module` | N/A | By default, the template will import the needed modules for custom classes, but won’t import the target’s module to avoid an import warning — using the `PRODUCT_MODULE_NAME` environment variable to detect it. Should you need to ignore an additional module, you can provide it here. |
| `ignoreTargetModule` | N/A | Setting this parameter will disable the behaviour of prefixing classes with their module name for (only) the target module. |
| `publicAccess` | N/A | If set, the generated constants will be marked as `public`. Otherwise, they'll be declared `internal`. |

## Generated Code

Note: the generated code may look differently depending on the platform the storyboard file is targeting.

**Extract:**

```swift
enum StoryboardScene {
  enum Dependency: StoryboardType {
    static let storyboardName = "Dependency"

    static let Dependent = SceneType<UIViewController>(Dependency.self, identifier: "Dependent")
  }
  enum Message: StoryboardType {
    static let storyboardName = "Message"

    static let MessagesList = SceneType<UITableViewController>(Message.self, identifier: "MessagesList")
  }
}
enum StoryboardSegue {
  enum Message: String, SegueType {
    case Embed
    case NonCustom
  }
}
```

[Full generated code](https://github.com/SwiftGen/templates/blob/master/Tests/Expected/Storyboards-iOS/swift2-context-all.swift)

## Usage example

```swift
// You can instantiate scenes using the `instantiate` method:
let vc = StoryboardScene.Dependency.Dependent.instantiate()

// You can perform segues using:
vc.performSegue(StoryboardSegue.Message.Embed)

// or match them (in prepareForSegue):
override func prepareForSegue(_ segue: UIStoryboardSegue, sender sender: AnyObject?) {
  switch StoryboardSegue.Message(rawValue: segue.identifier!)! {
  case .Embed:
    // Prepare for your custom segue transition
  case .NonCustom:
    // Pass in information to the destination View Controller
  }
}
```
