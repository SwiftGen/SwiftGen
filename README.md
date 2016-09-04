# SwiftGen

[![Build Status](https://travis-ci.org/AliSoftware/SwiftGen.svg?branch=master)](https://travis-ci.org/AliSoftware/SwiftGen)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftGen.svg)](https://img.shields.io/cocoapods/v/SwiftGen.svg)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGen.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGen)

SwiftGen is a suite of tools written in Swift to auto-generate Swift code (or anything else actually) for various assets of your project:

* [`enums` for your Assets Catalogs images](#uiimage-and-nsimage)
* [`enums` for your `Localizable.strings` strings](#localizablestrings).
* [`enums` for your UIStoryboards and their Scenes](#uistoryboard)
* [`enums` for your NSStoryboards and their Scenes](#nsstoryboard)
* [`enums` for your Colors](#uicolor-and-nscolor).
* [`enums` for your Fonts](#uifont-and-nsfont).

There are multiple benefits in using this:

* Avoid any typo you could have when using a String
* Free auto-completion
* Avoid the risk to use an non-existing asset name
* All this will be ensured by the compiler.

## Installation

<details>
<summary>Via CocoaPods</summary>

If you're using CocoaPods, you can simply add `pod 'SwiftGen'` to your `Podfile`.

This will download the `SwiftGen` binaries and dependencies in `Pods/` during your next `pod install` execution
and will allow you to invoke it via `$PODS_ROOT/SwiftGen/bin/swiftgen` in your Script Build Phases.
</details>

<details>
<summary>Via Homebrew</summary>

To install SwiftGen via [Homebrew](http://brew.sh), simply use:

```sh
$ brew update
$ brew install swiftgen
```
</details>

<details>
<summary>Compile from source</summary>

Alternatively, you can clone the repository and use `rake install` to build the tool.  
_With this solution you're sure to build and install the latest version from `master`._

You can install to the default locations (no parameter) or to custom locations:

```sh
# Binary is installed in `./swiftgen/bin`, frameworks in `./swiftgen/lib` and templates in `./swiftgen/templates`
$ rake install
# - OR -
# Binary will be installed in `~/swiftgen/bin`, framworks in `~/swiftgen/fmk` and templates in `~/swiftgen/tpl`
$ rake install[~/swiftgen/bin,~/swiftgen/fmk,~/swiftgen/tpl]
```
</details>

## Usage

The tool is provided as a unique `swiftgen` binary command-line, with the following subcommands:

* `swiftgen images [OPTIONS] DIR`
* `swiftgen strings [OPTIONS] FILE`
* `swiftgen storyboards [OPTIONS] DIR`
* `swiftgen colors [OPTIONS] FILE`
* `swiftgen fonts [OPTIONS] DIR`

Each subcommand has its own option and syntax, but some options are common to all:

* `--output FILE` or `-o FILE`: set the file where to write the generated code. If omitted, the generated code will be printed on `stdout`.
* `--template NAME` or `-t NAME`: define the Stencil template to use (by name, see [here for more info](documentation/Templates.md#using-a-name)) to generate the output.
* `--templatePath PATH` or `-p PATH`: define the Stencil template to use, using a full path.

You can use `--help` on `swiftgen` or one of its subcommand to see the detailed usage.

### Additional documentation

You can also see in the [wiki](https://github.com/AliSoftware/SwiftGen/wiki) some additional documentation, about:

* how to [integrate SwiftGen in your Continuous Integration](https://github.com/AliSoftware/SwiftGen/wiki/Continuous-Integration) (Travis-CI, CircleCI, Jenkins, …)
* how to [integrate in your Xcode project](https://github.com/AliSoftware/SwiftGen/wiki/Integrate-SwiftGen-in-an-xcodeproj) so it rebuild the constants every time you build
* …and more.

## Choosing your template

SwiftGen is based on templates (it uses [Stencil](https://github.com/kylef/Stencil) as its template engine). This means that **you can choose the template that best fit your preferences to customize the generated code to your own conventions**.

### Bundled templates vs. Custom ones

SwiftGen comes bundled with some default templates for each of the subcommand (`colors`, `images`, `strings`, `storyboard`, `fonts`…), but you can also create your own templates if the defaults don't suit your coding conventions or needs. Simply store them in `~/Library/Application Support/SwiftGen/templates`, then use the `-t` / `--template` option to specify the name of the template to use, or store them somewhere else (like in your project repository) and use `-p` / `--templatePath` to specify a full path.

💡 You can use the `swiftgen templates` command to list all the available templates (both custom and bundled templates) for each subcommand, list the template content and dupliate them to create your own.

### Templates bundled with SwiftGen include:

* A `default` template, compatible with Swift 2
* A `swift3` template, compatible with Swift 3
* Other variants, like `structured` and `dot-syntax` / `dot-syntax-swift3` templates for Strings, or `osx` variant for ~~OS X~~ macOS Storyboards.

For more information about how to create your own templates, [see the dedicated documentation](documentation/Templates.md).

> Don't hesitate to make PRs to share your improvements suggestions on the default templates 😉

## Swift 3 support

As explained above, among other templates, Swift is bundled with a `swift3` template for each of its subcommands.

If you're using Swift 3, don't forget to use `-t swift3` in your invocation of `swiftgen` to tell SwiftGen to use those Swift 3 templates and generate Swift 3 compatible code.

## Playground

The `SwiftGen.playground` available in this repository will allow you to play with the code that the tool typically generates, and see some examples of how you can take advantage of it.

This allows you to have a quick look at how typical code generated by SwiftGen looks like, and how you will then use the generated enums in your code.

---

## UIImage and NSImage

```sh
swiftgen images /dir/to/search/for/imageset/assets
```

This will generate an `enum Asset` with one `case` per image asset in your assets catalog, so that you can use them as constants.

<details>
<summary>Example of **code generated by the default template**</summary>

```swift
// The Image type below is typealias'ed to UIImage on iOS and NSImage on OSX
enum Asset: String {
  case Green_Apple = "Green-Apple"
  case Red_Apple = "Red apple"
  case _2_Pears = "2-pears"

  var image: Image {
    return Image(asset: self)
  }
}

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
```
</details>

### Usage Example

```swift
let image1 = UIImage(asset: .Banana)   // iOS Prefered way
let image2 = NSImage(asset: .Banana)   // OS X Prefered way
let image3 = Asset.Apple.image // Alternate way
```

## Localizable.strings

```sh
swiftgen strings /path/to/Localizable.strings
```

This will generate a Swift `enum L10n` that will map all your `Localizable.strings` keys to an `enum case`. Additionaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`.

<details>
<summary>Example of **code generated by the default template**</summary>

Given the following `Localizable.strings` file:

```swift
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"greetings" = "Hello, my name is %@ and I'm %d";
"apples.count" = "You have %d apples";
"bananas.owner" = "Those %d bananas belong to %@.";
```

> _Reminder: Don't forget to end each line in your `*.strings` files with a semicolon `;`! Now that in Swift code we don't need semi-colons, it's easy to forget it's still required by the `Localizable.strings` file format 😉_

The generated code will contain this:

```swift
enum L10n {
  /// Title of the alert
  case AlertTitle
  /// Some alert body there
  case AlertMessage
  /// Hello, my name is %@ and I'm %d
  case Greetings(String, Int)
  /// You have %d apples
  case ApplesCount(Int)
  /// Those %d bananas belong to %@.
  case BananasOwner(Int, String)
}

extension L10n : CustomStringConvertible {
  var description : String { return self.string }

  var string : String {
    /* Implementation Details */
  }
  ...
}

func tr(key: L10n) -> String {
  return key.string
}
```
</details>

### Usage Example

Once the code has been generated by the script, you can use it this way in your Swift code:

```swift
let title = L10n.AlertTitle.string
// -> "Title of the Alert"

// Alternative syntax, shorter
let msg = tr(.AlertMessage)
// -> "Some alert body there"

// Strings with parameters
let nbApples = tr(.ApplesCount(5))
// -> "You have 5 apples"

// More parameters of various types!
let ban = tr(.BananasOwner(2, "John"))
// -> "Those 2 bananas belong to John."
```

### Automatically replace NSLocalizedString(...) calls

This [script](https://gist.github.com/Lutzifer/3e7d967f73e38b57d4355f23274f303d) from [Lutzifer](https://github.com/Lutzifer/) can be run inside the project to transform `NSLocalizedString(...)` calls to the `tr(...)` syntax.


### Dot Syntax Support

SwiftGen also has a template with dot syntax support. This is the recommended way of using the `strings` command in SwiftGen and will replace the current default in future versions.

The main advantage of this is a much more useful auto-completion. To use the template simply add the `-t` option, either using the template `dot-syntax` for Swift 2 or `dot-syntax-swift3` if you're using Swift 3:

```sh
# Swift 2 compatible template
swiftgen strings -t dot-syntax /path/to/Localizable.strings
# Swift 3 compatible template
swiftgen strings -t dot-syntax-swift3 /path/to/Localizable.strings
```

Given the same `Localizable.strings` as above the usage will now be:

```swift
let title = L10n.AlertTitle
// -> "Title of the Alert"

let nbApples = L10n.Apples.Count(5)
// -> "You have 5 apples"

let ban = L10n.Bananas.Owner(2, "John")
// -> "Those 2 bananas belong to John."
```

Note that all dots within the key are converted to dots in code.

The maximum number of dots supported is five (deeper levels are rendered without dots after the fifth level).


## UIStoryboard

```sh
swiftgen storyboards /dir/to/search/for/storyboards
```

This will generate an `enum` for each of your `UIStoryboard`, with one `case` per storyboard scene.

<details>
<summary>Example of **code generated by the default template**</summary>

The generated code will look like this:

```swift
protocol StoryboardSceneType {
    static var storyboardName : String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }

    static func initialViewController() -> UIViewController {
        return storyboard().instantiateInitialViewController()!
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType : RawRepresentable { }

extension UIViewController {
  func performSegue<S : StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum Message : String, StoryboardSceneType {
    static let storyboardName = "Message"

    case Composer = "Composer"
    static func composerViewController() -> UIViewController {
      return Message.Composer.viewController()
    }

    case URLChooser = "URLChooser"
    static func urlChooserViewController() -> XXPickerViewController {
      return Message.URLChooser.viewController() as! XXPickerViewController
    }
  }
  enum Wizard : String, StoryboardSceneType {
    static let storyboardName = "Wizard"

    case CreateAccount = "CreateAccount"
    static func createAccountViewController() -> CreateAccViewController {
        return Wizard.CreateAccount.viewController() as! CreateAccViewController
    }

    case ValidatePassword = "Validate_Password"
    static func validatePasswordViewController() -> UIViewController {
        return Wizard.ValidatePassword.viewController()
    }
  }
}

struct StoryboardSegue {
  enum Message : String, StoryboardSegueType {
    case Back = "Back"
    case Custom = "Custom"
    case NonCustom = "NonCustom"
  }
}
```
</details>

### Usage Example

```swift
// Initial VC
let initialVC = StoryboardScene.Wizard.initialViewController()
// Generic ViewController constructor, returns a UIViewController instance
let validateVC = StoryboardScene.Wizard.ValidatePassword.viewController()
// Dedicated type var that returns the right type of VC (CreateAccViewController here)
let createVC = StoryboardScene.Wizard.createAccountViewController()

override func prepareForSegue(_ segue: UIStoryboardSegue, sender sender: AnyObject?) {
  switch StoryboardSegue.Message(rawValue: segue.identifier)! {
  case .Back:
    // Prepare for your custom segue transition
  case .Custom:
    // Prepare for your custom segue transition
  case .NonCustom:
    // Prepare for your custom segue transition
  }
}

initialVC.performSegue(StoryboardSegue.Message.Back)
```

## NSStoryboard

```sh
swiftgen storyboards --template storyboards-osx-default /dir/to/search/for/storyboards
```

This will generate an `enum` for each of your `NSStoryboard`, with one `case` per storyboard scene.

<details>
<summary>Example of **code generated by the default template**</summary>

The generated code will look like this:

```swift
protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> NSStoryboard {
    return NSStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialController() -> AnyObject {
    guard let controller = storyboard().instantiateInitialController()
    else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return controller
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func controller() -> AnyObject {
    return Self.storyboard().instantiateControllerWithIdentifier(self.rawValue)
  }
  static func controller(identifier: Self) -> AnyObject {
    return identifier.controller()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension NSWindowController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

extension NSViewController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum Anonymous_Osx: StoryboardSceneType {
    static let storyboardName = "Anonymous-osx"
  }
  enum Message_Osx: String, StoryboardSceneType {
    static let storyboardName = "Message-osx"

    case MessagesTabScene = "MessagesTab"
    static func instantiateMessagesTab() -> CustomTabViewController {
      guard let vc = StoryboardScene.Message_Osx.MessagesTabScene.controller() as? CustomTabViewController
      else {
        fatalError("ViewController 'MessagesTab' is not of the expected class CustomTabViewController.")
      }
      return vc
    }

    case WindowCtrlScene = "WindowCtrl"
    static func instantiateWindowCtrl() -> NSWindowController {
      guard let vc = StoryboardScene.Message_Osx.WindowCtrlScene.controller() as? NSWindowController
      else {
        fatalError("ViewController 'WindowCtrl' is not of the expected class NSWindowController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
  enum Message_Osx: String, StoryboardSegueType {
    case Custom = "Custom"
    case Embed = "Embed"
  }
}
```
</details>

### Usage Example

```swift
// Initial VC
let initialVC = StoryboardScene.Message_Osx.initialController()
// Dedicated type var that returns the right type of VC (CustomTabViewController here)
let messageDetailsVC = StoryboardScene.Message_Osx.instantiateMessageTab()
override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
    switch StoryboardSegue.Message_Osx(rawValue: segue.identifier!) {
    case .Custom:
    // Prepare for your custom segue transition
    case .Embed:
        // Prepare for your embed segue transition
    }
}
initialVC.performSegue(StoryboardSegue.Message.Back)
```

## UIColor and NSColor

```sh
swiftgen colors /path/to/colors-file.txt
```

This will generate a `enum ColorName` with one `case` per color listed in the text file passed as argument.

The input file is expected to be either:

* a [plain text file](UnitTests/fixtures/colors.txt), with one line per color to register, each line being composed by the Name to give to the color, followed by ":", followed by the Hex representation of the color (like `rrggbb` or `rrggbbaa`, optionally prefixed by `#` or `0x`). Whitespaces are ignored.
* a [JSON file](UnitTests/fixtures/colors.json), representing a dictionary of names -> values, each value being the hex representation of the color
* a [XML file](UnitTests/fixtures/colors.xml), expected to be the same format as the Android colors.xml files, containing tags `<color name="AColorName">AColorHexRepresentation</color>`
* a [`*.clr` file](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DrawColor/Concepts/AboutColorLists.html#//apple_ref/doc/uid/20000757-BAJHJEDI) used by Apple's Color Paletes.

For example you can use this command to generate colors from one of your system color lists:

```sh
swiftgen colors ~/Library/Colors/MyColors.clr
```

Generated code will look the same as if you'd use text file.

<details>
<summary>Example of **code generated by the default template**</summary>

Given the following `colors.txt` file:

```
Cyan-Color       : 0xff66ccff
ArticleTitle     : #33fe66
ArticleBody      : 339666
ArticleFootnote  : ff66ccff
Translucent      : ffffffcc
```

The generated code will look like this:

```swift
// The Color type below is typealias'ed to UIColor on iOS and NSColor on OSX
extension Color {
  /* Private Implementation details */
  ...
}

enum ColorName {
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#339666"></span>
  /// Alpha: 100% <br/> (0x339666ff)
  case ArticleBody
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff66cc"></span>
  /// Alpha: 100% <br/> (0xff66ccff)
  case ArticleFootnote
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#33fe66"></span>
  /// Alpha: 100% <br/> (0x33fe66ff)
  case ArticleTitle
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff66cc"></span>
  /// Alpha: 100% <br/> (0xff66ccff)
  case Cyan_Color
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 80% <br/> (0xffffffcc)
  case Translucent
}

extension Color {
  convenience init(named name: ColorName) {
    self.init(rgbaValue: name.rgbaValue)
  }
}
```
</details>

### Usage Example

```swift
// iOS
UIColor(named: .ArticleBody)
UIColor(named: .ArticleFootnote)
UIColor(named: .ArticleTitle)
UIColor(named: .Cyan_Color)
UIColor(named: .Translucent)

// OS X
NSColor(named: .ArticleBody)
NSColor(named: .ArticleFootnote)
NSColor(named: .ArticleTitle)
NSColor(named: .Cyan_Color)
NSColor(named: .Translucent)
```

This way, no need to enter the color red, green, blue, alpha values each time and create ugly constants in the global namespace for them.


## UIFont and NSFont

```sh
swiftgen fonts /path/to/font/dir
```

This will recursively go through the specified directory, finding any typeface files (TTF, OTF, …), defining a `struct FontFamily` for each family, and an enum nested under that family that will represent the font styles.

<detals>
<summary>Example of **code generated by the default template**</summary>

```swift
// The Font type below is typealias'ed to UIFont on iOS and NSFont on OSX
struct FontFamily {
  enum Helvetica: String {
    case Regular = "Helvetica"
    case Bold = "Helvetica-Bold"
    case Thin = "Helvetica-Thin"
    case Medium = "Helvetica-Medium"

    func font(size: CGFloat) -> Font? { return Font(name:self.rawValue, size:size)}
  }
}
```
</details>

### Usage

```swift
// Helvetica Bold font of point size 16.0
let font = FontFamily.Helvetica.Bold.font(16.0)
// Another way to build the same font
let sameFont = UIFont(font: FontFamily.Helvetica.Bold, size: 16.0) // iOS
let sameFont = NSFont(font: FontFamily.Helvetica.Bold, size: 16.0) // OS X
```

---


# License

This code and tool is under the MIT License. See `LICENSE` file in this repository.

It also relies on [`Stencil`](https://github.com/kylef/Stencil/blob/master/LICENSE), [`Commander`](https://github.com/kylef/Commander/blob/master/LICENSE) and [`PathKit`](https://github.com/kylef/PathKit/blob/master/LICENSE) licenses.

Any ideas and contributions welcome!
