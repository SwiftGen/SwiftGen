# SwiftGen

[![CircleCI](https://circleci.com/gh/SwiftGen/SwiftGen/tree/master.svg?style=svg)](https://circleci.com/gh/SwiftGen/SwiftGen/tree/master)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftGen.svg)](https://img.shields.io/cocoapods/v/SwiftGen.svg)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGen.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGen)

SwiftGen is a tool to auto-generate Swift code for resources of your projects, to make them type-safe to use.

<table border="0"><tr>
  <td>
    <img alt="SwiftGen Logo" src="https://github.com/SwiftGen/Eve/raw/master/logo/logo-256.png" />
  </td><td>
    <ul>
        <li><a href="#installation">Installation</a>
        <li><a href="#usage">Usage</a>
        <li><a href="#choosing-your-template">Choosing your template</a>
        <li><a href="#additional-documentation">Additional documentation</a>
    </ul>
    Then generate code (enums, constants, etc) for:
    <ul>
      <li><a href="#asset-catalog">Assets Catalogs</a>
      <li><a href="#colors">Colors</a>
      <li><a href="#fonts">Fonts</a>
      <li><a href="#storyboards">Storyboards and their Scenes</a>
      <li><a href="#strings"><tt>Localizable.strings</tt></a>
    </ul>
  </td>
</tr></table>

<span style="float:none" />

There are multiple benefits in using this:

* Avoid any typo you could have when using a String
* Free auto-completion
* Avoid the risk to use an non-existing asset name
* All this will be ensured by the compiler.

Also, it's fully customizable thanks to Stencil templates, so even if it comes with predefined templates, you can make your own to generate whatever code fits your needs and your guidelines!

## Installation

There are multiple possibilities to install SwiftGen on your machine or in your project, depending on your preferences and needs:

<details>
<summary><strong>Download the ZIP</strong> for the latest release</summary>

* [Go to the GitHub page for the latest release](https://github.com/SwiftGen/SwiftGen/releases/latest)
* Download the `swiftgen-x.y.z.zip` file associated with that release
* Extract the content of the zip archive in your project directory

We recommend that you **unarchive the ZIP inside your project directory** and **commit its content** to git. This way, **all coworkers will use the same version of SwiftGen for this project**.

If you unarchived the ZIP file in a folder e.g. called `swiftgen` at the root of your project directory, you can then invoke SwiftGen in your Script Build Phase using:

```sh
"$PROJECT_DIR"/swiftgen/bin/swiftgen …
```

---
</details>
<details>
<summary>Via <strong>CocoaPods</strong></summary>

If you're using CocoaPods, you can simply add `pod 'SwiftGen'` to your `Podfile`.

This will download the `SwiftGen` binaries and dependencies in `Pods/` during your next `pod install` execution.

Given that you can specify an exact version for `SwiftGen` in your `Podfile`, this allows you to ensure **all coworkers will use the same version of SwiftGen for this project**.

You can then invoke SwiftGen in your Script Build Phase using:

```sh
$PODS_ROOT/SwiftGen/bin/swiftgen …
```

_Note: SwiftGen isn't really a pod, as it's not a library your code will depend on at runtime; so the installation via CocoaPods is just a trick that installs the SwiftGen binaries in the Pods/ folder, but you won't see any swift files in the Pods/SwiftGen group in your Xcode's Pods.xcodeproj. That's normal: the SwiftGen binary is still present in that folder in the Finder._

---
</details>
<details>
<summary>Via <strong>Homebrew</strong> <em>(system-wide installation)</em></summary>

To install SwiftGen via [Homebrew](http://brew.sh), simply use:

```sh
$ brew update
$ brew install swiftgen
```

This will install SwiftGen **system-wide**. The same version of SwiftGen will be used for all projects on that machine, and you should make sure all your coworkers have the same version of SwiftGen installed on their machine too.

You can then invoke `swiftgen` directly in your Script Build Phase (as it will be in your `$PATH` already):

```sh
swiftgen … 
```

_Note: SwiftGen needs Xcode 8.3 to build, so installing via Homebrew requires you to have Xcode 8.3 installed (which in turn requires macOS 10.12). If you use an earlier version of macOS, you'll have to use one of the other installation methods instead._

---
</details>
<details>
<summary><strong>Compile from source</strong> <em>(only recommended if you need features from master or want to test a PR)</em></summary>

This solution is when you want to build and install the latest version from `master` and have access to features which might not have been released yet.

* If you have `homebrew` installed, you can use the following command to build and install the latest commit:

```sh
brew install swiftgen --HEAD
```

* Alternatively, you can clone the repository and use `rake cli:install` to build the tool and install it from any branch, which could be useful to test SwiftGen in a fork or a Pull Request branch.

You can install to the default locations (no parameter) or to custom locations:

```sh
# Binary is installed in `./swiftgen/bin`, frameworks in `./swiftgen/lib` and templates in `./swiftgen/templates`
$ rake cli:install
# - OR -
# Binary will be installed in `~/swiftgen/bin`, frameworks in `~/swiftgen/fmk` and templates in `~/swiftgen/tpl`
$ rake cli:install[~/swiftgen/bin,~/swiftgen/fmk,~/swiftgen/tpl]
```

You can then invoke SwiftGen using the path to the binary where you installed it:

```sh
~/swiftgen/bin/swiftgen …
```

Or add the path to the `bin` folder to your `$PATH` and invoke `swiftgen` directly.

---
</details>

## Usage

> ❗️ If you're migrating from SwiftGen 4.x to SwiftGen 5.x, don't forget to [read the Migration Guide](https://github.com/SwiftGen/SwiftGen/blob/master/Documentation/MigrationGuide.md#swiftgen-50-migration-guide).

The tool is provided as a unique `swiftgen` binary command-line, with the following subcommands available to parse various resource types:

* `swiftgen colors [OPTIONS] FILE1 …`
* `swiftgen fonts [OPTIONS] DIR1 …`
* `swiftgen storyboards [OPTIONS] DIR1 …`
* `swiftgen strings [OPTIONS] FILE1 …`
* `swiftgen xcassets [OPTIONS] CATALOG1 …`

Each subcommand has its own option and syntax, but some options are common to all:

* `--output FILE` or `-o FILE`: set the file where to write the generated code. If omitted, the generated code will be printed on `stdout`.
* `--template NAME` or `-t NAME`: define the Stencil template to use (by name, see [here for more info](https://github.com/SwiftGen/templates)) to generate the output.
* `--templatePath PATH` or `-p PATH`: define the Stencil template to use, using a full path.
* Note: you should specify one and only one template when invoking SwiftGen. You have to use either `-t` or `-p` but should not use both at the same time (it wouldn't make sense anyway and you'll get an error if you try)
* Each command supports multiple input files (or directories where applicable).

There are also more subcommands not related to generate code but more oriented for help and configuration, namely:

* The `swiftgen templates` subcommands helps you print, duplicate, find and manage templates (both bundled and custom)
* The `swiftgen config` subcommands helps you manage configuration files (see below)
* You can use `--help` on `swiftgen` or one of its subcommand to see the detailed usage.

### Using a configuration file

Instead of having to invoke SwiftGen manually for each type or resource you want to generate code for, each time with the proper list of arguments, it's easier to use a configuration file.

Simply create a `swiftgen.yml` YAML file to list all the subcommands to invoke, and for each subcommand, the list of arguments to pass to it. For example:

```yaml
strings:
  paths: Resources/Base.lproj/Localizable.strings
  templateName: structured-swift3
  output: Generated/strings.swift
xcassets:
  paths:
   - Resources/Images.xcassets
   - Resources/MoreImages.xcassets
  templateName: swift3
  output: Generated/assets-images.swift
```

Then you just have to invoke `swiftgen config run`, or even just `swiftgen` for short, and it will execute what's described in the configuration file

To learn more about the configuration file — its more detailed syntax and possiblities, how to pass custom parameters, using `swiftgen config lint` to validate it, how to use alternate config files, and other tips — [see the dedicated documentation](Documentation/ConfigFile.md).

## Choosing your template

SwiftGen is based on templates (it uses [Stencil](https://github.com/kylef/Stencil) as its template engine). This means that **you can choose the template that fits the Swift version you're using** — and also the one that best fits your preferences — to **adapt the generated code to your own conventions and Swift version**.

### Bundled templates vs. Custom ones

SwiftGen comes bundled with some templates for each of the subcommand (`colors`, `fonts`, `storyboards`, `strings`, `xcassets`), which will fit most needs. But you can also create your own templates if the bundled ones don't suit your coding conventions or needs. Simply either use the `-t` / `--template` option to specify the name of the template to use, or store them somewhere else (like in your project repository) and use `-p` / `--templatePath` to specify a full path.

💡 You can use the `swiftgen templates list` command to list all the available templates (both custom and bundled templates) for each subcommand, list the template content and dupliate them to create your own.

For more information about how to create your own templates, [see the dedicated documentation](https://github.com/SwiftGen/templates/blob/master/Documentation/Creating-your-templates.md).

### Templates bundled with SwiftGen:

As explained above, you can use `swiftgen templates list` to list all templates bundled with SwiftGen. For most SwiftGen subcommands, we provide, among others:

* A `swift2` template, compatible with Swift 2
* A `swift3` template, compatible with Swift 3
* A `swift4` template, compatible with Swift 4
* Other variants, like `flat-swift2/3/4` and `structured-swift2/3/4` templates for Strings, etc.

You can **find the documentation for each bundled template [here in the repo](https://github.com/SwiftGen/templates/tree/master/Documentation)**, with documentation organized as one folder per SwiftGen subcommand, then one MarkDown file per template.  
Each MarkDown file documents the Swift Version it's aimed for, the use case for that template (in which cases you might favor that template over others), the available `--param` parameters to customize it on invocation, and some code examples.

> Don't hesitate to make PRs to share your improvements suggestions on the bundled templates 😉

## Additional documentation

### Playground

The `SwiftGen.playground` available in this repository will allow you to play with the code that the tool typically generates, and see some examples of how you can take advantage of it.

This allows you to have a quick look at how typical code generated by SwiftGen looks like, and how you will then use the generated constants in your code.

### Markdown files

There are also a lot of documentation in the form of Markdown files in this repository and the related [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) repo as well. Be sure to check the "Documentation" folder of each repository.

### Wiki

You can also see in the [wiki](https://github.com/SwiftGen/SwiftGen/wiki) some additional documentation, about:

* how to [integrate SwiftGen in your Continuous Integration](https://github.com/SwiftGen/SwiftGen/wiki/Continuous-Integration) (Travis-CI, CircleCI, Jenkins, …)
* how to [integrate in your Xcode project](https://github.com/SwiftGen/SwiftGen/wiki/Integrate-SwiftGen-in-an-xcodeproj) so it rebuild the constants every time you build
* …and more.

### Tutorials

You can also find other help & tutorial material on the internet, like [this classroom about Code Generation I gave at FrenchKit in Sept'17](https://github.com/FrenchKit/Mastering-code-generation-Classroom) — and its wiki detailing a step-by-step tutorial about installingn and using SwiftGen (and Sourcery too)

---

## Asset Catalog

```sh
swiftgen xcassets -t swift3 /dir/to/search/for/imageset/assets
```

This will generate an `enum Asset` with one `case` per image set in your assets catalog, so that you can use them as constants.

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
enum Asset {
  enum Exotic {
    static let banana: AssetType = "Exotic/Banana"
    static let mango: AssetType = "Exotic/Mango"
  }
  static let `private`: AssetType = "private"
}

```
</details>

### Usage Example

```swift
// You can create new images with the convenience constructor like this:
let bananaImage = UIImage(asset: Asset.Exotic.banana)  // iOS
let privateImage = NSImage(asset: Asset.private)  // macOS

// Or as an alternative, you can refer to enum instance and call .image on it:
let sameBananaImage = Asset.Exotic.banana.image
let samePrivateImage = Asset.private.image
```

## Colors

```sh
swiftgen colors -t swift3 /path/to/colors-file.txt
```

This will generate a `enum ColorName` with one `case` per color listed in the text file passed as argument.

The input file is expected to be either:

* a [plain text file](https://github.com/SwiftGen/templates/blob/master/Fixtures/Colors/colors.txt), with one line per color to register, each line being composed by the Name to give to the color, followed by ":", followed by the Hex representation of the color (like `rrggbb` or `rrggbbaa`, optionally prefixed by `#` or `0x`). Whitespaces are ignored.
* a [JSON file](https://github.com/SwiftGen/templates/blob/master/Fixtures/Colors/colors.json), representing a dictionary of names -> values, each value being the hex representation of the color
* a [XML file](https://github.com/SwiftGen/templates/blob/master/Fixtures/Colors/colors.xml), expected to be the same format as the Android colors.xml files, containing tags `<color name="AColorName">AColorHexRepresentation</color>`
* a [`*.clr` file](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DrawColor/Concepts/AboutColorLists.html#//apple_ref/doc/uid/20000757-BAJHJEDI) used by Apple's Color Paletes.

For example you can use this command to generate colors from one of your system color lists:

```sh
swiftgen colors -swift3 ~/Library/Colors/MyColors.clr
```

Generated code will look the same as if you'd use text file.

<details>
<summary>Example of code generated by the bundled template</summary>

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
struct ColorName {
  let rgbaValue: UInt32
  var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#339666"></span>
  /// Alpha: 100% <br/> (0x339666ff)
  static let articleBody = ColorName(rgbaValue: 0x339666ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff66cc"></span>
  /// Alpha: 100% <br/> (0xff66ccff)
  static let articleFootnote = ColorName(rgbaValue: 0xff66ccff)

  ...
}
```
</details>

### Usage Example

```swift
// You can create colors with the convenience constructor like this:
let title = UIColor(named: .articleBody)  // iOS
let footnote = NSColor(named: .articleFootnote) // macOS

// Or as an alternative, you can refer to enum instance and call .color on it:
let sameTitle = ColorName.articleBody.color
let sameFootnote = ColorName.articleFootnote.color
```

This way, no need to enter the color red, green, blue, alpha values each time and create ugly constants in the global namespace for them.

## Fonts

```sh
swiftgen fonts -t swift3 /path/to/font/dir
```

This will recursively go through the specified directory, finding any typeface files (TTF, OTF, …), defining a `struct FontFamily` for each family, and an enum nested under that family that will represent the font styles.

<detals>
<summary>Example of code generated by the bundled template</summary>

```swift
enum FontFamily {
  enum SFNSDisplay: String, FontConvertible {
    static let regular = FontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  enum ZapfDingbats: String, FontConvertible {
    static let regular = FontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
}
```
</details>

### Usage

```swift
// You can create fonts with the convenience constructor like this:
let displayRegular = UIFont(font: FontFamily.SFNSDisplay.regular, size: 20.0) // iOS
let dingbats = NSFont(font: FontFamily.ZapfDingbats.regular, size: 20.0)  // macOS

// Or as an alternative, you can refer to enum instance and call .font on it:
let sameDisplayRegular = FontFamily.SFNSDisplay.regular.font(size: 20.0)
let sameDingbats = FontFamily.ZapfDingbats.regular.font(size: 20.0)
```

## Storyboards

```sh
swiftgen storyboards -t swift3 /dir/to/search/for/storyboards
```

This will generate an `enum` for each of your `NSStoryboard`/`UIStoryboard`, with one `case` per storyboard scene.

<details>
<summary>Example of code generated by the bundled template</summary>

The generated code will look like this:

```swift
enum StoryboardScene {
  enum Dependency: StoryboardType {
    static let storyboardName = "Dependency"

    static let dependent = SceneType<UIViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  enum Message: StoryboardType {
    static let storyboardName = "Message"

    static let messagesList = SceneType<UITableViewController>(storyboard: Message.self, identifier: "MessagesList")
  }
}

enum StoryboardSegue {
  enum Message: String, SegueType {
    case embed
    case nonCustom
  }
}
```
</details>

### Usage Example

```swift
// You can instantiate scenes using the `instantiate` method:
let vc = StoryboardScene.Dependency.dependent.instantiate()

// You can perform segues using:
vc.perform(segue: StoryboardSegue.Message.embed)

// or match them (in prepareForSegue):
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  switch StoryboardSegue.Message(rawValue: segue.identifier!)! {
  case .embed:
    // Prepare for your custom segue transition
  case .nonCustom:
    // Pass in information to the destination View Controller
  }
}
```

## Strings

```sh
swiftgen strings -t structured-swift3 /path/to/Localizable.strings
```

This will generate a Swift `enum L10n` that will map all your `Localizable.strings` (or other tables) keys to an `enum case`. Additionaly, if it detects placeholders like `%@`,`%d`,`%f`, it will add associated values to that `case`. Note that all dots within the key are converted to dots in code.

<details>
<summary>Example of code generated by the structured bundled template</summary>

Given the following `Localizable.strings` file:

```swift
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"apples.count" = "You have %d apples";
"bananas.owner" = "Those %d bananas belong to %@.";
```

> _Reminder: Don't forget to end each line in your `*.strings` files with a semicolon `;`! Now that in Swift code we don't need semi-colons, it's easy to forget it's still required by the `Localizable.strings` file format 😉_

The generated code will contain this:

```swift
enum L10n {
  /// Some alert body there
  static let alertMessage = L10n.tr("alert_message")
  /// Title of the alert
  static let alertTitle = L10n.tr("alert_title")

  enum Apples {
    /// You have %d apples
    static func count(_ p1: Int) -> String {
      return L10n.tr("apples.count", p1)
    }
  }

  enum Bananas {
    /// Those %d bananas belong to %@.
    static func owner(_ p1: Int, _ p2: String) -> String {
      return L10n.tr("bananas.owner", p1, p2)
    }
  }
}
```
</details>

### Usage Example

Once the code has been generated by the script, you can use it this way in your Swift code:

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.Apples.count(3)
let bananas = L10n.Bananas.owner(5, "Olivier")
```

### Flat Strings Support

SwiftGen also has a template to support flat strings files (i.e. no dot syntax). The advantage is that your keys won't be mangled in any way, the disadvantage is worse auto-completion.

<details>
<summary>Example of code generated by the flat bundled template</summary>

```swift
enum L10n {
  /// Some alert body there
  case alertMessage
  /// Title of the alert
  case alertTitle
  /// You have %d apples
  case applesCount(Int)
  /// Those %d bananas belong to %@.
  case bananasOwner(Int, String)
}
```
</details>

Given the same `Localizable.strings` as above the usage will now be:

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.applesCount(3)
let bananas = L10n.bananasOwner(5, "Olivier")
```

---


# License

This code and tool is under the MIT License. See the `LICENSE` file in this repository.


## Attributions

This tool is powered by

- [Stencil](https://github.com/kylef/Stencil) and few other libs by [Kyle Fuller](https://github.com/kylef)
- SwiftGenKit and [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit), our internal frameworks at SwiftGen

It is currently mainly maintained by [@AliSoftware](https://github.com/AliSoftware) and [@djbe](https://github.com/djbe). But I couldn't thank enough all the other [contributors](https://github.com/SwiftGen/SwiftGen/graphs/contributors) to this tool along the different versions which helped make SwiftGen awesome! 🎉

If you want to contribute, don't hesitate to open an Pull Request, or even join the team!

## Other Libraries / Tools

If you want to also get rid of String-based APIs not only for your ressources, but also for `UITableViewCell`, `UICollectionViewCell` and XIB-based views, you should take a look I my Mixin [Reusable](https://github.com/AliSoftware/Reusable).

If you want to generate Swift code from your own Swift code (so meta!), like generate `Equatable` conformance to your types and a lot of other similar things, use [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

_SwiftGen and Sourcery are complementary tools. In fact, Sourcery uses `Stencil` too, as well as SwiftGen's `StencilSwiftKit` so you can use the exact same syntax for your templates for both!_

You can also [follow me on twitter](http://twitter.com/aligatr) for news/updates about other projects I am creating, or [read my blog](https://alisoftware.github.io).
