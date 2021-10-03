# SwiftGen

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftGen.svg)](https://img.shields.io/cocoapods/v/SwiftGen.svg)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGen.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGen)
![Swift 4.x](https://img.shields.io/badge/Swift-4.x-orange) ![Swift 5.x](https://img.shields.io/badge/Swift-5.x-orange)

SwiftGen is a tool to automatically generate Swift code for resources of your projects (like images, localised strings, etc), to make them type-safe to use.

<table border="0"><tr>
  <td>
    <img alt="SwiftGen Logo" src="https://github.com/SwiftGen/Eve/raw/master/logo/logo-256.png" />
  </td><td>
    <ul>
        <li><a href="#installation">Installation</a>
        <li><a href="#configuration-file">Configuration File</a>
        <li><a href="#choosing-your-template">Choosing your template</a>
        <li><a href="#additional-documentation">Additional documentation</a>
    </ul>
    Then generate constants for:
    <ul>
      <li><a href="#asset-catalog">Assets Catalogs</a>
      <li><a href="#colors">Colors</a>
      <li><a href="#core-data">Core Data</a>
      <li><a href="#files">Files</a>
      <li><a href="#fonts">Fonts</a>
      <li><a href="#interface-builder">Interface Builder files</a>
      <li><a href="#json-and-yaml">JSON and YAML files</a>
      <li><a href="#plists">Plists</a>
      <li><a href="#strings">Localizable strings</a>
    </ul>
  </td>
</tr></table>

<span style="float:none" />

There are multiple benefits in using this:

* Avoid any risk of typo when using a String
* Free auto-completion
* Avoid the risk of using a non-existing asset name
* All this will be ensured by the compiler and thus avoid the risk of crashing at runtime.

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
"${PROJECT_DIR}/swiftgen/bin/swiftgen" …
```

---
</details>
<details>
<summary>Via <strong>CocoaPods</strong></summary>

If you're using CocoaPods, simply add `pod 'SwiftGen', '~> 6.0'` to your `Podfile`.

Then execute `pod install --repo-update` (or `pod update SwiftGen` if you want to update an existing SwiftGen installation) to download and install the `SwiftGen` binaries and dependencies in `Pods/SwiftGen/bin/swiftgen` next to your project.

Given that you can specify an exact version for `SwiftGen` in your `Podfile`, this allows you to ensure **all coworkers will use the same version of SwiftGen for this project**.

You can then invoke SwiftGen in your Script Build Phase using:

```sh
if [[ -f "${PODS_ROOT}/SwiftGen/bin/swiftgen" ]]; then
  "${PODS_ROOT}/SwiftGen/bin/swiftgen" …
else
  echo "warning: SwiftGen is not installed. Run 'pod install --repo-update' to install it."
fi
```

> Similarly, be sure to use `Pods/SwiftGen/bin/swiftgen` instead of just `swiftgen` where we mention commands with `swiftgen` in the rest of the documentation.

_Note: SwiftGen isn't really a pod, as it's not a library your code will depend on at runtime; so the installation via CocoaPods is just a trick that installs the SwiftGen binaries in the Pods/ folder, but you won't see any swift files in the Pods/SwiftGen group in your Xcode's Pods.xcodeproj. That's normal; the SwiftGen binary is still present in that folder in the Finder._

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

---
</details>
<details>
<summary>Via <strong>Mint</strong> <em>(system-wide installation)</em></summary>

> ❗️SwiftGen 6.0 or higher only.

To install SwiftGen via [Mint](https://github.com/yonaskolb/Mint), simply use:

```sh
$ mint install SwiftGen/SwiftGen
```
---
</details>
<details>
<summary><strong>Compile from source</strong> <em>(only recommended if you need features from the `stable` branch or want to test a PR)</em></summary>

This solution is when you want to build and install the latest version from `stable` and have access to features which might not have been released yet.

* If you have `homebrew` installed, you can use the following command to build and install the latest commit:

```sh
brew install swiftgen --HEAD
```

* Alternatively, you can clone the repository and use `rake cli:install` to build the tool and install it from any branch, which could be useful to test SwiftGen in a fork or a Pull Request branch.

Some Ruby tools are used in the build process, and the system Ruby works well if you are running a recent macOS.  However, if you are using `rbenv` you can run `rbenv install` to make sure you have a matching version of Ruby installed.  

Then install the Ruby Gems:

```sh
# Install bundle if it isn't installed
gem install bundle
# Install the Ruby gems from Gemfile
bundle install
```

You can now install to the default locations (no parameter) or to custom locations:

```sh
# Binary is installed in `./.build/swiftgen/bin`
$ rake cli:install
# - OR -
# Binary will be installed in `~/swiftgen/bin``
$ rake cli:install[~/swiftgen/bin]
```

You can then invoke SwiftGen using the path to the binary where you installed it:

```sh
~/swiftgen/bin/swiftgen …
```

Or add the path to the `bin` folder to your `$PATH` and invoke `swiftgen` directly.

---
</details>

### Known Installation Issues On macOS Before 10.14.4

Starting with [SwiftGen 6.2.1](https://github.com/SwiftGen/SwiftGen/releases/6.2.1), if you get an error similar to `dyld: Symbol not found: _$s11SubSequenceSlTl` when running SwiftGen, you'll need to install the [Swift 5 Runtime Support for Command Line Tools](https://support.apple.com/kb/DL1998).

Alternatively, you can:

- Update to macOS 10.14.4 or later
- Install Xcode 10.2 or later at `/Applications/Xcode.app`
- Rebuild SwiftGen from source using Xcode 10.2 or later

## Configuration File

> ❗️ If you're migrating from older SwiftGen versions, don't forget to [read the Migration Guide](Documentation/MigrationGuide.md).

SwiftGen is provided as a single command-line tool which uses a configuration file to define the various parsers to run (depending on the type of input files you need to parse) and their parameters.

To create a sample configuration file as a starting point to adapt to your needs, run `swiftgen config init`.

Each parser described in the [configuration file](Documentation/ConfigFile.md) (`strings`, `fonts`, `ib`, …) typically corresponds to a type of input resources to parse (strings files, IB files, Font files, JSON files, …), allowing you to generate constants for each types of those input files.

To use SwiftGen, simply create a `swiftgen.yml` YAML file (either manually or using `swiftgen config init`) then edit it to adapt to your project. The config file should list all the parsers to invoke, and for each parser, the list of inputs/outputs/templates/parameters to use for it.

For example:

```yaml
strings:
  inputs: Resources/Base.lproj
  outputs:
    - templateName: structured-swift5
      output: Generated/Strings.swift
xcassets:
  inputs:
    - Resources/Images.xcassets
    - Resources/MoreImages.xcassets
    - Resources/Colors.xcassets
  outputs:
    - templateName: swift5
      output: Generated/Assets.swift
```

Then you just have to invoke `swiftgen config run`, or even just `swiftgen` for short, and it will execute what's described in the configuration file.

[The dedicated documentation](Documentation/ConfigFile.md) explains the syntax and possibilities in details – like how to pass custom parameters to your templates, use `swiftgen config lint` to validate your config file, how to use alternate config files, and other tips.

There are also additional subcommands you can invoke from the command line to manage and configure SwiftGen:

* The `swiftgen config` subcommand to help you with the configuration file, especially `swiftgen config init` to create a starting point for your config and `swiftgen config lint` to validate that your Config file is valid and has no errors
* The `swiftgen template` subcommands to help you print, duplicate, find and manage templates bundled with SwiftGen

Lastly, you can use `--help` on `swiftgen` or one of its subcommand to see the detailed usage.

<details>
<summary><strong>Directly invoking a parser without a config file</strong></summary>

While we highly recommend the use a configuration file for performance reasons (especially if you have multiple outputs, but also because it's more flexible), it's also possible to directly invoke the available parsers individually using `swiftgen run`:

* `swiftgen run colors [OPTIONS] DIRORFILE1 …`
* `swiftgen run coredata [OPTIONS] DIRORFILE1 …`
* `swiftgen run files [OPTIONS] DIRORFILE1 …`
* `swiftgen run fonts [OPTIONS] DIRORFILE1 …`
* `swiftgen run ib [OPTIONS] DIRORFILE1 …`
* `swiftgen run json [OPTIONS] DIRORFILE1 …`
* `swiftgen run plist [OPTIONS] DIRORFILE1 …`
* `swiftgen run strings [OPTIONS] DIRORFILE1 …`
* `swiftgen run xcassets [OPTIONS] DIRORFILE1 …`
* `swiftgen run yaml [OPTIONS] DIRORFILE1 …`

One rare cases where this might be useful — as opposed to using a config file — is if you are working on a custom template and want to quickly test the specific parser you're working on at each iteration/version of your custom template, until you're happy with it.

Each parser command generally accepts the same options and syntax, and they mirror the options and parameters from the configuration file:

* `--output FILE` or `-o FILE`: set the file where to write the generated code. If omitted, the generated code will be printed on `stdout`.
* `--templateName NAME` or `-n NAME`: define the Stencil template to use (by name, see [here for more info](Documentation/templates)) to generate the output.
* `--templatePath PATH` or `-p PATH`: define the Stencil template to use, using a full path.
* Note: you should specify one and only one template when invoking SwiftGen. You have to use either `-t` or `-p` but should not use both at the same time (it wouldn't make sense anyway and you'll get an error if you try)
* `--filter REGEX` or `-f REGEX`: the filter to apply to each input path. Filters are applied to actual (relative) paths, not just the filename. Each command has a default filter that you can override with this option.
* Note: use `.+` to match multiple characters (at least one), and don't forget to escape the dot (`\.`) if you want to match a literal dot like for an extension. Add `$` at the end to ensure the path ends with the extension you want. Regular expressions will be case sensitive by default, and not anchored to the start/end of a path. For example, use `.+\.xib$` to match files with a `.xib` extension. Use a tool such as [RegExr](https://regexr.com) to ensure you're using a valid regular expression.
* Each command supports multiple input files (or directories where applicable).
* You can always use the `--help` flag to see what options a command accept, e.g. `swiftgen run xcassets --help`.

</details>

## Choosing your template

SwiftGen is based on templates (it uses [Stencil](https://github.com/stencilproject/Stencil) as its template engine). This means that **you can choose the template that fits the Swift version you're using** — and also the one that best fits your preferences — to **adapt the generated code to your own conventions and Swift version**.

### Bundled templates vs. Custom ones

SwiftGen comes bundled with some templates for each of the parsers (`colors`, `coredata`, `files`, `fonts`, `ib`, `json`, `plist`, `strings`, `xcassets`, `yaml`), which will fit most needs; simply use the `templateName` output option to specify the name of the template to use. But you can also create your own templates if the bundled ones don't suit your coding conventions or needs: just store them anywhere (like in your project repository) and use the `templatePath` output option instead of `templateName`, to specify their path.

💡 You can use the `swiftgen template list` command to list all the available bundled templates for each parser, and use `swiftgen template cat` to show a template's content and duplicate it to create your own variation.

For more information about how to create your own templates, [see the dedicated documentation](Documentation/Articles/Creating-custom-templates.md).

### Templates bundled with SwiftGen:

As explained above, you can use `swiftgen template list` to list all templates bundled with SwiftGen. For most SwiftGen parsers, we provide, among others:

* A `swift4` template, compatible with Swift 4
* A `swift5` template, compatible with Swift 5
* Other variants, like `flat-swift4/5` and `structured-swift4/5` templates for Strings, etc.

You can **find the documentation for each bundled template [here in the repo](Documentation/templates)**, with documentation organized as one folder per SwiftGen parser, then one MarkDown file per template. You can also use `swiftgen template doc` to open that documentation page in your browser directly from your terminal.

Each MarkDown file documents the Swift Version it's aimed for, the use case for that template (in which cases you might favor that template over others), the available parameters to customize it on invocation (using the `params:` key in your config file), and some code examples.

> Don't hesitate to make PRs to share your improvements suggestions on the bundled templates 😉

## Additional documentation

### Playground

The `SwiftGen.playground` available in this repository will allow you to play with the code that the tool typically generates, and see some examples of how you can take advantage of it.

This allows you to have a quick look at how typical code generated by SwiftGen looks like, and how you will then use the generated constants in your code.

### Dedicated Documentation in Markdown

There is a lot of documentation in the form of Markdown files in this repository, and in the related [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) repository as well.

Be sure to [check the "Documentation" folder](Documentation/) of each repository.

Especially, in addition to the previously mentioned [Migration Guide](Documentation/MigrationGuide.md) and [Configuration File](Documentation/ConfigFile.md) documentation, the `Documentation/` folder in the SwiftGen repository also includes:

* A [`templates` subdirectory](Documentation/templates/) that details the documentation for each of the templates bundled with SwiftGen (when to use each template, what the output will look like, and custom parameters to adjust them, …)
* A [`SwiftGenKit Contexts` subdirectory](Documentation/SwiftGenKit%20Contexts/) that details the structure of the "Stencil Contexts", i.e. the Dictionary/YAML representation resulting of parsing your input files. This documentation is useful for people wanting to write their own templates, so that they know the structure and various keys available when writing their template, to construct the wanted generated output accordingly.
* [Various articles](Documentation/Articles/) to provide best practices & tips on how to better take advantage of SwiftGen in your projects:
  * [Integrate SwiftGen in your Xcode project](Documentation/Articles/Xcode-Integration.md) — so it rebuilds the constants every time you build
  * [Configure SwiftLint to help your developers use constants generated by SwiftGen](Documentation/Articles/SwiftLint-Integration.md)
  * [Create a custom template](Documentation/Articles/Creating-custom-templates.md), and [watch a folder to auto-regenerate an output every time you save the template you're working on](Documentation/Articles/Watch-a-folder-for-changes.md)
  * …and more

### Tutorials

You can also find other help & tutorial material on the internet, like [this classroom about Code Generation I gave at FrenchKit in Sept'17](https://github.com/FrenchKit/Mastering-code-generation-Classroom) — and its wiki detailing a step-by-step tutorial about installing and using SwiftGen (and Sourcery too)

---

# Available Parsers

## Asset Catalog

```yaml
xcassets:
  inputs: /dir/to/search/for/imageset/assets
  outputs:
    templateName: swift5
    output: Assets.swift
```

This will generate an `enum Asset` with one `static let` per asset (image set, color set, data set, …) in your assets catalog, so that you can use them as constants.

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal enum Asset {
  internal enum Files {
    internal static let data = DataAsset(value: "Data")
    internal static let readme = DataAsset(value: "README")
  }
  internal enum Food {
    internal enum Exotic {
      internal static let banana = ImageAsset(value: "Exotic/Banana")
      internal static let mango = ImageAsset(value: "Exotic/Mango")
    }
    internal static let `private` = ImageAsset(value: "private")
  }
  internal enum Styles {
    internal enum Vengo {
      internal static let primary = ColorAsset(value: "Vengo/Primary")
      internal static let tint = ColorAsset(value: "Vengo/Tint")
    }
  }
  internal enum Symbols {
    internal static let exclamationMark = SymbolAsset(name: "Exclamation Mark")
    internal static let plus = SymbolAsset(name: "Plus")
  }
  internal enum Targets {
    internal static let bottles = ARResourceGroupAsset(name: "Bottles")
    internal static let paintings = ARResourceGroupAsset(name: "Paintings")
  }
}
```
</details>

### Usage Example

```swift
// You can create new images by referring to the enum instance and calling `.image` on it:
let bananaImage = Asset.Exotic.banana.image
let privateImage = Asset.private.image

// You can create colors by referring to the enum instance and calling `.color` on it:
let primaryColor = Asset.Styles.Vengo.primary.color
let tintColor = Asset.Styles.Vengo.tint.color

// You can create data items by referring to the enum instance and calling `.data` on it:
let data = Asset.data.data
let readme = Asset.readme.data

// You can load an AR resource group's items using:
let bottles = Asset.Targets.bottles.referenceObjects
let paintings = Asset.Targets.paintings.referenceImages

// You can create new symbol images by referring to the enum instance and calling `.image` on it (with or without configuration)
let plus = Asset.Symbols.plus.image
let style = UIImage.SymbolConfiguration(textStyle: .headline)
let styled = Asset.Symbols.exclamationMark.image(with: style)
```

## Colors

> ❗️ We recommend to define your colors in your Assets Catalogs and use the `xcassets` parser (see above) to generate color constants, instead of using this `colors` parser described below.  
> The `colors` parser below is mainly useful if you support older versions of iOS where colors can't be defined in Asset Catalogs, or if you want to use Android's `colors.xml` files as input.

```yaml
colors:
  inputs: /path/to/colors-file.txt
  outputs:
    templateName: swift5
    output: Colors.swift
```

This will generate a `enum ColorName` with one `static let` per color listed in the text file passed as argument.

The input file is expected to be either:

* a [plain text file](Sources/TestUtils/Fixtures/Resources/Colors/extra.txt), with one line per color to register, each line being composed by the Name to give to the color, followed by ":", followed by the Hex representation of the color (like `rrggbb` or `rrggbbaa`, optionally prefixed by `#` or `0x`) or the name of another color in the file. Whitespaces are ignored.
* a [JSON file](Sources/TestUtils/Fixtures/Resources/Colors/colors.json), representing a dictionary of names -> values, each value being the hex representation of the color
* a [XML file](Sources/TestUtils/Fixtures/Resources/Colors/colors.xml), expected to be the same format as the Android colors.xml files, containing tags `<color name="AColorName">AColorHexRepresentation</color>`
* a [`*.clr` file](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DrawColor/Concepts/AboutColorLists.html#//apple_ref/doc/uid/20000757-BAJHJEDI) used by Apple's Color Palettes.

For example you can use this command to generate colors from one of your system color lists:

```yaml
colors:
  inputs: ~/Library/Colors/MyColors.clr
  outputs:
    templateName: swift5
    output: Colors.swift
```

Generated code will look the same as if you'd use a text file.

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
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#339666"></span>
  /// Alpha: 100% <br/> (0x339666ff)
  internal static let articleBody = ColorName(rgbaValue: 0x339666ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff66cc"></span>
  /// Alpha: 100% <br/> (0xff66ccff)
  internal static let articleFootnote = ColorName(rgbaValue: 0xff66ccff)

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

## Core Data

```yaml
coredata:
  inputs: /path/to/model.xcdatamodeld
  outputs:
    templateName: swift5
    output: CoreData.swift
```

This will parse the specified core data model(s), generate a class for each entity in your model containing all the attributes, and a few extensions if needed for relationships and predefined fetch requests.

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal class MainEntity: NSManagedObject {
  internal class var entityName: String {
    return "MainEntity"
  }

  internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<MainEntity> {
    return NSFetchRequest<MainEntity>(entityName: entityName)
  }

  @NSManaged internal var attributedString: NSAttributedString?
  @NSManaged internal var binaryData: Data?
  @NSManaged internal var boolean: Bool
  @NSManaged internal var date: Date?
  @NSManaged internal var float: Float
  @NSManaged internal var int64: Int64
  internal var integerEnum: IntegerEnum {
    get {
      let key = "integerEnum"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      guard let value = primitiveValue(forKey: key) as? IntegerEnum.RawValue,
        let result = IntegerEnum(rawValue: value) else {
        fatalError("Could not convert value for key '\(key)' to type 'IntegerEnum'")
      }
      return result
    }
    set {
      let key = "integerEnum"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue.rawValue, forKey: key)
    }
  }
  @NSManaged internal var manyToMany: Set<SecondaryEntity>
}

// MARK: Relationship ManyToMany

extension MainEntity {
  @objc(addManyToManyObject:)
  @NSManaged public func addToManyToMany(_ value: SecondaryEntity)

  @objc(removeManyToManyObject:)
  @NSManaged public func removeFromManyToMany(_ value: SecondaryEntity)

  @objc(addManyToMany:)
  @NSManaged public func addToManyToMany(_ values: Set<SecondaryEntity>)

  @objc(removeManyToMany:)
  @NSManaged public func removeFromManyToMany(_ values: Set<SecondaryEntity>)
}
```
</details>

### Usage Example

```swift
// Fetch all the instances of MainEntity
let request = MainEntity.makeFetchRequest()
let mainItems = try myContext.execute(request)

// Type-safe relationships: `relatedItem` will be a `SecondaryEntity?` in this case
let relatedItem = myMainItem.manyToMany.first
```

## Files

```yaml
files:
  inputs: path/to/search
  filter: .+\.mp4$
  outputs:
    templateName: structured-swift5
    output: Files.swift
```

The files parser is intended to just list the name and mimetype of the files and subdirectories in a given directory. This will recursively search the specified directory using the given filter (default `.*`), defining a `struct File` for each matching file, and an hierarchical enum representing the directory structure of files.

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal enum Files {
  /// test.txt
  internal static let testTxt = File(name: "test", ext: "txt", path: "", mimeType: "text/plain")
  /// subdir/
  internal enum Subdir {
    /// subdir/A Video With Spaces.mp4
    internal static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", path: "subdir", mimeType: "video/mp4")
  }
}
```
</details>

### Usage Example

```swift
// Access files using the `url` or `path` fields
let txt = Files.testTxt.url
let video = Files.Subdir.aVideoWithSpacesMp4.path

// In addition, there are `url(locale:)` and `path(locale:)` to specify a locale
let localeTxt = Files.testTxt.url(locale: Locale.current)
let localeVideo = Files.Subdir.aVideoWithSpacesMp4.path(locale: Locale.current)
```

### Flat Structure Support

SwiftGen also has a template if you're not interested in keeping the folder structure in the generated code.

<details>
<summary>Example of code generated by the flat bundled template</summary>

```swift
internal enum Files {
  /// test.txt
  internal static let testTxt = File(name: "test", ext: "txt", path: "", mimeType: "text/plain")
  /// subdir/A Video With Spaces.mp4
  internal static let aVideoWithSpacesMp4 = File(name: "A Video With Spaces", ext: "mp4", path: "subdir", mimeType: "video/mp4")
  }
}
```
</details>

Given the same file and folder structure as above the usage will now be:

```swift
// Access files using the `url` or `path` fields
let txt = Files.testTxt.url
let video = Files.aVideoWithSpacesMp4.path

// In addition, there are `url(locale:)` and `path(locale:)` to specify a locale
let localeTxt = Files.testTxt.url(locale: Locale.current)
let localeVideo = Files.aVideoWithSpacesMp4.path(locale: Locale.current)
```

## Fonts

```yaml
fonts:
  inputs: /path/to/font/dir
  outputs:
    templateName: swift5
    output: Fonts.swift
```

This will recursively go through the specified directory, finding any typeface files (TTF, OTF, …), defining a `struct FontFamily` for each family, and an enum nested under that family that will represent the font styles.

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal enum FontFamily {
  internal enum SFNSDisplay: String, FontConvertible {
    internal static let regular = FontConvertible(name: ".SFNSDisplay-Regular", family: ".SF NS Display", path: "SFNSDisplay-Regular.otf")
  }
  internal enum ZapfDingbats: String, FontConvertible {
    internal static let regular = FontConvertible(name: "ZapfDingbatsITC", family: "Zapf Dingbats", path: "ZapfDingbats.ttf")
  }
}
```
</details>

### Usage Example

```swift
// You can create fonts with the convenience constructor like this:
let displayRegular = UIFont(font: FontFamily.SFNSDisplay.regular, size: 20.0) // iOS
let dingbats = NSFont(font: FontFamily.ZapfDingbats.regular, size: 20.0)  // macOS

// Or as an alternative, you can refer to enum instance and call .font on it:
let sameDisplayRegular = FontFamily.SFNSDisplay.regular.font(size: 20.0)
let sameDingbats = FontFamily.ZapfDingbats.regular.font(size: 20.0)
```

## Interface Builder

```yaml
ib:
  inputs: /dir/to/search/for/storyboards
  outputs:
    - templateName: scenes-swift5
      output: Storyboard Scenes.swift
    - templateName: segues-swift5
      output: Storyboard Segues.swift
```

This will generate an `enum` for each of your `NSStoryboard`/`UIStoryboard`, with respectively one `static let` per storyboard scene or segue.

<details>
<summary>Example of code generated by the bundled template</summary>

The generated code will look like this:

```swift
// output from the scenes template

internal enum StoryboardScene {
  internal enum Dependency: StoryboardType {
    internal static let storyboardName = "Dependency"

    internal static let dependent = SceneType<UIViewController>(storyboard: Dependency.self, identifier: "Dependent")
  }
  internal enum Message: StoryboardType {
    internal static let storyboardName = "Message"

    internal static let messagesList = SceneType<UITableViewController>(storyboard: Message.self, identifier: "MessagesList")
  }
}

// output from the segues template

internal enum StoryboardSegue {
  internal enum Message: String, SegueType {
    case customBack = "CustomBack"
    case embed = "Embed"
    case nonCustom = "NonCustom"
    case showNavCtrl = "Show-NavCtrl"
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
  switch StoryboardSegue.Message(segue) {
  case .embed?:
    // Prepare for your custom segue transition, passing information to the destination VC
  case .customBack?:
    // Prepare for your custom segue transition, passing information to the destination VC
  default:
    // Other segues from other scenes, not handled by this VC
    break
  }
}
```

## JSON and YAML

```yaml
json:
  inputs: /path/to/json/dir-or-file
  outputs:
    templateName: runtime-swift5
    output: JSON.swift
yaml:
  inputs: /path/to/yaml/dir-or-file
  outputs:
    templateName: inline-swift5
    output: YAML.swift
```

This will parse the given file, or when given a directory, recursively search for JSON and YAML files. It will define an `enum` for each file (and documents in a file where needed), and type-safe constants for the content of the file.

Unlike other parsers, this one is intended to allow you to use more custom inputs (as the formats are quite open to your needs) to generate your code. This means that for these parsers (and the `plist` one), you'll probably be more likely to use custom templates to generate code properly adapted/tuned to your inputs, rather than using the bundled templates. To read more about writing your own custom templates, see [see the dedicated documentation](Documentation/Articles/Creating-custom-templates.md).

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal enum JSONFiles {
  internal enum Info {
    private static let _document = JSONDocument(path: "info.json")
    internal static let key1: String = _document["key1"]
    internal static let key2: String = _document["key2"]
    internal static let key3: [String: Any] = _document["key3"]
  }
  internal enum Sequence {
    internal static let items: [Int] = objectFromJSON(at: "sequence.json")
  }
}
```
</details>

### Usage Example

```swift
// This will be a dictionary
let foo = JSONFiles.Info.key3

// This will be an [Int]
let bar = JSONFiles.Sequence.items
```

## Plists

```yaml
plist:
  inputs: /path/to/plist/dir-or-file
  outputs:
    templateName: runtime-swift5
    output: Plist.swift
```

This will parse the given file, or when given a directory, recursively search for Plist files. It will define an `enum` for each file (and documents in a file where needed), and type-safe constants for the content of the file.

Unlike other parsers, this one is intended to allow you to use more custom inputs (as the format is quite open to your needs) to generate your code. This means that for this parser (and the `json` and `yaml` ones), you'll probably be more likely to use custom templates to generate code properly adapted/tuned to your inputs, rather than using the bundled templates. To read more about writing your own custom templates, see [see the dedicated documentation](Documentation/Articles/Creating-custom-templates.md).

<details>
<summary>Example of code generated by the bundled template</summary>

```swift
internal enum PlistFiles {
  internal enum Test {
    internal static let items: [String] = arrayFromPlist(at: "array.plist")
  }
  internal enum Stuff {
    private static let _document = PlistDocument(path: "dictionary.plist")
    internal static let key1: Int = _document["key1"]
    internal static let key2: [String: Any] = _document["key2"]
  }
}
```
</details>

### Usage Example

```swift
// This will be an array
let foo = PlistFiles.Test.items

// This will be an Int
let bar = PlistFiles.Stuff.key1
```

## Strings

```yaml
strings:
  inputs: /path/to/language.lproj
  outputs:
    templateName: structured-swift5
    output: Strings.swift
```

This will generate a Swift `enum L10n` that will map all your `Localizable.strings` and `Localizable.stringsdict` (or other tables) keys to a `static let` constant. And if it detects placeholders like `%@`,`%d`,`%f`, it will generate a `static func` with the proper argument types instead, to provide type-safe formatting.

> Note that all dots within the key names are converted to dots in code (by using nested enums). You can provide a different separator than `.` to split key names into substructures by using a parser option – see [the parser documentation](Documentation/Parsers/strings.md).

<details>
<summary>Example of code generated by the structured bundled template</summary>

Given the following `Localizable.strings` file:

```swift
"alert_title" = "Title of the alert";
"alert_message" = "Some alert body there";
"bananas.owner" = "Those %d bananas belong to %@.";
```

And the following `Localizable.stringsdict` file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
  <dict>
    <key>apples.count</key>
    <dict>
        <key>NSStringLocalizedFormatKey</key>
        <string>%#@apples@</string>
        <key>apples</key>
        <dict>
            <key>NSStringFormatSpecTypeKey</key>
            <string>NSStringPluralRuleType</string>
            <key>NSStringFormatValueTypeKey</key>
            <string>d</string>
            <key>zero</key>
            <string>You have no apples</string>
            <key>one</key>
            <string>You have one apple</string>
            <key>other</key>
            <string>You have %d apples. Wow that is a lot!</string>
        </dict>
    </dict>
  </dict>
</plist>
```

> _Reminder: Don't forget to end each line in your `*.strings` files with a semicolon `;`! Now that in Swift code we don't need semi-colons, it's easy to forget it's still required by the `Localizable.strings` file format 😉_

The generated code will contain this:

```swift
internal enum L10n {
  /// Some alert body there
  internal static let alertMessage = L10n.tr("alert_message")
  /// Title of the alert
  internal static let alertTitle = L10n.tr("alert_title")

  internal enum Apples {
    /// Plural format key: "%#@apples@"
    internal static func count(_ p1: Int) -> String {
      return L10n.tr("apples.count", p1)
    }
  }

  internal enum Bananas {
    /// Those %d bananas belong to %@.
    internal static func owner(_ p1: Int, _ p2: Any) -> String {
      return L10n.tr("bananas.owner", p1, String(describing: p2))
    }
  }
}
```
Note that if the same key is present in both the `.strings` and the `.stringsdict` files, SwiftGen will only consider the one in the `.stringsdict` file, as that's also how Foundation behaves at runtime.

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

SwiftGen also has a template to support flat strings files (i.e. without splitting the keys in substructures using "dot syntax"). The advantage is that your keys won't be mangled in any way; the disadvantage is that auto-completion won't be as nice.

<details>
<summary>Example of code generated by the flat bundled template</summary>

```swift
internal enum L10n {
  /// Some alert body there
  internal static let alertMessage = L10n.tr("Localizable", "alert__message")
  /// Title of the alert
  internal static let alertTitle = L10n.tr("Localizable", "alert__title")
  /// Plural format key: "%#@apples@"
  internal static func applesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "apples.count", p1)
  }
  /// Those %d bananas belong to %@.
  internal static func bananasOwner(_ p1: Int, _ p2: Any) -> String {
    return L10n.tr("Localizable", "bananas.owner", p1, String(describing: p2))
  }
}
```
</details>

Given the same `Localizable.strings` and `Localizable.stringsdict` as above the usage will now be:

```swift
// Simple strings
let message = L10n.alertMessage
let title = L10n.alertTitle

// with parameters, note that each argument needs to be of the correct type
let apples = L10n.applesCount(3)
let bananas = L10n.bananasOwner(5, "Olivier")
```

---

# Licence

This code and tool is under the MIT Licence. See the `LICENCE` file in this repository.

## Attributions

This tool is powered by

- [Stencil](https://github.com/stencilproject/Stencil) and few other libs by [Kyle Fuller](https://github.com/kylef)
- SwiftGenKit and [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit), our internal frameworks at SwiftGen

It is currently mainly maintained by [@AliSoftware](https://github.com/AliSoftware) and [@djbe](https://github.com/djbe). But I couldn't thank enough all the other [contributors](https://github.com/SwiftGen/SwiftGen/graphs/contributors) to this tool along the different versions which helped make SwiftGen awesome! 🎉

If you want to contribute, don't hesitate to open a Pull Request, or even join the team!

## Other Libraries / Tools

If you want to also get rid of String-based APIs not only for your resources, but also for `UITableViewCell`, `UICollectionViewCell` and XIB-based views, you should take a look at my Mixin [Reusable](https://github.com/AliSoftware/Reusable).

If you want to generate Swift code from your own Swift code (so meta!), like generate `Equatable` conformance to your types and a lot of other similar things, use [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

_SwiftGen and Sourcery are complementary tools. In fact, Sourcery uses `Stencil` too, as well as SwiftGen's `StencilSwiftKit` so you can use the exact same syntax for your templates for both!_

You can also [follow me on twitter](http://twitter.com/aligatr) for news/updates about other projects I am creating, or [read my blog](https://alisoftware.github.io).
