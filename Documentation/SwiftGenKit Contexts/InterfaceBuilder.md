# Interface Builder parser

## Input

The interface builder parser accepts either a file or a directory, which it'll search for `storyboard` files. The parser will load all the scenes and all the segues for each storyboard. It supports both AppKit (macOS) and UIKit (iOS, watchOS, tvOS) storyboards. 

## Output

The output context has the following structure:

 - `modules`    : `Array<String>` — List of modules used by scenes and segues — typically to be used for "import" statements
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
    - `segues`: `Array` - List of segues
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
       - `type`: `String` — The fully qualified type of the segue (custom class, or base type prefixed with platform
          class prefix such as `UI`)
       - `module`: `String` — The module of the segue, could be the value of `customModule`, or of an internal module
          such as GLKit depending on the base type (can be empty)

## Example

```yaml
modules:
- "AVKit"
- "CustomSegue"
- "GLKit"
- "LocationPicker"
- "SlackTextViewController"
- "UIKit"
platform: "iOS"
storyboards:
- initialScene:
    baseType: "ViewController"
    identifier: ""
    module: "UIKit"
    type: "UIViewController"
  name: "Message"
  platform: "iOS"
  scenes:
  - baseType: "ViewController"
    identifier: "Composer"
    module: "UIKit"
    type: "UIViewController"
  - baseType: "TableViewController"
    identifier: "MessagesList"
    module: "UIKit"
    type: "UITableViewController"
  - baseType: "NavigationController"
    identifier: "NavCtrl"
    module: "UIKit"
    type: "UINavigationController"
  - customClass: "XXPickerViewController"
    customModule: ""
    identifier: "URLChooser"
    module: ""
    type: "XXPickerViewController"
  segues:
  - customClass: "CustomSegueClass2"
    customModule: ""
    identifier: "CustomBack"
    module: ""
    type: "CustomSegueClass2"
  - customClass: "CustomSegueClass"
    customModule: ""
    identifier: "Show-NavCtrl"
    module: ""
    type: "CustomSegueClass"
- initialScene:
    customClass: "CreateAccViewController"
    customModule: ""
    identifier: "CreateAccount"
    module: ""
    type: "CreateAccViewController"
  name: "Wizard"
  platform: "iOS"
  scenes:
  - baseType: "ViewController"
    identifier: "Accept-ToS"
    module: "UIKit"
    type: "UIViewController"
  - customClass: "CreateAccViewController"
    customModule: ""
    identifier: "CreateAccount"
    module: ""
    type: "CreateAccViewController"
  - baseType: "TableViewController"
    identifier: "Preferences"
    module: "UIKit"
    type: "UITableViewController"
  - baseType: "ViewController"
    identifier: "Validate_Password"
    module: "UIKit"
    type: "UIViewController"
  segues:
  - customClass: ""
    customModule: ""
    identifier: "ShowPassword"
    module: "UIKit"
    type: "UIStoryboardSegue"
```
