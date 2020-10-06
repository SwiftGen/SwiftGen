# SwiftGen CHANGELOG

---

## 6.4.0

### New Features

* The built-in templates will now correctly handle Swift Package Manager resources, using `Bundle.module` if it's available. As before, you can override the used `Bundle` using the `bundle` or `lookupFunction` template parameters.  
  [Arnaud Dorgans](https://github.com/arnauddorgans)
  [#763](https://github.com/SwiftGen/SwiftGen/pull/763)
* Added `config generate-xcfilelist` subcommand to generate input and output `xcfilelist`s based on your configuration file. These files should then be used in an Xcode build step that executes `swiftgen config run`. Don't forget to regenerate the file lists after adding/removing resources in your project in a way that might impact them.  
  [@CraigSiemens](https://github.com/CraigSiemens)
  [#441](https://github.com/SwiftGen/SwiftGen/issues/441)
* Colors: the XML parser now accepts a `colorFormat` option, used to change the color format. The default format is `rgba`.  
  [@kevinstier](https://github.com/kevinstier)
  [#562](https://github.com/SwiftGen/SwiftGen/issues/562)
  [#768](https://github.com/SwiftGen/SwiftGen/pull/768)
* IB: Added support for instantiating scenes while providing a `creator` block, commonly used for dependency injection. This feature is available in generated code starting from iOS 13, tvOS 13 and macOS 10.15.  
  [@matsune](https://github.com/matsune)
  [David Jennes](https://github.com/djbe)
  [#778](https://github.com/SwiftGen/SwiftGen/pull/778)

### Bug Fixes

* Plist: Update the parsing strategy (using `Codable`) to fix parsing of `Bool` values as `Integer` in some cases.  
  [@fortmarek](https://github.com/fortmarek)
  [Olivier Halligon](https://github.com/AliSoftware)
  [#779](https://github.com/SwiftGen/SwiftGen/pull/779)
* JSON/Plist/YAML: fixed issue with `inline` templates which incorrectly generated `1`/`0` as values, instead of `true`/`false` as expected.  
  [David Jennes](https://github.com/djbe)
  [#779](https://github.com/SwiftGen/SwiftGen/pull/779)
  [#783](https://github.com/SwiftGen/SwiftGen/pull/783)
* JSON: the parser now correctly recognizes `0` and `1` as `Int` (instead of `Bool`).  
  [David Jennes](https://github.com/djbe)
  [#786](https://github.com/SwiftGen/SwiftGen/pull/786)

### Internal Changes

* Update the Swift version in `.swift-version` so that the right version is used when building manually (using `swiftenv`).  
  [@cfiken](https://github.com/cfiken)
  [#764](https://github.com/SwiftGen/SwiftGen/issues/764)
* Update Yams from `3.0.0` to `4.0.0`.  
  [@hungrxyz](https://github.com/hungrxyz)
  [#772](https://github.com/SwiftGen/SwiftGen/issues/772)
* Updated Pods and Gems dependencies, and Xcode 12.  
  [David Jennes](https://github.com/djbe)
  [#782](https://github.com/SwiftGen/SwiftGen/pull/782)

## 6.3.0

### Deprecations

* Fonts: the generated `Font` typealias (to `UIFont`/`NSFont`) is deprecated and will be removed in the next major release.  
  [David Jennes](https://github.com/djbe)
  [#728](https://github.com/SwiftGen/SwiftGen/pull/728)

### New Features

* Strings: support for plurals declared in `.stringsdict` files.  
  [Florian Fittschen](https://github.com/ffittschen)
  [#184](https://github.com/SwiftGen/SwiftGen/issues/184)
  [#634](https://github.com/SwiftGen/SwiftGen/pull/634)
* Fonts: the templates now support a new `fontTypeName` template parameter that you can use to change the name of the `struct` representing a font to something else.  
  [David Jennes](https://github.com/djbe)
  [#728](https://github.com/SwiftGen/SwiftGen/pull/728)
* Fonts: the templates now support a new `fontAliasName` that you can use to change the `typealias`'s name from `Font` to something else. For example: this is useful when working with SwiftUI which already defines a `Font` type. Note that as this `typealias` is deprecated (see deprecations above), this template parameter will also be removed in the next major release.  
  [David Jennes](https://github.com/djbe)
  [#647](https://github.com/SwiftGen/SwiftGen/issues/647)
  [#728](https://github.com/SwiftGen/SwiftGen/pull/728)
* CoreData: Deprecates `fetchRequest()` and adds `makeFetchRequest()` to avoid ambiguous function usage.  
  [David Rothera](https://github.com/davidrothera)
  [#726](https://github.com/SwiftGen/SwiftGen/pull/726)
* XCAssets: image assets now load faster on macOS if they're in the `main` bundle. MacOS only provides a caching mechanism for images in the `main` bundle, for other cases you may need to provide your own caching mechanism as needed.  
  [David Jennes](https://github.com/djbe)
  [#648](https://github.com/SwiftGen/SwiftGen/issues/648)
  [#733](https://github.com/SwiftGen/SwiftGen/pull/733)
* Fonts/IB/JSON/Plist/Strings/XCAssets: all templates that load data at runtime from a bundle now support a `bundle` template parameter, which you can use to override the bundle from which resources are loaded. Check out the [template specific documentation](Documentation/templates/) for more information. For an in-depth explanation, also check the [customize loading of resources](Documentation/Articles/Customize-loading-of-resources.md) article.  
  [David Jennes](https://github.com/djbe)
  [#737](https://github.com/SwiftGen/SwiftGen/pull/737)
* Fonts/IB/JSON/Plist: Similar to the `strings` templates, these templates now support a `lookupFunction` template parameter, which allows you to provide your own resource lookup mechanism at runtime. Check the [template specific documentation](Documentation/templates/) for more information. For an in-depth explanation, also check the [customize loading of resources](Documentation/Articles/Customize-loading-of-resources.md) article.  
  [David Jennes](https://github.com/djbe)
  [#738](https://github.com/SwiftGen/SwiftGen/pull/738)

### Bug Fixes

* Strings: fix incorrect interpretation of format placeholders when there were missing positional parameters (e.g. `"%2$@"` without a `%1$…` defined).  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#634](https://github.com/SwiftGen/SwiftGen/pull/634)

## 6.2.1

There are no major changes in this release, although JSON & Plist template writers may want to read the [small migration guide](Documentation/SwiftGenKit%20Contexts/MigrationGuide.md##swiftgen-621-migration-guide) to prepare for upcoming context changes.

### Deprecations

* JSON & Plist: if you wrote your own templates, know that the `documents` property of a file has been deprecated in favour of `document`. The old `documents` property will be removed in the next major release.  
  [David Jennes](https://github.com/djbe)
  [#702](https://github.com/SwiftGen/SwiftGen/pull/702)
  [#732](https://github.com/SwiftGen/SwiftGen/pull/732)

### Bug Fixes

* Prevent generating `default.profraw` (code coverage) files.  
  [David Jennes](https://github.com/djbe)
  [#722](https://github.com/SwiftGen/SwiftGen/pull/722)
* JSON/Plist/YAML: Fix issue with homogeneous `Array`s in the Inline templates (such as `[String`]).  
  [#687](https://github.com/SwiftGen/SwiftGen/pull/687)
  [@fjtrujy](https://github.com/fjtrujy)
* Avoid breaking the system swift installation when installing SwiftGen via Homebrew on macOS 10.14.4 or higher.  
  [David Jennes](https://github.com/djbe)
  [#686](https://github.com/SwiftGen/SwiftGen/issues/686)
  [#730](https://github.com/SwiftGen/SwiftGen/pull/730)

### Internal Changes

* Parsers are now executed in parallel, making SwiftGen faster when multiple parsers are used. Note: only applies when using a configuration file.  
  [Marcelo Fabri](https://github.com/marcelofabri)
  [#699](https://github.com/SwiftGen/SwiftGen/issues/699)
* Use `JSONSerialization` instead of `Yams` for parsing JSONs, making the `json` parser faster.  
  [Marcelo Fabri](https://github.com/marcelofabri)
  [#698](https://github.com/SwiftGen/SwiftGen/issues/698)
* JSON/Plist/YAML: Lazily evaluate `metadata` of documents, making SwiftGen faster if the `metadata` field is never used in a template.  
  [Marcelo Fabri](https://github.com/marcelofabri)
  [#700](https://github.com/SwiftGen/SwiftGen/issues/700)

## 6.2.0

⚠️ This minor version contains a lot of deprecations that may apply to your configuration and how you use SwiftGen. With the exception of `swift3` templates (which have been removed), everything should still work as before. But be warned that all features marked as deprecated will be removed in SwiftGen 7.0.

Read the [SwiftGen 6.2 Migration Guide](Documentation/MigrationGuide.md#migrating-to-swiftgen-62) for a list of changes you'll need to apply.

### Breaking Changes

* As Swift 3 is officially no longer maintained, we're obsoleting the Swift 3 templates and they are no longer included with SwiftGen. You can still use the old swift 3 templates by getting them from older SwiftGen versions, or from GitHub by browsing older tags.  
  [David Jennes](https://github.com/djbe)
  [#601](https://github.com/SwiftGen/SwiftGen/pull/601)
  [#691](https://github.com/SwiftGen/SwiftGen/pull/691)

### Deprecations

* XCAssets: the `colorAliasName` and `imageAliasName` template parameters are now deprecated and will be removed in the next major release.  
  [David Jennes](https://github.com/djbe)
  [#614](https://github.com/SwiftGen/SwiftGen/pull/614)
* The use of `swiftgen <parser>` (e.g. `swiftgen strings`, `swiftgen xcassets`, …) command line for running individual parsers is now deprecated in favor of `swiftgen run <parser>`. See "New Features" below.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#705](https://github.com/SwiftGen/SwiftGen/pull/705)
* The subcommand `swiftgen templates` has been renamed `swiftgen template` (singular); the plural form of the command has been deprecated and will be removed in next major version.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#697](https://github.com/SwiftGen/SwiftGen/pull/697)
* The ability for SwiftGen to search custom named templates in `~/Library/Application Support` has been deprecated and will be removed in SwiftGen 7.0. This little known feature made SwiftGen dependent on the machine it was running on. Use `templatePath` to reference custom templates by path instead.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#717](https://github.com/SwiftGen/SwiftGen/pull/717)

### New Features

* Invoking individual parsers from the command line is now done via `swiftgen run <parser>`.  We still highly recommend to use a configuration file for flexibility and performance reasons in your projects, and only use `swiftgen run <parser>` for things like quick iterations when writing your own custom templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#705](https://github.com/SwiftGen/SwiftGen/pull/705)
* You can now easily create a new config file using `swiftgen config init`. This will create an example and commented config file and open it to let you edit it to your needs.  _Note that the generated config file is static content which doesn't take the user's project into account (though that might change in the future)_.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#694](https://github.com/SwiftGen/SwiftGen/pull/694)
* You can now use `swiftgen template doc [parser] [templateName]` on the command line to quickly open the documentation for templates on GitHub directly from your terminal.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#697](https://github.com/SwiftGen/SwiftGen/pull/697)
* Each parser now accepts an `options` dictionary, with which you can set internal parser settings to change its behaviour. See the parser's specific documentation for available options.  
  [David Jennes](https://github.com/djbe)
  [#587](https://github.com/SwiftGen/SwiftGen/pull/587)
  [#597](https://github.com/SwiftGen/SwiftGen/pull/597)
* Strings: the parser now accepts a `separator` option, used to split keys into structured components. The default separator remains `.`. For more information, check the [parser's documentation](Documentation/Parsers/strings.md#customization).  
  [David Jennes](https://github.com/djbe)
  [#576](https://github.com/SwiftGen/SwiftGen/issues/576)
  [#588](https://github.com/SwiftGen/SwiftGen/pull/588)
* Core Data: the built-in templates now support an optional `extraImports` parameter. With this you can provide a list of modules to additionally import, for when you have properties with types from external modules. For more information, check the [template's documentation](Documentation/templates/coredata/swift4.md#customization).  
  [David Jennes](https://github.com/djbe)
  [#591](https://github.com/SwiftGen/SwiftGen/issues/591)
  [#592](https://github.com/SwiftGen/SwiftGen/pull/592)
* Core Data: the built-in templates now support `RawRepresentable` attributes (such as `enum`, `OptionSet`, …). They'll check the "User Info" of an attribute for a `RawType` key, which should be set to the type name you want to use for that attribute. To avoid optional attributes, you can also add the `unwrapOptional` user info key. For more information, check the [template's documentation](Documentation/templates/coredata/swift4.md#userinfo-keys).  
  [David Jennes](https://github.com/djbe)
  [#566](https://github.com/SwiftGen/SwiftGen/issues/566)
  [#609](https://github.com/SwiftGen/SwiftGen/issues/609)
  [#593](https://github.com/SwiftGen/SwiftGen/pull/593)
  [#610](https://github.com/SwiftGen/SwiftGen/pull/610)
* Strings: the built-in templates now accept a parameter `lookupFunction` for customizing the localization function, check the [template documentation](Documentation/templates/strings/) for more information.  
  [Steven Magdy](https://github.com/StevenMagdy)
  [426](https://github.com/SwiftGen/SwiftGen/issues/426)
  [468](https://github.com/SwiftGen/SwiftGen/issues/468)
  [573](https://github.com/SwiftGen/SwiftGen/pull/573)
  [716](https://github.com/SwiftGen/SwiftGen/pull/716)
* Strings: templates to generate Objective-C. Please check [the template's documentation](Documentation/templates/strings/objc.md) for more information.  
  [Eric Slosser](https://github.com/Mr-Fixit)
  [SwiftGen/SwiftGen#378](https://github.com/SwiftGen/SwiftGen/pull/378)
* XCAssets: the parser now supports AR Resource Groups, together with reference images and objects.  
  [David Jennes](https://github.com/djbe)
  [#614](https://github.com/SwiftGen/SwiftGen/pull/614)
* Templates: Bundle now use static property on BundleToken for better performance.  
  [shuoli84](https://github.com/shuoli84)
  [#623](https://github.com/SwiftGen/SwiftGen/issues/623)
* All parsers now have built-in Swift 5 templates.  
  [David Jennes](https://github.com/djbe)
  [#595](https://github.com/SwiftGen/SwiftGen/issues/595)
  [#600](https://github.com/SwiftGen/SwiftGen/pull/600)
* Most templates now accept a parameter to force having the file name used as namespace (`enum <FileName>`) in generated code _even if_ there's only one single input file.  
  [Viktoras Laukevičius](https://github.com/viktorasl)
  [#669](https://github.com/SwiftGen/SwiftGen/issues/669)
  [Olivier Halligon](https://github.com/AliSoftware)
  [#693](https://github.com/SwiftGen/SwiftGen/pull/693)

### Bug Fixes

* SwiftGen now properly shows a better help message and the command usage when running an incomplete command, instead of complaining about a config file.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#706](https://github.com/SwiftGen/SwiftGen/pull/706)
* XCAssets: improved the performance for color assets by caching the resolved colors.  
  [David Jennes](https://github.com/djbe)
  [#578](https://github.com/SwiftGen/SwiftGen/issues/578)
  [#589](https://github.com/SwiftGen/SwiftGen/pull/589)
* Core Data: `entityName` is now correctly a `class var` instead of a `class func`.  
  [David Jennes](https://github.com/djbe)
  [#590](https://github.com/SwiftGen/SwiftGen/pull/590)
* Strings: we now correctly generate the type `Any` (instead of `String`) for `%@` placeholders.  
  [David Jennes](https://github.com/djbe)
  [620](https://github.com/SwiftGen/SwiftGen/issues/620)
* Colors: Reduce initializer type inference for improved compilation performance.  
  [Markus Faßbender](https://github.com/dermaaarkus)
  [#663](https://github.com/SwiftGen/SwiftGen/issues/663)
* Config Lint: fix config lint not processing relative paths containing ".." correctly.  
  [Wolfgang Lutz](https://github.com/Lutzifer)
  [#688](https://github.com/SwiftGen/SwiftGen/issues/688)
* Core Data: the generated code was missing `,` (comma) for fetch requests with multiple arguments.  
  [David Jennes](https://github.com/djbe)
  [#692](https://github.com/SwiftGen/SwiftGen/pull/692)
* Colors: Fix compile time warning when long expression type checking is enabled.  
  [Ryan Mason-Davies](https://github.com/iotize)
  [#704](https://github.com/SwiftGen/SwiftGen/issues/704)
  [#710](https://github.com/SwiftGen/SwiftGen/pull/710)

### Internal Changes

* The main branch of the repository has been renamed from `master` to `stable`. If you pointed your `Podfile` or dependency managment tool to `master` instead of an official release/tag, you will have to update the branch name in your dependency file.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#714](https://github.com/SwiftGen/SwiftGen/pull/714)
* Documentation: Improved doc for creating custom templates, and added a Documentation Table of Contents.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#713](https://github.com/SwiftGen/SwiftGen/pull/713)
* Refactoring: Reduce globals & rearrange CLI code.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#586](https://github.com/SwiftGen/SwiftGen/pull/586)
* Moved generated test output files into subdirectories per template.  
  [David Jennes](https://github.com/djbe)
  [#598](https://github.com/SwiftGen/SwiftGen/pull/598)
* Compile generated output using configuration files for easier management.  
  [David Jennes](https://github.com/djbe)
  [#365](https://github.com/SwiftGen/SwiftGen/issues/365)
  [#599](https://github.com/SwiftGen/SwiftGen/pull/599)
* XCAssets: renamed the catalogs we use for sample code & testing to avoid some confusion.  
  [David Jennes](https://github.com/djbe)
  [#613](https://github.com/SwiftGen/SwiftGen/pull/613)
* Update SwiftLint and enable some extra SwiftLint rules.  
  [David Jennes](https://github.com/djbe)
  [#617](https://github.com/SwiftGen/SwiftGen/pull/617)
* Some CI fixes related to software versions.  
  [Patrick Nollet](https://github.com/PatrickNLT)
  [#645](https://github.com/SwiftGen/SwiftGen/pull/645)
* Updated to CocoaPods 1.9.0.  
  [David Jennes](https://github.com/djbe)
  [#619](https://github.com/SwiftGen/SwiftGen/pull/619)
* Updated Pods and Gems dependencies.  
  [David Jennes](https://github.com/djbe)
  [#684](https://github.com/SwiftGen/SwiftGen/pull/684)

## 6.1.0

### Changes in core dependencies of SwiftGen

* [StencilSwiftKit 2.7.2](https://github.com/SwiftGen/StencilSwiftKit/blob/2.7.2/CHANGELOG.md)
* [Stencil 0.13.1](https://github.com/kylef/Stencil/blob/0.13.1/CHANGELOG.md)

### New Features

* Adds support for generating code from Core Data models.  
  [Grant Butler](https://github.com/grantjbutler)
  [David Jennes](https://github.com/djbe)
  [Igor Palaguta](https://github.com/Igor-Palaguta)
  [#455](https://github.com/SwiftGen/SwiftGen/pull/455)
  [#567](https://github.com/SwiftGen/SwiftGen/pull/567)
  [#575](https://github.com/SwiftGen/SwiftGen/pull/575)
  [#581](https://github.com/SwiftGen/SwiftGen/pull/581)
  [#45](https://github.com/SwiftGen/SwiftGen/issues/45)
  [#185](https://github.com/SwiftGen/SwiftGen/issues/185)
  [#191](https://github.com/SwiftGen/SwiftGen/pull/191)
  [#195](https://github.com/SwiftGen/SwiftGen/pull/195)
* Config: expand environment variables in YAML files.  
  [Wolfgang Lutz](https://github.com/lutzifer)
  [#355](https://github.com/SwiftGen/SwiftGen/issues/355)
  [#564](https://github.com/SwiftGen/SwiftGen/pull/564)
* Each parser now accepts a `filter` option, which accepts a regular expression for filtering input paths. The filter is applied to individual paths as well as when the parser recurses into directories.  
  [David Jennes](https://github.com/djbe)
  [#383](https://github.com/SwiftGen/SwiftGen/issues/383)
  [#570](https://github.com/SwiftGen/SwiftGen/pull/570)

### Bug Fixes

* Colors: Fix an issue where the `public` access modifier was not being added correctly in the `literals-swift3` and `literals-swift4` templates when the `publicAccess` parameter was specified. Also remove some uneccessary `public` access modifiers from the `swift3` and `swift4` templates.  
  [Isaac Halvorson](https://github.com/hisaac)
  [#549](https://github.com/SwiftGen/SwiftGen/pull/549)

### Internal Changes

* Resolve path if the binary is a symbolic link in order to find bundled templates.  
  [Liquidsoul](https://github.com/liquidsoul)
  [#559](https://github.com/SwiftGen/SwiftGen/issues/559)
* Update to SwiftLint 0.30.1 and enable some extra SwiftLint rules.  
  [David Jennes](https://github.com/djbe)
  [#574](https://github.com/SwiftGen/SwiftGen/pull/574)
  [#583](https://github.com/SwiftGen/SwiftGen/pull/583)

## 6.0.2

### Changes in core dependencies of SwiftGen

* [StencilSwiftKit 2.7.1](https://github.com/SwiftGen/StencilSwiftKit/blob/2.7.1/CHANGELOG.md)
* [Stencil 0.13.1](https://github.com/kylef/Stencil/blob/0.13.1/CHANGELOG.md)

### Bug Fixes

* Strings: rolled back the changes in #503, to ensure `%%` is correctly unescaped.  
  [David Jennes](https://github.com/djbe)
  [#542](https://github.com/SwiftGen/SwiftGen/pull/542)
* Strings: generate the correct types for `%c` and `%p`.  
  [David Jennes](https://github.com/djbe)
  [#543](https://github.com/SwiftGen/SwiftGen/pull/543)
* SPM/Mint: SwiftGen now provides correct version information, instead of "0.0".  
  [David Jennes](https://github.com/djbe)
  [#544](https://github.com/SwiftGen/SwiftGen/pull/544)

## 6.0.1

### Changes in core dependencies of SwiftGen

* [StencilSwiftKit 2.7.1](https://github.com/SwiftGen/StencilSwiftKit/blob/2.7.1/CHANGELOG.md)
* [Stencil 0.13.1](https://github.com/kylef/Stencil/blob/0.13.1/CHANGELOG.md)

### Bug Fixes

* IB: Fix missing `import AppKit`/`import UIKit` in some rare cases.  
  [David Jennes](https://github.com/djbe)
  [#515](https://github.com/SwiftGen/SwiftGen/issues/515)
  [#519](https://github.com/SwiftGen/SwiftGen/pull/519)
* IB: Fix issue with segues-swift4 template when compiled with Swift 4.2 on macOS.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#515](https://github.com/SwiftGen/SwiftGen/issues/515)
  [#518](https://github.com/SwiftGen/SwiftGen/pull/518)
* SPM/Mint: Update the Stencil version to 0.13.1.  
  [David Jennes](https://github.com/djbe)
  [#527](https://github.com/SwiftGen/SwiftGen/pull/527)
* Ensure the `templates` subcommand properly works with the deprecated `storyboards` subcommand.  
  [David Jennes](https://github.com/djbe)
  [#525](https://github.com/SwiftGen/SwiftGen/issues/525)
  [#530](https://github.com/SwiftGen/SwiftGen/pull/530)
* Ensure configuration file errors show as red in Xcode.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#516](https://github.com/SwiftGen/SwiftGen/issues/516)
  [#533](https://github.com/SwiftGen/SwiftGen/pull/533)
* Strings: Ensure the parser correctly handles keys ending with a `.` and empty key components.  
  [David Jennes](https://github.com/djbe)
  [#528](https://github.com/SwiftGen/SwiftGen/issues/528)
  [#531](https://github.com/SwiftGen/SwiftGen/pull/531)

### Internal Changes

* Integrated Danger to help on contributions by giving automatic feedback.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#520](https://github.com/SwiftGen/SwiftGen/issues/520)
  [#524](https://github.com/SwiftGen/SwiftGen/issues/524)

## 6.0.0

⚠️ This major version is a big milestone in which a lot of refactoring and cleaning has been done. Many features added over previous releases have been reworked and unified, while also preparing SwiftGen for future additions. This means that you'll need to adapt your configuration files (or command line invocations) and custom templates to work with this new major version.

Read the [SwiftGen 6.0 Migration Guide](Documentation/MigrationGuide.md#migrating-to-swiftgen-60) for a list of changes you'll need to apply.

### Changes in core dependencies of SwiftGen

* [StencilSwiftKit 2.7.0](https://github.com/SwiftGen/StencilSwiftKit/blob/2.7.0/CHANGELOG.md)
* [Stencil 0.13.1](https://github.com/kylef/Stencil/blob/0.13.1/CHANGELOG.md)

### Breaking Changes

* Don't normalize string keys while parsing, let all transformation be done on template side. This makes the developer responsible to keep the language file organized, duplications won't be removed.  
  [Diego Chohfi](https://github.com/dchohfi)
  [#257](https://github.com/SwiftGen/SwiftGen/issues/257)
* Remove Swift 2 support.  
  [David Jennes](https://github.com/djbe)
  [#420](https://github.com/SwiftGen/SwiftGen/pull/420)
* Renamed the `storyboards` command to `ib`, to better reflect it's purpose. An alias for `storyboards` still exists, but it will be removed at some point.  
  [David Jennes](https://github.com/djbe)
  [#423](https://github.com/SwiftGen/SwiftGen/pull/423)
* XCAssets: the generated templates won't namespace groups by default anymore, use the `forceProvidesNamespaces` flag to enable this behaviour again.  
  [jechris](https://github.com/pjechris)
  [#453](https://github.com/SwiftGen/SwiftGen/issues/453)
* XCAssets: the templates won't generate any all-values accessors anymore by default. Use the `allValues` flag to enable this behaviour again. Note: this replaces the old `noAllValues` flag (with an inverse behaviour).  
  [David Jennes](https://github.com/djbe)
  [#480](https://github.com/SwiftGen/SwiftGen/pull/480)
* XCAssets: Dropped the deprecated `allValues` constant, use the type specific constants such as `allColors`, `allDataItems` and `allImages`. The default value of `imageAlias` has also been changed from `Image` to `AssetImageTypeAlias`, to be consistent with the other types.  
  [David Jennes](https://github.com/djbe)
  [#482](https://github.com/SwiftGen/SwiftGen/pull/482)
* Interface Builder: split up the storyboards template into 2 parts, one for scenes and one for segues.  
  [David Jennes](https://github.com/djbe)
  [#419](https://github.com/SwiftGen/SwiftGen/pull/419)

### New Features

* Add ability to list all custom fonts and register them using `FontFamily.registerAllCustomFonts`.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#394](https://github.com/SwiftGen/SwiftGen/issues/394)
* Add support for Swift Package Manager and Mint.  
  [Yonas Kolb](https://github.com/yonaskolb)
  [#411](https://github.com/SwiftGen/SwiftGen/pull/411)
* The `swiftgen.yml` config file now accepts multiple outputs for each parser, allowing you to generate multiple outputs from the same files and content. This also means that the `output` parameter is now deprecated, in favour of the `outputs` parameter, and it may be removed in a future version of SwiftGen. Similarly, the `paths` parameter has been renamed to `inputs` for consistency. You can always use `swiftgen config lint` to validate your configuration file.  
  [David Jennes](https://github.com/djbe)
  [#424](https://github.com/SwiftGen/SwiftGen/pull/424)
  [#510](https://github.com/SwiftGen/SwiftGen/pull/510)
* Use `swiftlint:disable all` in generated files to avoid interference with SwiftLint rules custom to the host project.  
  [Frederick Pietschmann](https://github.com/fredpi)
  [David Jennes](https://github.com/djbe)
  [#409](https://github.com/SwiftGen/SwiftGen/issues/409)
  [#506](https://github.com/SwiftGen/SwiftGen/issues/506)
* XCAssets: Added support for `NSDataAssets`.  
  [Oliver Jones](https://github.com/orj)
  [#444](https://github.com/SwiftGen/SwiftGen/issues/444)
* Organised the generated code in sections for better readability, with all generated constants at the top of the file.  
  [David Jennes](https://github.com/djbe)
  [Olivier Halligon](https://github.com/AliSoftware)
  [#456](https://github.com/SwiftGen/SwiftGen/pull/456)
  [#481](https://github.com/SwiftGen/SwiftGen/pull/481)
* Added support for JSON, Plist and YAML files using the `swiftgen json`, `swiftgen plist` and `swiftgen yaml` commands. The parsed contexts and the generated files for each parser have been kept quite similar, for easier switching between file formats.  
  [John T McIntosh](https://github.com/johntmcintosh)
  [Toshihiro Suzuki](https://github.com/toshi0383)
  [Peter Livesey](https://github.com/plivesey)
  [David Jennes](https://github.com/djbe)
  [#379](https://github.com/SwiftGen/SwiftGen/pull/379)
  [#359](https://github.com/SwiftGen/SwiftGen/issues/359)
  [#288](https://github.com/SwiftGen/SwiftGen/pull/288)
  [#188](https://github.com/SwiftGen/SwiftGen/pull/188)
  [#493](https://github.com/SwiftGen/SwiftGen/pull/493)
  [#504](https://github.com/SwiftGen/SwiftGen/pull/504)
* Updated the playgrounds with the new `json`, `plist` and `yaml` parsers, and updated the other pages to reflect the template changes.  
  [David Jennes](https://github.com/djbe)
  [#495](https://github.com/SwiftGen/SwiftGen/pull/495)
* We're deprecating the old `--template` CLI option in favor of `--templateName`, to better match the naming of the other options and the configuration file. The old `--template` option will remain until the next major version.  
  [David Jennes](https://github.com/djbe)
  [#509](https://github.com/SwiftGen/SwiftGen/pull/509)

### Bug Fixes

* Fix memory leak in generated code for Fonts.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#394](https://github.com/SwiftGen/SwiftGen/issues/394)
* Interface Builder: ensure the templates handle `GLKViewController`, `AVPlayerViewController` and `NSPageController` correctly.  
  [David Jennes](https://github.com/djbe)
  [#404](https://github.com/SwiftGen/SwiftGen/issues/404)
  [#414](https://github.com/SwiftGen/SwiftGen/pull/414)
* Interface Builder: ensure the parser can handle files with and without "trait variations".  
  [David Jennes](https://github.com/djbe)
  [#367](https://github.com/SwiftGen/SwiftGen/issues/367)
  [#429](https://github.com/SwiftGen/SwiftGen/pull/429)
* Restrict `SceneType` and `InitialSceneType` to UIViewController when not targeting AppKit. When targeting AppKit, remove superfluous `Any`.  
  [Darron Schall](https://github.com/darronschall)
  [#463](https://github.com/SwiftGen/SwiftGen/issues/463)
  [#464](https://github.com/SwiftGen/SwiftGen/pull/464)
* Fonts: disable a warning in generated font files for projects with `conditional_returns_on_newlines` SwiftLint rule enabled.  
  [Ryan Davies](https://github.com/iotize)
  [#436](https://github.com/SwiftGen/SwiftGen/issues/436)
  [#465](https://github.com/SwiftGen/SwiftGen/pull/465)
* Interface Builder: the parser and templates now handle the "Inherit module from target" setting.  
  [David Jennes](https://github.com/djbe)
  [#435](https://github.com/SwiftGen/SwiftGen/issues/435)
  [#485](https://github.com/SwiftGen/SwiftGen/pull/485)
* Strings: the parser now correctly handles formats such as `% d` and `%#x`.  
  [David Jennes](https://github.com/djbe)
  [#502](https://github.com/SwiftGen/SwiftGen/pull/502)
* Strings: ensure strings without arguments are not processed using `String(format:)`.  
  [David Jennes](https://github.com/djbe)
  [#503](https://github.com/SwiftGen/SwiftGen/pull/503)

### Internal Changes

* Migrated to CircleCI 2.0.  
  [David Jennes](https://github.com/djbe)
  [#403](https://github.com/SwiftGen/SwiftGen/pull/403)
* Switched to using SwiftLint via CocoaPods instead of our own install scripts.  
  [David Jennes](https://github.com/djbe)
  [#401](https://github.com/SwiftGen/SwiftGen/pull/401)
* Enabled some extra SwiftLint rules for better code consistency.  
  [David Jennes](https://github.com/djbe)
  [#402](https://github.com/SwiftGen/SwiftGen/pull/402)
  [#476](https://github.com/SwiftGen/SwiftGen/pull/476)
* Updated to latest Xcode (10.0.0) and Swift 4.2.  
  [David Jennes](https://github.com/djbe)
  [#415](https://github.com/SwiftGen/SwiftGen/pull/415)
  [#498](https://github.com/SwiftGen/SwiftGen/pull/498)
* Update to Stencil 0.13.0, and use some of it's new filters in our templates.  
  [David Jennes](https://github.com/djbe)
  [#416](https://github.com/SwiftGen/SwiftGen/pull/416)
  [#475](https://github.com/SwiftGen/SwiftGen/pull/475)
  [#498](https://github.com/SwiftGen/SwiftGen/pull/498)
* Store testing contexts as YAML files instead of PLISTs.  
  [David Jennes](https://github.com/djbe)
  [#418](https://github.com/SwiftGen/SwiftGen/pull/418)
  [#461](https://github.com/SwiftGen/SwiftGen/pull/461)
* Refactor the parsers as they're getting more complex.  
  [David Jennes](https://github.com/djbe)
  [#417](https://github.com/SwiftGen/SwiftGen/pull/417)
  [#422](https://github.com/SwiftGen/SwiftGen/pull/422)
* Disabled a SwiftLint rule for function parameter count.  
  [Oleg Gorbatchev](https://github.com/gorbat-o)
  [#428](https://github.com/SwiftGen/SwiftGen/pull/428)
* Fix missing link in the README.  
  [Takeshi Fujiki](https://github.com/takecian)
  [#459](https://github.com/SwiftGen/SwiftGen/issues/459)

## 5.3.0

### Changes in core dependencies of SwiftGen

* [StencilSwiftKit 2.4.0](https://github.com/SwiftGen/StencilSwiftKit/blob/2.4.0/CHANGELOG.md)
* [Stencil 0.10.1](https://github.com/kylef/Stencil/blob/0.10.1/CHANGELOG.md)

### New Features

* XCAssets: exposed getter for image name string.  
  [Abbey Jackson](https://github.com/abbeyjackson)
  [SwiftGen/templates#85](https://github.com/SwiftGen/templates/pull/85)
* XCAssets: exposed getter for color name string.  
  [Stephan Diederich](https://github.com/diederich)
  [SwiftGen/templates#87](https://github.com/SwiftGen/templates/pull/87)
* Allows to set all properties as `public` by using `--param publicAccess` on all templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [SwiftGen/templates#84](https://github.com/SwiftGen/templates/pull/84)
  [Txai Wieser](https://github.com/txaiwieser)
  [SwiftGen/templates#81](https://github.com/SwiftGen/templates/pull/81)

### Internal Changes

* Merged the `SwiftGenKit` and `templates` repositories back into this repository for easier development and maintenance.  
  [David Jennes](https://github.com/djbe)
  [#356](https://github.com/SwiftGen/SwiftGen/pull/356)

## 5.2.1

### Bug Fixes

* Fix SwiftGen no longer working using CLI parameters (instead of config file).  
  [David Jennes](https://github.com/djbe)
  [#347](https://github.com/SwiftGen/SwiftGen/pull/347)
* Errors now properly exit with a non-zero exit code.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#348](https://github.com/SwiftGen/SwiftGen/pull/348)
* `swiftgen --help` prints the full help back again
  (and not just the help of the default `config run` subcommand).  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#349](https://github.com/SwiftGen/SwiftGen/pull/349)

## 5.2.0

### Changes in core dependencies of SwiftGen

* [SwiftGenKit 2.1.1](https://github.com/SwiftGen/SwiftGenKit/blob/2.1.1/CHANGELOG.md)
* [StencilSwiftKit 2.3.0](https://github.com/SwiftGen/StencilSwiftKit/blob/2.3.0/CHANGELOG.md)
* [templates 2.2.0](https://github.com/SwiftGen/templates/blob/2.2.0/CHANGELOG.md)

### New Features

* You can now use a `swiftgen.yml` file to configure SwiftGen! 🎉  
  Read more about it [in the dedicated documentation](Documentation/ConfigFile.md).  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#337](https://github.com/SwiftGen/SwiftGen/pull/337)
* Storyboards: Added a new `ignoreTargetModule` parameter if you're using storyboards in multiple targets, to avoid issues with the generated code.  
  [Julien Quéré](https://github.com/juli1quere)
  [SwiftGen/templates#36](https://github.com/SwiftGen/templates/pull/36)

### Bug Fixes

* Fixes an issue in High Sierra where the output of the processed Catalog Entries was not ordered alphabetically.  
  [Yusuke Kuroiwa](https://github.com/wakinchan)
  [Francisco Diaz](https://github.com/fdiaz)
  [SwiftGen/SwiftGenKit#57](https://github.com/SwiftGen/SwiftGenKit/pull/57)
* Fonts: fix code which checks if a font is already registered.  
  [Vladimir Burdukov](https://github.com/chipp)
  [SwiftGen/templates#77](https://github.com/SwiftGen/templates/pull/77)
* SwiftLint rules: Disabled the `superfluous_disable_command` rule
  for all `swiftlint:disable` exceptions in all templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [SwiftGen/SwiftGen#334](https://github.com/SwiftGen/SwiftGen/issues/334)
  [SwiftGen/templates#83](https://github.com/SwiftGen/templates/pull/83)
* When installing SwiftGen via CocoaPods, the unneeded `file.zip` is not kept in `Pods/SwiftGen/` anymore _(freeing ~5MB on each install of SwiftGen made via CocoaPods!)_.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#342](https://github.com/SwiftGen/SwiftGen/pull/342)

## 5.1.2

### Internal Changes

* Allows the SwiftGen source code to be built with Xcode 9.
  This also has the nice side-effect of making the homebrew installation of SwiftGen also available for macOS 10.13.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [David Jennes](https://github.com/djbe)
  [#330](https://github.com/SwiftGen/SwiftGen/issues/330)
  [SwiftGen/Eve#10](https://github.com/SwiftGen/Eve/pull/10)

## 5.1.1

### Changes in core dependencies of SwiftGen

* [templates 2.1.1](https://github.com/SwiftGen/templates/blob/2.1.1/CHANGELOG.md)

### Bug Fixes

* XCAssets: fixed some compatibility issues with the swift 3 template on Xcode 8, and with other templates.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates#76](https://github.com/SwiftGen/templates/pull/76)

## 5.1.0

### Changes in core dependencies of SwiftGen

* [SwiftGenKit 2.1.0](https://github.com/SwiftGen/SwiftGenKit/blob/2.1.0/CHANGELOG.md)
* [StencilSwiftKit 2.1.0](https://github.com/SwiftGen/StencilSwiftKit/blob/2.1.0/CHANGELOG.md)
* [templates 2.1.0](https://github.com/SwiftGen/templates/blob/2.1.0/CHANGELOG.md)

### New Features

* Added Swift 4 templates. Use `-t swift4` or whatever variant you want to use
  (see `swiftgen templates list` for the available names).  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates/#67](https://github.com/SwiftGen/templates/pull/67)
* XCAssets: Added support for named colors. When using `swiftgen xcassets` the bundled templates
  will now also include colors found in the Asset Catalog in addition to the images.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates/#68](https://github.com/SwiftGen/templates/pull/68)
* Fonts: the path to fonts will now default to just the font filename, but you can disable
  this behaviour by enabling the `preservePath` parameter.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates/#71](https://github.com/SwiftGen/templates/pull/71)
* Colors: new template that uses `#colorLiteral`s.  
  Use `swiftgen colors -t literals-swift3` / `swiftgen colors -t literals-swift4` to use them.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates/#72](https://github.com/SwiftGen/templates/pull/72)

## 5.0.0

⚠️ This major version is a big milestone in which a lot of refactoring and cleaning has been done. Many features added over previous releases have been reworked and unified, while also preparing SwiftGen for future additions. This means that you'll need to adapt your command line invocations and custom templates to work with this new major version.

Read the [SwiftGen 5.0 Migration Guide](Documentation/MigrationGuide.md#migrating-to-swiftgen-50) for a list of changes you'll need to apply.

### Changes in core dependencies of SwiftGen

* [SwiftGenKit 2.0.0](https://github.com/SwiftGen/SwiftGenKit/blob/2.0.0/CHANGELOG.md)
* [StencilSwiftKit 2.0.0](https://github.com/SwiftGen/StencilSwiftKit/blob/2.0.0/CHANGELOG.md)
* [Stencil 0.9.0](https://github.com/kylef/Stencil/blob/0.9.0/CHANGELOG.md)
* [templates 2.0.0](https://github.com/SwiftGen/templates/blob/2.0.0/CHANGELOG.md)

### Breaking Changes

* Removed deprecated CLI options. Please consult the migration guide should you still use them.  
  [David Jennes](https://github.com/djbe)
  [#301](https://github.com/SwiftGen/SwiftGen/issues/301)
* Disable default value for named template option and ensure that there is a template option.  
  [Liquidsoul](https://github.com/liquidsoul)
  [#283](https://github.com/SwiftGen/SwiftGen/issues/283)
* Templates are now grouped by parser on the filesystem. This is only important if you had custom templates in the `Application Support` directory. To migrate your templates, place them in a subfolder with the name of the parser, and remove the prefix of the template filename.  
  [David Jennes](https://github.com/djbe)
  [#304](https://github.com/SwiftGen/SwiftGen/issues/304)
* The `images` command has been renamed to `xcassets` to better reflect its functionality.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#317](https://github.com/SwiftGen/SwiftGen/issues/317)

#### Notable breaking changes from other SwiftGen repositories

* Many deprecated templates have been removed (or merged), and others have been renamed to reflect new behaviours. Please check the [templates migration guide](Documentation/templates/MigrationGuide.md#deprecated-templates-in-20-swiftgen-50) for more information.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates#47](https://github.com/SwiftGen/templates/issues/47)
* There have been some breaking changes in the generated code for storyboards. Please check the [templates migration guide](Documentation/templates/MigrationGuide.md#deprecated-templates-in-20-swiftgen-50) for more information, where we also provide a compatibility template.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [SwiftGen/templates#65](https://github.com/SwiftGen/templates/issues/65)
* Removed deprecated template context variables, and restructured many others. Please check the [SwiftGenKit migration guide](Documentation/SwiftGenKit%20Contexts/MigrationGuide.md#swiftgenkit-20-swiftgen-50-migration-guide) for more information.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/SwiftGenKit#5](https://github.com/SwiftGen/SwiftGenKit/issues/5)
* Some filters have been removed in favour of Stencil's built in versions, and other filters have been updated to accept parameters. Please consult the [StencilSwiftKit migration guide](https://github.com/SwiftGen/StencilSwiftKit/blob/stable/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50) for more information.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/StencilSwiftKit#5](https://github.com/SwiftGen/StencilSwiftKit/issues/5)
  [SwiftGen/StencilSwiftKit#6](https://github.com/SwiftGen/StencilSwiftKit/issues/6)

### New Features

* Colors and strings commands now accept multiple input files. With these 2 additions, all swiftgen generator commands are able to handle multiple input files.  
  [David Jennes](https://github.com/djbe)
  [#313](https://github.com/SwiftGen/SwiftGen/issues/313)
  [SwiftGen/SwiftGenKit#40](https://github.com/SwiftGen/SwiftGenKit/issues/40)
  [SwiftGen/SwiftGenKit#41](https://github.com/SwiftGen/SwiftGenKit/issues/41)

### Internal Changes

* Improved installation instructions in the README.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#303](https://github.com/SwiftGen/SwiftGen/issues/303)

#### Notable internal changes from other SwiftGen repositories

* Switch back from `actool` to an internal parser to fix numerous issues with the former. This fixes issues a few people encountered when using asset catalogs that contained some of the less common set types.  
  [David Jennes](https://github.com/djbe)
  [#228](https://github.com/SwiftGen/SwiftGen/issues/228)
  [SwiftGen/SwiftGenKit#43](https://github.com/SwiftGen/SwiftGenKit/issues/43)

## 4.2.1

### Changes in core dependencies of SwiftGen

* [SwiftGenKit 1.1.0](https://github.com/SwiftGen/SwiftGenKit/blob/1.1.0/CHANGELOG.md)
* [StencilSwiftKit 1.0.2](https://github.com/SwiftGen/StencilSwiftKit/blob/1.0.2/CHANGELOG.md)
* [Stencil 0.9.0](https://github.com/kylef/Stencil/blob/0.9.0/CHANGELOG.md)
* [templates 1.1.0](https://github.com/SwiftGen/templates/blob/1.1.0/CHANGELOG.md)

### Bug Fixes

* Fix a bug in which the version of SwiftGen was reported as `v0.0` by `swiftgen --version`.  
  [Olivier Halligon](https://github.com/AliSoftware)

### Internal Changes

* Update StencilGenKit to 1.0.2 and update Circle CI to Xcode 8.3.  
  [Diogo Tridapalli](https://github.com/diogot)
  [#295](https://github.com/SwiftGen/SwiftGen/issues/295)
* Switch from Travis CI to Circle CI, clean up the Rakefile in the process.  
  [David Jennes](https://github.com/djbe)
  [Olivier Halligon](https://github.com/AliSoftware)
  [#269](https://github.com/SwiftGen/SwiftGen/pull/269)
* Fix remaining enum names not Swift 3 compliant.  
  [Liquidsoul](https://github.com/liquidsoul)
  [#297](https://github.com/SwiftGen/SwiftGen/issues/297)
* Added the `CONTRIBUTING.md` file to help new contributors.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [Cihat Gündüz](https://github.com/Dschee)
  [#149](https://github.com/SwiftGen/SwiftGen/pull/149)
  [#298](https://github.com/SwiftGen/SwiftGen/pull/298)

## 4.2.0

### Changes in core dependencies of SwiftGen

* [SwiftGenKit 1.0.1](https://github.com/SwiftGen/SwiftGenKit/blob/1.0.1/CHANGELOG.md)
* [StencilSwiftKit 1.0.0](https://github.com/SwiftGen/StencilSwiftKit/blob/1.0.0/CHANGELOG.md)
* [Stencil 0.8.0](https://github.com/kylef/Stencil/blob/0.8.0/CHANGELOG.md)
* [templates 1.0.0](https://github.com/SwiftGen/templates/blob/1.0.0/CHANGELOG.md)

### New Features

* You can now pass custom parameters to your templates using the `--param X=Y` syntax.  
  [@djbe](https://github.com/djbe)
  [#265](https://github.com/SwiftGen/SwiftGen/pull/265/commits/3a7971ccbf16c41f0b2341e71b8a1ffbcabebecf)
  * This command-line option can be repeated at will and used to pass structured custom parameters (e.g. `--param tabs=2 --param foo.bar=1 --param foo.baz=2`).  
  * You can then use them in your templates using e.g. `{{param.tabs}}`, `{{param.foo.bar}}` & `{{param.foo.baz}}`.  
* Templates can now access environment variables via the `env` key of the Stencil context (e.g. `{{env.USER}}`, `{{env.LANG}}`).  
  [@djbe](https://github.com/djbe)
  [#265](https://github.com/SwiftGen/SwiftGen/pull/265/commits/3a7971ccbf16c41f0b2341e71b8a1ffbcabebecf)
  * This is especially useful when integrating SwiftGen as a Script Build Phase in your Xcode project as you can then access Xcode Build Settings exposed as
  environment variables by Xcode, e.g. `{{env.PRODUCT_MODULE_NAME}}`.  

#### Notable new features from other SwiftGen repositories

* Use an explicit bundle parameter to support frameworks for all templates.  
  [@NachoSoto](https://github.com/NachoSoto)
  [@djbe](https://github.com/djbe)
  [#255](https://github.com/SwiftGen/SwiftGen/pull/255)
  [SwiftGen/templates#17](https://github.com/SwiftGen/templates/pull/17)

### Deprecations

In preparation for an upcoming cleanup of SwiftGen to remove some legacy code as well as Stencil old variables, tags and filters, and change the default templates to Swift 3, **some things are being deprecated and will be removed in the next major version 5.0**.

As a result, if you wrote custom templates, you should already prepare for the upcoming 5.0 by migrating your templates to use the new variables (already avaiable in SwiftGen 4.2 / SwiftGenKit 1.0).

See [#244](https://github.com/SwiftGen/SwiftGen/issues/244) and [the Migration Guide](Documentation/MigrationGuide.md) for a list of deprecations and their replacements.

### Bug Fixes

#### Notable bug fixes from other SwiftGen repositories

* Storyboards templates won't `import` your app module anymore,
  removing that annoying warning.  
  [@djbe](https://github.com/djbe)
  [SwiftGen/templates#19](https://github.com/SwiftGen/templates/pull/19)

### Internal changes

* SwiftGen has migrated to [its own GitHub organization](https://github.com/SwiftGen/SwiftGen) 🎉.  
* SwiftGen has been split in multiple repositories and separate modules.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [@djbe](https://github.com/djbe)
  [#240](https://github.com/SwiftGen/SwiftGen/issues/240)
  [#265](https://github.com/SwiftGen/SwiftGen/pull/265)
  * The present [SwiftGen](https://github.com/SwiftGen/SwiftGen) is the CLI parsing. It is in charge of calling the frameworks, feeding them appropriate parameters according to the command line arguments.
  * [SwiftGenKit](https://github.com/SwiftGen/SwiftGenKit) is the framework responsible for parsing your assets/resources and turning them into a structured representation compatible with `Stencil` templates.
  * [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) is a framework adding some extensions to the template engine [Stencil](https://github.com/kylef/Stencil) used by SwiftGen. It adds some tags and filters as well as convenience methods shared both by SwiftGen itself and by [Sourcery](https://github.com/krzysztofzablocki/Sourcery).
  * The SwiftGen templates has been moved into [a dedicated templates repo](https://github.com/SwiftGen/templates) so they can evolve and be unit-tested separately of SwiftGen.

Note: The next minor version will focus on bringing more documentation for all this new structure and improve ease of future contributions.

## 4.1.0

### New Features

* Added a script reference to simplify and automate localization of existing non localized project.  
  [HuguesBR](https://github.com/HuguesBR)
* Added a `storyboards-osx-swift3` template.  
  [Felix Lisczyk](https://github.com/FelixII)
  [#225](https://github.com/SwiftGen/SwiftGen/pull/225)
* Added a `strings-no-comments-swift3` template that does not include the
  default translation of each key.  
  [Loïs Di Qual](https://github.com/ldiqual)
  [#222](https://github.com/SwiftGen/SwiftGen/issues/222)
* Images: new dot-syntax template, use `dot-syntax-swift3` or `dot-syntax` (for
  Swift 2.3).  
  [David Jennes](https://github.com/djbe)
  [#206](https://github.com/SwiftGen/SwiftGen/pull/206)
* Reworked the "dot-syntax" and "structured" templates to use the new `macro`
  and `call` tags, which greatly simplifies the templates, and also removes the
  limitation of 5-level deep structures.  
  [David Jennes](https://github.com/djbe)
  [#237](https://github.com/SwiftGen/SwiftGen/pull/237)
* Storyboards: automatically detect the correct modules that need to be
  imported. The `--import` option has therefore been deprecated, as well as the
  `extraImports` template variable. Instead use the the new `modules` variable,
   which offers the same functionality.  
  [David Jennes](https://github.com/djbe)
  [#243](https://github.com/SwiftGen/SwiftGen/pull/243)
* Support multiple input paths for some commands.  
  [David Jennes](https://github.com/djbe)
  [#213](https://github.com/SwiftGen/SwiftGen/pull/213)
  * `fonts` accepts multiple input directories, all found fonts will be added
    to the `families` template variable.
  * `images` now supports multiple asset catalogs as input. Templates can now
    use the `catalogs` variable to access each individual catalog.
  * `storyboards` accepts multiple paths (to folders or `storyboard` files).
    All found storyboards will be available in the `storyboards` template
    variable.

### Bug Fixes

* Strings: fix issue with `dot-syntax-swift3` where function definitions were
  not Swift 3 guidelines compliant.  
  [David Jennes](https://github.com/djbe)
  [#241](https://github.com/SwiftGen/SwiftGen/issues/241)
  [#247](https://github.com/SwiftGen/SwiftGen/pull/247)
* Snake cased keys with uppercase letters are correctly camel cased again.  
  [Cihat Gündüz](https://github.com/Dschee)
  [#226](https://github.com/SwiftGen/SwiftGen/issues/226)
  [#233](https://github.com/SwiftGen/SwiftGen/pull/233)

### Internal changes

* Better error handling in the `colors` command.  
  [David Jennes](https://github.com/djbe)
  [#227](https://github.com/SwiftGen/SwiftGen/pull/227)
* Stencil: added two new tags `macro` and `call`, see the
  [documentation](https://github.com/SwiftGen/SwiftGen/blob/4.1.0/documentation/Templates.md). for in depth explanations on how
  to use them.  
  [David Jennes](https://github.com/djbe)
  [#237](https://github.com/SwiftGen/SwiftGen/pull/237)
* SwiftLint: Remove `switch_case_on_newline` warning for generated color file.  
  [Mickael Titeca](https://github.com/MickaCapi)
  [#239](https://github.com/SwiftGen/SwiftGen/pull/239)
* Stencil: better string filter testing and fixed a small issue with
  `lowerFirstWord`.  
  [David Jennes](https://github.com/djbe)
  [#245](https://github.com/SwiftGen/SwiftGen/pull/245)

## 4.0.1

### Bug Fixes

* Escape newlines again in .strings file keys.  
  [ChristopherRogers](https://github.com/ChristopherRogers)
  [#208](https://github.com/SwiftGen/SwiftGen/pull/208)
* Fix broken `import` option added in 4.0.0.  
  [David Jennes](https://github.com/djbe)
  [#214](https://github.com/SwiftGen/SwiftGen/pull/214)
* Show an error when the provided path to the `images` command is not an asset
  catalog.  
  [David Jennes](https://github.com/djbe)
  [#217](https://github.com/SwiftGen/SwiftGen/pull/217)
* Strings dot-syntax template: use `enum`s for namespacing instead of `struct`s.  
  [David Jennes](https://github.com/djbe)
  [#218](https://github.com/SwiftGen/SwiftGen/pull/218)

### Internal changes

* Swift 3 migration.  
  [ahtierney](https://github.com/ahtierney)
  [#201](https://github.com/SwiftGen/SwiftGen/pull/201)
* Restructure the SwiftGen project to build as an `.app` during
  developement, for easier debugging in Xcode.  
  [ahtierney](https://github.com/ahtierney)
  [#204](https://github.com/SwiftGen/SwiftGen/pull/204)
* Consolidate the use of PathKit internally.  
  [David Jennes](https://github.com/djbe)
  [#212](https://github.com/SwiftGen/SwiftGen/pull/212)
* Updated Stencil to [0.7.2](https://github.com/kylef/Stencil/releases/tag/0.7.0).  
  [Kyle Fuller](https://github.com/kylef)
  [#216](https://github.com/SwiftGen/SwiftGen/issues/216)

## 4.0.0

### Breaking Changes

* Change swift 3 storyboard segue template's sender from `AnyObject` to `Any`.  
  [Derek Ostrander](https://github.com/dostrander)
  [#197](https://github.com/SwiftGen/SwiftGen/pull/197)
* Fix swift 3 storyboard templates to be compliant with swift 3 api design guidelines.  
  [Afonso](https://github.com/afonsograca)
  [#194](https://github.com/SwiftGen/SwiftGen/pull/194)
* Remove the `key` param label from the `tr` function for Localized String in the Swift 3 template.  
  [AndrewSB](https://github.com/AndrewSB)
  [#190](https://github.com/SwiftGen/SwiftGen/pull/190)
* The `swiftgen images` command now uses the `actool` utility to parse asset catalogs,
  ensuring that the parser correctly handles namespaced folders.  
  ⚠️ Note that you now have to specify the exact path to your `.xcassets` assets catalogs
  when using `swiftgen images` (and not just a directory to parse).  
  [David Jennes](https://github.com/djbe)
  [#199](https://github.com/SwiftGen/SwiftGen/pull/199)

### New Features

* Add support for multiline strings in `*.strings` file.  
  [Jeong Yonguk](https://github.com/alldne)
  [#192](https://github.com/SwiftGen/SwiftGen/pull/192)
* Add option to add import statements at the top of the generated swift file (for
  storyboards) using the `import` flag.  
  [David Jennes](https://github.com/djbe)
  [#175](https://github.com/SwiftGen/SwiftGen/pull/175)
* Escape reserved swift keywords in the structured and dot-syntax generated strings code.  
  [Afonso](https://github.com/afonsograca)
  [#198](https://github.com/SwiftGen/SwiftGen/pull/198)

## 3.0.1

* Add support for Xcode 8 and Swift 2.3.  
  _(Should still compile in Xcode 7.3 but the `Rakefile` to build, install and release requires Xcode 8)_.  
  [Valentin Knabel](https://github.com/vknabel)
  [Ignacio Romero Zurbuchen](https://github.com/dzenbot)
  [HanxuanZhou](https://github.com/GenoZhou)
  [Syo Ikeda](https://github.com/ikesyo)


## 3.0.0

* Add template that calls `NSLocalizedString()` separately for each string,
  which is useful when trying to extract strings in the app to a `.strings` file.  
  [Ahmet Karalar](https://github.com/akaralar)
* Add some `file_length` and similar SwiftLint exceptions in bundled templates, as
  files generated by SwiftGen might contain lots of constants and can be long by design.  
  [Olivier Halligon](https://github.com/AliSoftware)
* Error messages ("template not found", etc) are now printed on `stderr`.  
  [Olivier Halligon](https://github.com/AliSoftware)
* Add more `swiftgen templates` subcommands.  
  [Olivier Halligon](https://github.com/AliSoftware)
  * `swiftgen templates list` lists all the available templates
  * `swiftgen templates which <name>` prints the path to the template named `<name>`
  * `swiftgen templates cat <name>` prints the content to the template named `<name>`
  * `<name>` here can be either a parser name like `colors` or a
    composed name `colors-rawValue` for a specific template.
* Fix swift 3 renaming change in strings-swift3.stencil.  
  [Kilian Koeltzsch](https://github.com/kiliankoe)
  [#150](https://github.com/SwiftGen/SwiftGen/pull/150)
* Fix non-custom class, non-base view controller handling in storyboards-swift3.stencil.  
  [Syo Ikeda](https://github.com/ikesyo)
  [#152](https://github.com/SwiftGen/SwiftGen/pull/152)
* Add strongly typed `initialViewController()` overrides for storyboard templates if available.  
  [Syo Ikeda](https://github.com/ikesyo)
  [#153](https://github.com/SwiftGen/SwiftGen/pull/153)
  [#163](https://github.com/SwiftGen/SwiftGen/pull/163)
* Add support for font files containing multiple descriptors.  
  [Chris Ellsworth](https://github.com/chrisellsworth)
  [#156](https://github.com/SwiftGen/SwiftGen/pull/156)
* Update deprecated usage of generics for Swift 3 / Xcode 8 beta 6.  
  [Chris Ellsworth](https://github.com/chrisellsworth)
  [#158](https://github.com/SwiftGen/SwiftGen/pull/158)
* Fix case when missing positional parameters, which leads to parameters in the enum with
  unspecified type (undeterminable from the `Localizable.strings` format analysis) where
  reported as `Any` — which is not a `CVarArgType`. Now using `UnsafePointer<()>`
  arguments instead for such odd edge-cases that should never happen anyway.  
  [Olivier Halligon](https://github.com/AliSoftware)
* Now reports an error when it failed to parse a color in a color input file.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#162](https://github.com/SwiftGen/SwiftGen/issues/162)
* New Strings template (available via `-t dot-syntax`), allowing string keys containing dots (like foo.bar.baz) to be organized as a hierarchy and accessible via dot syntax.  
  [Cihat Gündüz](https://github.com/Dschee)
  [#159](https://github.com/SwiftGen/SwiftGen/pull/159)
* Update Swift 3 templates to use lowercase enums.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#166](https://github.com/SwiftGen/SwiftGen/pull/166)
* New Strings template (available via `-t dot-syntax-swift3`), allowing keys with dots in Swift 3 (see above).  
  [Cihat Gündüz](https://github.com/Dschee)
  [#168](https://github.com/SwiftGen/SwiftGen/pull/168)

> 💡 You can now **create your custom templates more easier than ever**, by cloning an existing template!
>
> e.g. to clone [the default `strings-default.stencil` template](https://github.com/SwiftGen/SwiftGen/blob/3.0.0/templates/strings-default.stencil):
>
> * use `swiftgen templates cat strings --output strings-custom.stencil`
> * modify the cloned `strings-custom.stencil` template to your liking
> * use it with `swiftgen strings … --templatePath strings-custom.stencil …` in your projects!

### Important Notes

- Some keys for various templates have changed to provide more flexibility and enable some new features in the templates. As a result, **if you created your own custom templates, they might not all be totally compatible with SwiftGen 3.0.0** (hence the new major version).
Please read the [Custom Templates documentation](https://github.com/SwiftGen/SwiftGen/blob/4.1.0/documentation/Templates.md) to find out the new Stencil context keys and update your custom templates accordingly.

_If you're using one of the bundled templates, all of them have been updated appropriately._

- Also **if you use Swift 3**, and thus use the `-t swift3` flag to use the Swift 3 templates, be advised those has been modified to take the latest Swift 3 modifications into account (including naming convensions) so your code might need to be updated according to match the latest Swift 3 recommendations.

## 2.0.0

* Fix issue with txt files bailing on comments.  
  [Derek Ostrander](https://github.com/dostrander)
  [#140](https://github.com/SwiftGen/SwiftGen/issues/140)
* Added support for tvOS and watchOS in images, fonts and color templates.  
  [Tom Baranes](https://github.com/tbaranes)
  [#145](https://github.com/SwiftGen/SwiftGen/pull/145)
* Added enum-based structured identifiers via `-t structured` option.  
  [Cihat Gündüz](https://github.com/Dschee)
  [#148](https://github.com/SwiftGen/SwiftGen/pull/148)  
* Added support for OSX in storyboards.  
  [Tom Baranes](https://github.com/tbaranes)
  [#131](https://github.com/SwiftGen/SwiftGen/pull/131)

Note: The `Stencil` context keys (the name of the variables used in templates) for storyboard has changed a bit.
Especially, `class` has been renamed into `customClass` (see [#131](https://github.com/SwiftGen/SwiftGen/pull/131))
to better describe the intent (as this isn't defined if there is no _custom_ class set in the Storyboard), and
new keys `isBaseViewController` and `baseType` has been added.

This means that if you did implement your own custom templates for storyboards (instead of using the bundled ones),
you'll have to remplace `{{class}}` by `{{customClass}}` in those storyboard templates, otherwise they'll probably
stop working as expected. That's the main reason why the version has been bumped to a major version 2.0.0.


## 1.1.2

* Fix issue introduced by 1.1.1 in storyboard templates not returning.  
  [Ben Chatelain](https://github.com/phatblat)
  [#138](https://github.com/SwiftGen/SwiftGen/pull/138)

## 1.1.1

* Removed the last force-unwrap from storyboard templates.  
  [Olivier Halligon](https://github.com/AliSoftware)

## 1.1.0

* Added step to ensure all templates are [Swiftlint](https://github.com/realm/SwiftLint)'ed
  and don't violate any code style rule.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [AJ9](https://github.com/AJ9)
  [#80](https://github.com/SwiftGen/SwiftGen/pull/80)
* Added support for OSX in images, fonts and color templates.  
  [Tom Baranes](https://github.com/tbaranes)
  [#125](https://github.com/SwiftGen/SwiftGen/pull/125)
  [#126](https://github.com/SwiftGen/SwiftGen/pull/126)
  [#127](https://github.com/SwiftGen/SwiftGen/pull/127)
* Added missing FontConvertible protocol conformance to default fonts template.  
  [Ben Chatelain](https://github.com/phatblat)
  [#129](https://github.com/SwiftGen/SwiftGen/pull/129)

## 1.0.0

* Restructured colors & fonts templates to workaround the same LLVM issue as #112 with nested types
  inside existing UIKit classes in Release/Optimized builds.  
  [Olivier Halligon](https://github.com/AliSoftware)
* Added support for Fonts using the `swiftgen fonts` command.  
  [Derek Ostrander](https://github.com/dostrander)
  [#102](https://github.com/SwiftGen/SwiftGen/pull/102)
* Added support for TXT (`colors.txt`) files to have named value.  
  [Derek Ostrander](https://github.com/dostrander)
  [#118](https://github.com/SwiftGen/SwiftGen/pull/118)
* Restructured image templates to work around an LLVM issue with nested types.  
  [Ken Grigsby](https://github.com/kgrigsby59)
  [#112](https://github.com/SwiftGen/SwiftGen/issues/112)
* Added Swift 3 templates for storyboards and strings.  
  [Andrew Breckenridge](https://github.com/AndrewSB)
  [#117](https://github.com/SwiftGen/SwiftGen/pull/117)

## 0.8.0

* Introducing alternative way to install SwiftGen: using CocoaPods! See README for more details.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#95](https://github.com/SwiftGen/SwiftGen/issues/95)
* Added support for JSON (`colors.json`) files as input for the `swiftgen colors` subcommand.  
  [Derek Ostrander](https://github.com/dostrander)
* Use `String(format:locale:arguments:)` and the `NSLocale.currentLocale()` in the "string" templates so that it works with `.stringdict` files and pluralization.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#91](https://github.com/SwiftGen/SwiftGen/issues/91)
* Add support for Android `colors.xml` files as input for the `swiftgen colors` subcommand.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#15](https://github.com/SwiftGen/SwiftGen/issues/15)
* Removed the useless `import Foundation` from the "images" templates.  
  [Olivier Halligon](https://github.com/AliSoftware)
* Added computed property `var color: UIColor` to the color templates.  
  [Olivier Halligon](https://github.com/AliSoftware)


## 0.7.6

#### Enhancements

* Fixed build loop by changing SwiftGen to only write to the output file if the generated code is different from the file contents.  
  [Mathias Nagler](https://github.com/mathiasnagler)
  [#90](https://github.com/SwiftGen/SwiftGen/pull/90)

#### Fixes

* Fixed typos in code and descriptions: _instanciate_ -> _instantiate_. Please note that the default template used for storyboards `storyboards-default.stencil` had to be modified, so make sure to update your codebase accordingly.  
  [Pan Kolega](https://github.com/pankolega)
  [#83](https://github.com/SwiftGen/SwiftGen/pull/83)
* Fixed issue in `Rakefile` when trying to install via `rake` in a path containing `~`.  
  [Jesse Armand](https://github.com/jessearmand)
  [#88](https://github.com/SwiftGen/SwiftGen/pull/88)

## 0.7.5

#### Enhancements

* Updated stencils and unit tests to pass [SwiftLint](https://github.com/realm/SwiftLint).  
  [Adam Gask](https://github.com/AJ9)
  [#79](https://github.com/SwiftGen/SwiftGen/pull/79)
* Updated `storyboards-default.stencil` to better avoid name confusions.  
  [Olivier Halligon](https://github.com/AliSoftware)
   * Now `cases` names are suffixed with `…Scene` and `static func` are prefixed with `instantiate…` to lower the risks of a name conflict with your ViewController classes.
   * The old template is still available but has been renamed `storyboards-uppercase.stencil`
* Added support for `*.clr` files (files to store `NSColorList`'s presented in Color Picker on "Color Palettes" tab).  
  [Ilya Puchka](https://github.com/ilyapuchka)
  [#81](https://github.com/SwiftGen/SwiftGen/pull/81)

## 0.7.4

#### Enhancements

* Added View Controller Placeholders support.  
  [Viacheslav Karamov](https://github.com/vkaramov/)
  [#61](https://github.com/SwiftGen/SwiftGen/issues/61)

## 0.7.3

#### Fixes

* Restructured storyboard templates to work around an LLVM issue with nested types.  
  [Ryan Booker](https://github.com/ryanbooker)
  [#57](https://github.com/SwiftGen/SwiftGen/issues/57#issuecomment-159996671)

> Scenes and Segues are now referenced via `StoryboardScene.<Storyboard>` and `StoryboardSegue.<Storyboard>.<Segue>`

## 0.7.2

#### Enhancements

* Adding comments to generated color enums which allow you to see the color in the QuickHelp documentation.  

* The default translation of strings are now added as documentation comments to the enum cases.  
  _You can add translations to your own templates by using the `string.translation` variable_.  
  [@MrAlek](https://github.com/MrAlek)
  [#58](https://github.com/SwiftGen/SwiftGen/issues/58)
  [#60](https://github.com/SwiftGen/SwiftGen/pull/60)

#### Fixes

* Fix an issue with the colors template due to an Apple Bug when building in Release and with WMO enabled.  
  [#56](https://github.com/SwiftGen/SwiftGen/issues/56)

## 0.7.1

#### Fixes

* Fix issue with `swiftgen strings` that were using the colors templates instead of the strings template by default.  
  [@ChristopherRogers](https://github.com/ChristopherRogers)
  [#54](https://github.com/SwiftGen/SwiftGen/pull/54)

## 0.7.0

#### Enhancements

* Allow using **custom templates by name**.  
  [#42](https://github.com/SwiftGen/SwiftGen/issues/42)
  [#50](https://github.com/SwiftGen/SwiftGen/pull/50)
  * Now the `-t` flag expect a template name (defaults to `default`), and will search a matching template in `Application Support` first, then in the templates bundled with SwiftGen.  
  * You can still specify a template by path using `-p`.  
  * For more info, see [this dedicated documentation](https://github.com/SwiftGen/SwiftGen/blob/4.1.0/documentation/Templates.md).  
* You can now list all templates available (both bundled templates and custom ones) using the `swiftgen templates` command.  
  [#42](https://github.com/SwiftGen/SwiftGen/issues/42)
  [#50](https://github.com/SwiftGen/SwiftGen/pull/50)
* Add a `performSegue(_:sender:)` extension on `UIViewController` to accept a `StoryboardSegue` as parameter.  
  You can now for example call `vc.performSegue(UIStoryboard.Segue.Wizard.ShowPassword)`.  
  [#37](https://github.com/SwiftGen/SwiftGen/issues/37)

SwiftGen now comes bundled with some alternate templates, especially `colors-rawValue`, `images-allvalues` and `storyboards-lowercase`, in addition to the default templates.

#### Fixes

* Now `swiftgen storyboards` doesn't generate duplicate enum cases for identical segues (those having equal identifiers and shared custom class).  
  [@filwag](https://github.com/filwag)
  [#43](https://github.com/SwiftGen/SwiftGen/pull/43)
* Fix compilation issue for storyboards without any scene.  
  [Viacheslav Karamov](https://github.com/vkaramov/)
  [#47](https://github.com/SwiftGen/SwiftGen/issues/47)
* Propose an alternate template using lowercase names, especially for when storyboard identifiers match view controller class names.  
  [Viacheslav Karamov](https://github.com/vkaramov/)
  [#48](https://github.com/SwiftGen/SwiftGen/issues/48)
* Introduced an `image-allvalues` template that exposes the list of all images in a `static let allValues` array.  
  [Ahmed Mseddi](https://github.com/amseddi)
  & Guillaume Lagorce
  [#44](https://github.com/SwiftGen/SwiftGen/pull/44)
* Fix issue with Storyboards without any StoryboardID (all scenes being anonymous) not extending `StoryboardScene`.  
  [#36](https://github.com/SwiftGen/SwiftGen/issues/36)

## 0.6.0

### New Features: Templates

* `SwiftGen` now uses [Stencil](https://github.com/kylef/Stencil) template engine to produce the generated code.
* This means that the generate code will be easier to improve.
* This also means that **you can use your own templates** to generate code that better suits your needs and preferences, using `swiftgen … --template FILE …`.

### Fixes

* The correct type of _ViewController_ (`UIViewController`, `UINavigationController`, `UITableViewController`, …) is now correctly generated even if not a custom subclass.  
  [#40](https://github.com/SwiftGen/SwiftGen/issues/40)
* Fix issue with `.strings` files encoded in UTF8.  
  [#21](https://github.com/SwiftGen/SwiftGen/issues/21)

## 0.5.2

### New Features

* It's now possible to specify which chars should not be used when generating `case` identifiers.  
  [@Igor-Palaguta](https://github.com/Igor-Palaguta)
  [#34](https://github.com/SwiftGen/SwiftGen/pull/34)

## 0.5.1

#### Fixes

* Installing via `rake install` or `brew install` will now copy the Swift dylibs too, so that `swiftgen` installation won't depend on the location of your Xcode.app (so it'll work on every machine even if you rename your Xcode).
* Fixed links in Playground and Licence headers in source code.

## 0.5.0

#### New Features

* Migrating to [Commander](https://github.com/kylef/Commander) to parse the CLI arguments.  
  [23](https://github.com/SwiftGen/SwiftGen/issues/23)
  [#30](https://github.com/SwiftGen/SwiftGen/issues/30)
* `swiftgen` is now a single binary, and the subcommand names have changed to be more consistent.  
  [#30](https://github.com/SwiftGen/SwiftGen/issues/30)
* New `--output` option.  
  [#30](https://github.com/SwiftGen/SwiftGen/issues/30)

> You must now use the subcommands `swiftgen images`, `swiftgen strings`, `swiftgen storyboards` and `swiftgen colors`. See `swiftgen --help` for more usage info.

#### Fixes

* Fix color parsing with absent alpha.  
  [@Igor-Palaguta](https://github.com/Igor-Palaguta)
  [#28](https://github.com/SwiftGen/SwiftGen/pull/28)

## 0.4.4

* Updated Unit tests for latest Swift 2.0 & tested against Xcode 7.1
* Fix small typos in code
* Guard against empty `enums`  

## 0.4.3

* Updated for Xcode 7 Beta 6.  
  [@Dimentar](https://github.com/Dimentar)
  [#14](https://github.com/SwiftGen/SwiftGen/pull/14)

## 0.4.2

* Added `import Foundation` on top of `swiftgen-l10n` generated code.  
  [@Nick11](https://github.com/Nick11)
  [#12](https://github.com/SwiftGen/SwiftGen/pull/12)

## 0.4.1

* Updated for Xcode 7 Beta 5
* `swiftgen-storyboard` now allows to take a path to a `.storyboard` file as argument (as an alternative to give a path to a whole directory)
* The `-v` and `--version` flags are now recognized and print the executable version.

## 0.4.0

* Reorganized files into an **Xcode project** with one target per executable.  
  [#2](https://github.com/SwiftGen/SwiftGen/issues/2)
* Added **Unit Tests** (one per executable + one for common code).  
  [#2](https://github.com/SwiftGen/SwiftGen/issues/2)
* Improved `SwiftGen-L10n` parsing of format strings and placeholders.  
  [#4](https://github.com/SwiftGen/SwiftGen/issues/4)
  [#5](https://github.com/SwiftGen/SwiftGen/issues/5)
  [#6](https://github.com/SwiftGen/SwiftGen/issues/6)
* Updated `Rakefile` so that it now invokes `xcodebuild install`. You can now easily build & install all `swiftgen-xxx` executables in `/usr/local/bin` or anywhere else.
* Added a **version** string (date + sha1) to the built executables (displayed when invoked with no argument)

## 0.3.0

* Reducted the default code generated by `SwiftGenColorEnumBuilder` to avoid clobbering the `UIColor` namespace
* Changed the "namespacing `enum`" in `UIStoryboard` to a `struct` to avoid confusion with the inner enums
* The `UIStoryboard.Scene` enums now use `static func` instead of `static var` for the dedicated `ViewController` constructors ^(†)

^(†) _because it feels more explicit that calling a function like `UIStoryboard.Scene.Wizard.validatePasswordViewController()` will actually **instantiate** a new `ViewController`, rather than returning an existing one._

## 0.2.0

* Added `Segues` enums to `UIStoryboard` to be able to access their identifiers easily.  
  [@esttorhe](https://github.com/esttorhe)
  [#8](https://github.com/SwiftGen/SwiftGen/pull/8)
* Added this very `CHANGELOG.md`

## 0.1.0

Considered to be the first cleaned-up version, far from finished but really usable with clean code.

* Cleaner README
* Namespace the generated `enums` in an outer `enum` to avoid clobbering the `UIStoryboard` namespace

## 0.0.4

* Introducing `SwiftGenColorEnumBuilder`
* `swiftgen-colors` CLI
* Added ability to choose indentation

## 0.0.3

* Introducing `SwiftGenL10nEnumBuilder`
* `swiftgen-l10n` CLI
* Started playing with `UIColor` enums in the playground

## 0.0.2

* Introducing `SwiftGenStoryboardEnumBuilder` class
* `swiftgen-storyboard` CLI

## 0.0.1

Initial version:

* Mostly testing stuff in a playground
* Introducing `SwiftGenAssetsEnumBuilder` class
* `swiftgen-assets` CLI
