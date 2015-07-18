# SwiftGen

This is a suite of tools written in Swift to auto-generate Swift code for various assets of your project:

* [`enums` for your Assets Catalogs](#assets-catalogs)
* [`enums` for your `UIStoryboard` and their Scenes](#uistoryboard)
* [`enums` for your `UIColor`s](#uicolor).
* [`enums` for your `Localizable.strings` strings](#localizablestrings).

## Installation

### Build the tools from source

To build the executables from the source, **simply run `rake` from the command line**.

This will generate standalone executables into the `bin/` directory.

> Note: The tools are written in Swift 2.0 and need to be compiled with Xcode 7.
> 
> If your Xcode 7 is not the one set as default for use from the Command Line, you can use `sudo xcode-select -s` to change it. Alternatively, you can use `DEVELOPER_DIR=/Applications/Xcode-beta.app rake`.

### Using the binaries & play with the Playground

* The built tools will be located in `bin/`. Simply invoke them with the necessary arguments from the command line (see doc of each tool below).
* The `SwiftGen.playground` will allow you to play around with the various `EnumBuilders` classes used by the compiled tools and see some usage examples.

> Note: The playground is in the Xcode 7 format, and uses its new concept of "Playground pages" to regroup multiple playground pages in a single Playground.

To learn more on how the various source files used to build the tools are organized in the repository, see [Repository Organization & Rakefile Internals](#repository-organization--rakefile-internals) at the end of this README.

---

## Assets Catalogs

> `swiftgen-assets /dir/to/search/for/imageset/assets`

This tool will generate a `enum Asset` in an extension of `UIImage`, with one `case` per image asset in your assets catalog, so that you can use them as constants.

### Generated code

The generated code will look like this:

```
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

```
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

> `swiftgen-storyboard /dir/to/search/for/storyboards`

This tool generate an `enum` for each of your `UIStoryboard`, with one `case` per storyboard scene.

### Generated code

The generated code will look like this:

```
protocol StoryboardScene : RawRepresentable {
    static var storyboardName : String { get }
}

extension StoryboardScene where Self.RawValue == String {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }

    static func initialViewController() -> UIViewController {
        return storyboard().instantiateInitialViewController()!
    }

    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

enum Wizzard : String, StoryboardScene {
    static let storyboardName = "Wizzard"

    case CreateAccount = "CreateAccount"
    case AcceptCGU = "Accept-CGU"
    case ValidatePassword = "Validate_Password"
    case Preferences = "Preferences"

    static var createAccountViewController : CreateAccViewController {
      return Wizzard.CreateAccount.viewController() as! CreateAccViewController
    }
    static var acceptCGUViewController : UIViewController {
      return Wizzard.AcceptCGU.viewController()
    }
    static var validatePasswordViewController : PasswordValidationViewController {
      return Wizzard.ValidatePassword.viewController() as! PasswordValidationViewController
    }
    static var preferencesViewController : PrefsViewController {
      return Wizzard.Preferences.viewController() as! PrefsViewController
    }
}

enum Message : String, StoryboardScene {
    static let storyboardName = "Message"

    case Composer = "Composer"
    case Recipient = "Recipient"

    static var composerViewController : MessageComposerViewController {
      return Message.Composer.viewController() as! MessageComposerViewController
    }
    static var recipientViewController : RecipientChooserViewController {
      return Message.Recipient.viewController() as! RecipientChooserViewController
    }
}
```

### Usage Example

```
// Initial VC
let initialVC = Wizzard.initialViewController()
// Generic ViewController constructor, returns a UIViewController instance
let validateVC = Wizzard.ValidatePassword.viewController()
// Dedicated type var that returns the right type of VC (CreateAccViewController here)
let createVC = Wizzard.createAccountViewController
```


## UIColor

> `swiftgen-color /path/to/colors-file.txt`

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

```
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

```
UIColor(named: .ArticleTitle)
UIColor(named: .ArticleBody)
UIColor(named: .Translucent)
```

This way, no need to enter the color red, green, blue, alpha values each time and create ugly constants in the global namespace for them.


## Localizable.strings

> `swiftgen-l10n /path/to/Localizable.strings`

This tool generate a Swift `enum L10n` that will map all your `Localizable.strings` keys to an `enum case`. Additionnaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`.

### Generated code

Given the following `Localizable.strings` file:

```
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"greetings" = "Hello, my name is %@ and I'm %d";
"apples.count" = "You have %d apples";
"bananas.owner" = "Those %d bananas belong to %@.";
```

The generated code will contain this:

```
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

```
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

### Limitations

* Does only support `%@`, `%f`, `%d`, `%i` and `%u` format placeholders.
* Does not yet support positionable placeholders, like `%2$@`, etc (which change the order in which the parameters are parsed)
* We need to add some security during the parsing of placeholders
  * e.g. today `%x makes %g fail` will start parsing the placeholder from `%` and won't stop until it encounters one of `@fdiu` — the only types supported so far — which will only happen on `fail`, so it will consider `%x makes %g f` like it were `%f` altogether, skipping a parameter in the process…


---

# Repository Organization & Rakefile Internals

Here are some details on how the files are organized in that repo and how the Rakefile works.

* The source of the command-line scripts are located in `src/`
* The command-line scripts basically parse command-line arguments, then use the `SwiftGenXXXEnumBuilder` classes to generate the appropriate code, so their code is pretty simple as they are just wrappers around other builder classes
* The core elements of the project, which is the various `SwiftGenXXXEnumBuilder` classes and the `SwiftIdentifier` shared code used by these classes, are actually stored in `SwiftGen.playground/Sources`, so the playground can use those `SwiftGenXXXEnumBuilder` classes directly.

The `Rakefile` tasks are automatically constructed by filesystem parsing. For example, when running `rake`:

* The `src/` directory is parsed, and a rake task is created to build each target executable
* Dependencies on other sources for each script are automatically computed by scanning for `import` statements and comparing them with the sources in `SwiftGen.playground/Sources/`
* Potential transitive dependencies for libs (like `SwiftGenAssetsEnumBuilder` depending itself on `SwiftIdentifier`) are also automatically detected by scanning for `//@import` comment lines I added in the lib sources (that's an entirely personal convention)
* As a result, `rake` is able to build each script into a standalone tool by determining all by itself all the files needed to build the binary

> Note: You can see which `.swift` files are used when building each too by using the verbose mode of rake: `rake --verbose`.

Additionally, even if it's not the recommended mode, the `Rakefile` allows you to build _dependant_ binaries too. In this mode:

* It starts by creating a rake task `lib:XXX` for each files in `SwiftGen.playground/Sources` that will compile them as dynamic libraries into `./lib/libXXX.dylib`
* Then it adds rake tasks `bin:XXX` that compiles the scripts located in `src/XXX` into `bin/XXX`, but as executables **linked against those dynamic libraries** previously generated.
* Dependencies are also automagically computed when using this mode, with similar techniques as described above, so that executables are only linked against the appropriate dynamic libraries in `lib/`

> The drawback of this mode is that the executables are being linked against libs at path `./lib/libXXX`, which means that it needs those dynamic libs to always be located at that path (relative to the working dir) for the binary to even be launchable. This means that you will only be able to call `bin/swiftgen-assets` from this repository working directory, and not from anywhere else.
> 
> This mode still exists anyway, because it was the first mode I implemented when creating that Rakefile, and because it's still interesting as an exercice to know how to build dylibs and modules (and because it may evolve someday to build a reusable framework maybe?).

# Licence

This code will be released under the MIT Licence.

Any ideas and contributions welcome!
