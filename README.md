# SwiftGen

[![CI Status](http://img.shields.io/travis/AliSoftware/SwiftGen.svg?style=flat)](https://travis-ci.org/AliSoftware/SwiftGen)

This is a suite of tools written in Swift 2 to auto-generate Swift 2 code for various assets of your project:

* [`enums` for your Assets Catalogs](#uiimage)
* [`enums` for your `Localizable.strings` strings](#localizablestrings).
* [`enums` for your `UIStoryboard` and their Scenes](#uistoryboard)
* [`enums` for your `UIColor`s](#uicolor).

## Installation

> Note: The tools are written in Swift 2.0 and need to be compiled with the latest Xcode 7.  

### Via Homebrew

To install SwiftGen via [Homebrew](http://brew.sh), simply use:

```sh
$ brew update
$ brew install swiftgen
```

### Compile from source

Alternatively, you can clone the repository and use `rake install` to build the tool.  
_With this solution you're sure to build and install the latest version from `master`._

To install to the default locations:

```sh
# Binary is installed in `./swiftgen/bin`, frameworks in `./swiftgen/lib` and templates in `./swiftgen/templates`
$ rake install
```

To install to a custom locations:

```sh
# Binary will be installed in `~/swiftgen/bin`, framworks in `~/swiftgen/fmk` and templates in `~/swiftgen/tpl`
$ rake install[~/swiftgen/bin,~/swiftgen/fmk,~/swiftgen/tpl]
```

You can also choose not to copy the Swift runtime libraries and use the ones bundled in `Xcode.app` instead. This saves ~5Mo but makes you depend on `Xcode.app`, which means that you mustn't move or rename your `Xcode.app` later (that's why I don't recommend this solution):

```sh
$ rake install:light
# or e.g. `rake install:light[~/bin,~/lib,~/swiftgen/templates]` to install in specific locations
```

## Usage

The tool is now a unique `swiftgen` binary command-line with subcommands:

* `swiftgen images [OPTIONS] DIR`
* `swiftgen strings [OPTIONS] FILE`
* `swiftgen storyboards [OPTIONS] DIR`
* `swiftgen colors [OPTIONS] FILE`

Each subcommand may have its own option and syntax, but here are some common options:

* `--output FILE`: set the file where to write the generated code. If omitted, the generated code will be printed on `stdout`.
* `--template PATH`: define the Stencil template to use to generate the output.

You can use `--help` on `swiftgen` or one of its subcommand to see the detailed usage.

## Playground

The `SwiftGen.playground` available in this repository will allow you to play with the code that the tools typically generates, and see some examples of how you can take advantage of it.

This allows you to have a quick look at how typical code generated by SwiftGen looks like, and how you will then use the generated enums in your code.

> Note: The playground is in the Xcode 7 format, and uses its new concept of "Playground pages" to regroup multiple playground pages in a single Playground.

## Custom Templates

SwiftGen uses [Stencil](https://github.com/kylef/Stencil) as its template engine.

This means that you can create your own templates for the generated code, if the defaults one don't suit you. Then, simply use the `--template` option of `swiftgen` to define which template to use instead of the default one.

> Don't hesitate to make PRs share your improvements suggestions on the default templates 😉

---

## UIImage

```
swiftgen images /dir/to/search/for/imageset/assets
```

This will generate an `enum Asset` in an extension of `UIImage`, with one `case` per image asset in your assets catalog, so that you can use them as constants.

### Generated code

The generated code will look like this:

```swift
extension UIImage {
  enum Asset : String {
    case GreenApple = "Green-Apple"
    case RedApple = "Red-Apple"
    case Banana = "Banana"
    case BigPear = "Big_Pear"
    case StopButtonEnabled = "stop.button.enabled"

    static let allValues = [GreenApple, RedApple, Banana, BigPear, StopButtonEnabled, ]
    
    var image: UIImage {
      return UIImage(named: self.rawValue)!
    }
  }
      
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
```

### Usage Example

```swift
let image1 = UIImage(asset: .Banana)   // Prefered way
let image2 = UIImage.Asset.Apple.image // Alternate way
```

This way, no need to enter the `"Banana"` string in your code and risk any typo.


If you want to loop over all your assets:

```swift
UIImage.Asset.allValues.forEach { asset in
    print(asset.rawValue)
}
```


### Benefits & Limitations

There are multiple benefits in using this:

* Avoid any typo you could have when using a String
* Free auto-completion
* Avoid the risk to use an non-existing asset name
* All this will be ensured by the compiler.

Note that this script only generate extensions and code compatible with `UIKit` and `UIImage`. It would be nice to have an option to generate OSX code in the future.


## Localizable.strings

```
swiftgen strings /path/to/Localizable.strings
```

This will generate a Swift `enum L10n` that will map all your `Localizable.strings` keys to an `enum case`. Additionaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`.

### Generated code

Given the following `Localizable.strings` file:

```swift
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"greetings" = "Hello, my name is %@ and I'm %d";
"apples.count" = "You have %d apples";
"bananas.owner" = "Those %d bananas belong to %@.";
```

The generated code will contain this:

```swift
enum L10n {
  case AlertTitle
  case AlertMessage
  case Greetings(String, Int)
  case ApplesCount(Int)
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

### Usage Example

Once the code has been generated by the script, you can use it this way in your Swift code:

```swift
let title = L10n.AlertTitle.string
// -> "Title of the Alert"

// Alternative syntax, shorter
let msg = tr(.AlertMessage)
// -> "Body of the Alert"

// Strings with parameters
let nbApples = tr(.ApplesCount(5))
// -> "You have 5 apples"

// More parameters of various types!
let ban = tr(.BananasOwner(2, "John"))
// -> "Those 2 bananas belong to John."
```

## UIStoryboard

```
swiftgen storyboards /dir/to/search/for/storyboards
```

This will generate an `enum` for each of your `UIStoryboard`, with one `case` per storyboard scene.

### Generated code

The generated code will look like this:

```swift
protocol StoryboardScene : RawRepresentable {
  static var storyboardName : String { get }
  static func storyboard() -> UIStoryboard
  static func initialViewController() -> UIViewController
  func viewController() -> UIViewController
  static func viewController(identifier: Self) -> UIViewController
}

extension StoryboardScene where Self.RawValue == String {
  /* Implementation details */
}

extension UIStoryboard {
  struct Scene {
    enum Message : String, StoryboardScene {
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
    enum Wizard : String, StoryboardScene {
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

  struct Segue {
    enum Message : String {
      case Back = "Back"
      case Custom = "Custom"
      case NonCustom = "NonCustom"
    }
  }
}
```

### Usage Example

```swift
// Initial VC
let initialVC = UIStoryboard.Scene.Wizard.initialViewController()
// Generic ViewController constructor, returns a UIViewController instance
let validateVC = UIStoryboard.Scene.Wizard.ValidatePassword.viewController()
// Dedicated type var that returns the right type of VC (CreateAccViewController here)
let createVC = UIStoryboard.Scene.Wizard.createAccountViewController()

override func prepareForSegue(_ segue: UIStoryboardSegue, sender sender: AnyObject?) {
  switch UIStoryboard.Segue.Message(rawValue: segue.identifier)! {
  case .Back:
    // Prepare for your custom segue transition
  case .Custom:
    // Prepare for your custom segue transition
  case .NonCustom:
    // Prepare for your custom segue transition
  }
}
```


## UIColor

```
swiftgen colors /path/to/colors-file.txt
```

This will generate a `enum Name` in an extension of `UIColor`, with one `case` per color listed in the text file passed as argument.

The text file is expected to have one line per color to register, each line being composed by the Name to give to the color, followed by ":", followed by the Hex representation of the color (like `rrggbb` or `rrggbbaa`, optionally prefixed by `#` or `0x`). Whitespaces are ignored.

### Generated code

Given the following `colors.txt` file:

```
Cyan         : 0xff66ccff
ArticleTitle : #33fe66
ArticleBody  : 339666
Translucent  : ffffffcc
```

The generated code will look like this:

```swift
extension UIColor {
  /* Private Implementation details */
  ...
}

extension UIColor {
  enum Name : UInt32 {
    case Translucent = 0xffffffcc
    case ArticleBody = 0x339666ff
    case Cyan = 0xff66ccff
    case ArticleTitle = 0x33fe66ff
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rawValue)
  }
}
```

### Usage Example

```swift
UIColor(named: .ArticleTitle)
UIColor(named: .ArticleBody)
UIColor(named: .Translucent)
```

This way, no need to enter the color red, green, blue, alpha values each time and create ugly constants in the global namespace for them.


---


# License

This code and tool is under the MIT License. See `LICENSE` file in this repository.

It also relies on [`Stencil`](https://github.com/kylef/Stencil/blob/master/LICENSE), [`Commander`](https://github.com/kylef/Commander/blob/master/LICENSE) and [`PathKit`](https://github.com/kylef/PathKit/blob/master/LICENSE) licenses.

Any ideas and contributions welcome!
