# SwiftGen

This is a suite of tools written in Swift to auto-generate Swift code for various assets of your project:

* [`enums` for your Assets Catalogs](#assets-catalogs)
* [`enums` for your `UIStoryboard` and their Scenes](#uistoryboard)
* [`enums` for your `Localizable.strings` strings](#localizablestrings).
* And maybe more to come…

## Installation & Repo Organization

### Build the tools from source

To build the executables from the source, **simply run `rake` from the command line**.

This will generate the local libraries (code shared between the various tools) in `lib/` and the executables in `bin/`.

> Note: The tools are written in Swift 2.0 and need to be compiled with Xcode 7.
> 
> If your Xcode 7 is not the one set as default for use from the Command Line, you can use `sudo xcode-select -s` to change it. Alternatively, you can use `DEVELOPER_DIR=/Applications/Xcode-beta.app rake`.

### Using the binaries

* The built tools will be located in `bin/`. Simply invoke them with the necessary arguments from the command line (see doc of each tool below).
* The `SwiftGen.playground` will allow you to play around with the various EnumFactories Swift libs used by the compiled scripts and see some usage examples.

### Repository Organisation

* The source of the command-line scripts are located in `src/`
* The command-line scripts basically parse command-line arguments, then use the `SwiftGenXXXFactory` classes to generate the appropriate code
* The various `SwiftGenXXXFactory` classes and shared code used by these scripts are stored in `SwiftGen.playground/Sources`. This way, the playground can also use those factories directly

When running `rake`:

* The `SwiftGen.playground/Sources` directory is parsed
* Dependencies are automatically computed for each file
* `rake` compiles each of those files as a library and its associated module into `lib/`
* Then the `src/` directory is parsed, computing local lib dependencies needed for each
* And finally `rake` compiles each of these file in `src` and link them with the libraries generated in `lib/` to produce the final executables in `bin/`..

## Assets Catalogs

> `swiftgen-assets /dir/to/search/for/imageset/assets`

This tool will generate a `enum ImageAsset` with one `case` per image asset in your catalog, so that you can use them as constants. For example:

```
enum ImageAsset : String {
    case Apple = "apple"
    case Banana = "banana"
    case Pear = "pear"
    case GrannySmith = "granny-smith"
	
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
```

It also adds an `extension` on `UIImage` so you can build an `UIImage` both ways:

```
let image1 = ImageAsset.Apple.image
let image2 = UIImage(asset: .Banana)
```

This way, no need to enter the `"Banana"` string in your code and risk any typo.

### Benefits

* avoid any typo you could have when using a String
* free auto-completion
* avoid the risk to use an non-existing asset name
* all this will be ensured by the compiler.

### Limitations

This script only generate extensions and code compatible with `UIKit` and `UIImage`. It would be nice to have an option to generate OSX code some day.

## UIStoryboard

> `swiftgen-storyboard` _(WIP, Only in Storyboard for now)_

This tool generate an `enum` for each of your `UIStoryboard`, with one `case` per storyboard scene.

### Generated code

The generated code will look like this:

```
import Foundation
import UIKit

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

    static var createAccountViewController : CreateAccViewController { return Wizzard.CreateAccount.viewController() as! CreateAccViewController }
    static var acceptCGUViewController : UIViewController { return Wizzard.AcceptCGU.viewController() }
    static var validatePasswordViewController : UIViewController { return Wizzard.ValidatePassword.viewController() }
    static var preferencesViewController : UIViewController { return Wizzard.Preferences.viewController() }
}

enum Message : String, StoryboardScene {
    static let storyboardName = "Message"

    case Composer = "Composer"
    case Recipient = "Recipient"

    static var composerViewController : UIViewController { return Message.Composer.viewController() }
    static var recipientViewController : UIViewController { return Message.Recipient.viewController() }
}
```

### Usage

```
// Initial VC
let initialVC = Wizzard.initialViewController()
// Generic ViewController constructor, returns a UIViewController instance
let validateVC = Wizzard.ValidatePassword.viewController()
// Dedicated type var that returns the right type of VC (CreateAccViewController here)
let createVC = Wizzard.createAccountViewController
```

## Localizable.strings

> Associated script: `SwiftGen.playground/swiftgen)l10n` _(work in progress, not converted to a CLI script yet)_

This script will generate a Swift `enum L10n` that will map all your `Localizable.strings` keys to an `enum case`. Additionnaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`.

### Generated code

Given this `Localizable.strings` file:

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

### Usage

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

### Work in progress

This script is almost ready, but is still in the form of a Playground (not converted to a standalone CLI tool yet) so I can continue playing around and test it.

This is an early stage sample, for now only tested in a Playground. Next steps include:

* Transforming it into a stand-alone Swift script, runnable from the Command Line and that will take the input file as parameter
* Support more format placeholders, like `%x`, `%g`, etc
* Support positionable placeholders, like `%2$@`, etc (which change the order in which the parameters are parsed)
* Add some security during the parsing of placeholders, to avoid parsing too far in case we have an `%` that is not terminated by a known format type character
  * e.g. today `%x makes %g fail` will start parsing the placeholder from `%` and won't stop until it encounters `@`, `f` or `d` — the only types supported so far — which will only happen on `fail`, so it will consider `%x makes %g f` like it were `%f` altogether, skipping a parameter in the process.


---

# Licence

This code will be released under the MIT Licence.

Any ideas and contributions welcome!
