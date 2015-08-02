# SwiftGen

This is a suite of tools written in Swift to auto-generate Swift code for various assets of your project:

* [`enums` for your Assets Catalogs](#assets-catalogs)
* [`enums` for your `UIStoryboard` and their Scenes](#uistoryboard)
* [`enums` for your `UIColor`s](#uicolor).
* [`enums` for your `Localizable.strings` strings](#localizablestrings).

## Installation

### Build and install the tools from source

* To build the executables from the source, **simply use `rake` from the command line**.

```sh
# To build and install all the SwiftGen executables in ./bin
$ rake all

# To build and install the executables in ./exec rather than in ./bin
$ rake all[.,/exec]

# To install the executables in /usr/local/bin
# (similar to all[/usr/local,/bin])
$ rake install
```

> Note: The tools are written in Swift 2.0 and need to be compiled with Xcode 7.  
> The Rakefile will automatically find the copy of Xcode 7.x installed on your Mac (thanks to Spotlight and `mdfind`) and use it to compile the tools — even if Xcode 7 is not the version selected for use in the command line by `xcode-select`

### Using the binaries & play with the Playground

* Once the tool has been generated, simply invoke them with the necessary arguments from the command line (see doc of each tool below). Invoking them without any argument will print a very basic usage help and the tool version.
* Each tool generates the code to `stdout`, so you'll probably use a shell redirection to write that to a file (e.g. `swiftgen-assets /path/to/Images.xcassets >Assets.swift`)
* The `SwiftGen.playground` will allow you to play with the code that the tools typically generates and see some examples of how you can take advantage of it.

> Note: The playground is in the Xcode 7 format, and uses its new concept of "Playground pages" to regroup multiple playground pages in a single Playground.

---

## Assets Catalogs

```
swiftgen-assets /dir/to/search/for/imageset/assets
```

This tool will generate an `enum Asset` in an extension of `UIImage`, with one `case` per image asset in your assets catalog, so that you can use them as constants.

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
        
        var image: UIImage {
            return UIImage(named: self.rawValue)!
        }
    }
    
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
```

### Usage Example

```swift
let image1 = UIImage.Asset.Apple.image
let image2 = UIImage(asset: .Banana)!
```

This way, no need to enter the `"Banana"` string in your code and risk any typo.

### Benefits & Limitations

There are multiple benefits in using this:

* Avoid any typo you could have when using a String
* Free auto-completion
* Avoid the risk to use an non-existing asset name
* All this will be ensured by the compiler.

Note that this script only generate extensions and code compatible with `UIKit` and `UIImage`. It would be nice to have an option to generate OSX code in the future.


## UIStoryboard

```
swiftgen-storyboard /dir/to/search/for/storyboards
```

This tool generate an `enum` for each of your `UIStoryboard`, with one `case` per storyboard scene.

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
        enum Wizzard : String, StoryboardScene {
            static let storyboardName = "Wizzard"

            case CreateAccount = "CreateAccount"
            static func createAccountViewController() -> CreateAccViewController {
                return Wizzard.CreateAccount.viewController() as! CreateAccViewController
            }

            case ValidatePassword = "Validate_Password"
            static func validatePasswordViewController() -> UIViewController {
                return Wizzard.ValidatePassword.viewController()
            }
        }
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
    }

    struct Segue {
        enum Message : String {
            case Custom = "Custom"
            case Back = "Back"
            case NonCustom = "NonCustom"
        }
    }
}
```

### Usage Example

```swift
// Initial VC
let initialVC = UIStoryboard.Scene.Wizzard.initialViewController()
// Generic ViewController constructor, returns a UIViewController instance
let validateVC = UIStoryboard.Scene.Wizzard.ValidatePassword.viewController()
// Dedicated type var that returns the right type of VC (CreateAccViewController here)
let createVC = UIStoryboard.Scene.Wizzard.createAccountViewController()
```


## UIColor

```
swiftgen-color /path/to/colors-file.txt
```

This tool will generate a `enum Name` in an extension of `UIColor`, with one `case` per color listed in the text file passed as argument.

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


## Localizable.strings

```
swiftgen-l10n /path/to/Localizable.strings
```

This tool generate a Swift `enum L10n` that will map all your `Localizable.strings` keys to an `enum case`. Additionaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`.

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

---


# Licence

This code is under the MIT Licence.

Any ideas and contributions welcome!
