# Interface Builder parser

## Input

The interface builder parser accepts either a file or a directory, which it'll search for `storyboard` files. The parser will load all the scenes and all the segues for each storyboard. It supports both AppKit (macOS) and UIKit (iOS, watchOS, tvOS) storyboards.

## Output

The output context has the following structure:

 - `modules`    : `Array<String>` — List of modules used by scenes and segues — typically used for "import" statements
 - `platform`   : `String` — Name of the target platform (only available if all storyboards target the same platform)
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `platform`: `String` — Name of the target platform (iOS, macOS, tvOS, watchOS)
    - `initialScene`: `Dictionary` — Same structure as scenes item (absent if not specified)
    - `scenes`: `Array` - List of scenes
       - `identifier` : `String` — The scene identifier
       - `customClass`: `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
       - `type`: `String` — The fully qualified type of the scene (custom class, or base type prefixed with platform
          class prefix such as `UI`)
       - `module`: `String` — The module of the scene, could be the value of `customModule`, or of an internal module
          such as GLKit depending on the base type (can be empty)
       - `moduleIsPlaceholder`: `Bool` — This property is true if the user has checked the "Inherit module from target"
          setting.
    - `segues`: `Array` - List of segues
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
       - `type`: `String` — The fully qualified type of the segue (custom class, or base type prefixed with platform
          class prefix such as `UI`)
       - `module`: `String` — The module of the segue, could be the value of `customModule`, or of an internal module
          such as GLKit depending on the base type (can be empty)
       - `moduleIsPlaceholder`: `Bool` — This property is true if the user has checked the "Inherit module from target"
          setting.

## Example

```yaml
modules:
- "AVKit"
- "ExtraModule"
- "GLKit"
- "LocationPicker"
- "SlackTextViewController"
- "SwiftGen"
- "UIKit"
platform: "iOS"
storyboards:
- initialScene:
    baseType: "ViewController"
    identifier: ""
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIViewController"
  name: "Message"
  platform: "iOS"
  scenes:
  - baseType: "ViewController"
    identifier: "Composer"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIViewController"
  - baseType: "TableViewController"
    identifier: "MessagesList"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UITableViewController"
  - baseType: "NavigationController"
    identifier: "NavCtrl"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UINavigationController"
  - customClass: "PickerViewController"
    customModule: ""
    identifier: "URLChooser"
    module: ""
    moduleIsPlaceholder: true
    type: "PickerViewController"
  segues:
  - customClass: "SlideLeftSegue"
    customModule: "SwiftGen"
    identifier: "CustomBack"
    module: "SwiftGen"
    moduleIsPlaceholder: false
    type: "SlideLeftSegue"
  - customClass: ""
    customModule: ""
    identifier: "Embed"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIStoryboardSegue"
  - customClass: ""
    customModule: ""
    identifier: "NonCustom"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIStoryboardSegue"
  - customClass: "CustomSegueClass"
    customModule: ""
    identifier: "Show-NavCtrl"
    module: ""
    moduleIsPlaceholder: true
    type: "CustomSegueClass"
- initialScene:
    customClass: "CreateAccViewController"
    customModule: "SwiftGen"
    identifier: "CreateAccount"
    module: "SwiftGen"
    moduleIsPlaceholder: false
    type: "CreateAccViewController"
  name: "Wizard"
  platform: "iOS"
  scenes:
  - baseType: "ViewController"
    identifier: "Accept-ToS"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIViewController"
  - customClass: "CreateAccViewController"
    customModule: "SwiftGen"
    identifier: "CreateAccount"
    module: "SwiftGen"
    moduleIsPlaceholder: false
    type: "CreateAccViewController"
  - baseType: "TableViewController"
    identifier: "Preferences"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UITableViewController"
  - customClass: "ValidatePasswordViewController"
    customModule: "ExtraModule"
    identifier: "Validate_Password"
    module: "ExtraModule"
    moduleIsPlaceholder: false
    type: "ValidatePasswordViewController"
  segues:
  - customClass: ""
    customModule: ""
    identifier: "ShowPassword"
    module: "UIKit"
    moduleIsPlaceholder: false
    type: "UIStoryboardSegue"
```
