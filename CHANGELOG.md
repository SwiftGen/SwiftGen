# SwiftGen CHANGELOG

---

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

### Changes in other SwiftGen modules

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

### Changes in other SwiftGen modules

* [templates 2.1.1](https://github.com/SwiftGen/templates/blob/2.1.1/CHANGELOG.md)

### Bug Fixes

* XCAssets: fixed some compatibility issues with the swift 3 template on Xcode 8, and with other templates.  
  [David Jennes](https://github.com/djbe) 
  [SwiftGen/templates#76](https://github.com/SwiftGen/templates/pull/76)

## 5.1.0

### Changes in other SwiftGen modules

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

Read the [SwiftGen 5.0 Migration Guide](https://github.com/SwiftGen/SwiftGen/blob/master/Documentation/MigrationGuide.md#swiftgen-50-migration-guide) for a list of changes you'll need to apply.

### Changes in other SwiftGen modules

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
* Templates are now grouped by subcommand on the filesystem. This is only important if you had custom templates in the `Application Support` directory. To migrate your templates, place them in a subfolder with the name of the subcommand, and remove the prefix of the template filename.  
  [David Jennes](https://github.com/djbe)
  [#304](https://github.com/SwiftGen/SwiftGen/issues/304)
* The `images` command has been renamed to `xcassets` to better reflect its functionality.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#317](https://github.com/SwiftGen/SwiftGen/issues/317)

#### Notable breaking changes from other SwiftGen repositories

* Many deprecated templates have been removed (or merged), and others have been renamed to reflect new behaviours. Please check the [templates migration guide](https://github.com/SwiftGen/templates/blob/master/Documentation/MigrationGuide.md#deprecated-templates-in-20-swiftgen-50) for more information.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/templates#47](https://github.com/SwiftGen/templates/issues/47)
* There have been some breaking changes in the generated code for storyboards. Please check the [templates migration guide](https://github.com/SwiftGen/templates/blob/master/Documentation/MigrationGuide.md#deprecated-templates-in-20-swiftgen-50) for more information, where we also provide a compatibility template.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [SwiftGen/templates#65](https://github.com/SwiftGen/templates/issues/65)
* Removed deprecated template context variables, and restructured many others. Please check the [SwiftGenKit migration guide](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/MigrationGuide.md#swiftgenkit-20-swiftgen-50) for more information.  
  [David Jennes](https://github.com/djbe)
  [SwiftGen/SwiftGenKit#5](https://github.com/SwiftGen/SwiftGenKit/issues/5)
* Some filters have been removed in favour of Stencil's built in versions, and other filters have been updated to accept parameters. Please consult the [StencilSwiftKit migration guide](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50) for more information.  
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

### Changes in other SwiftGen modules

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

### Changes in other SwiftGen modules

* [SwiftGenKit 1.0.1](https://github.com/SwiftGen/SwiftGenKit/blob/1.0.1/CHANGELOG.md)
* [StencilSwiftKit 1.0.0](https://github.com/SwiftGen/StencilSwiftKit/blob/1.0.0/CHANGELOG.md)
* [Stencil 0.8.0](https://github.com/kylef/Stencil/blob/0.8.0/CHANGELOG.md)
* [templates 1.0.0](https://github.com/SwiftGen/templates/blob/1.0.0/CHANGELOG.md)

### Bug Fixes

#### Notable bug fixes from other SwiftGen repositories

* Storyboards templates won't `import` your app module anymore,
  removing that annoying warning.  
  [@djbe](https://github.com/djbe)
  [SwiftGen/templates#19](https://github.com/SwiftGen/templates/pull/19)

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

See [#244](https://github.com/SwiftGen/SwiftGen/issues/244) and [the Migration Guide in the Wiki](https://github.com/SwiftGen/SwiftGen/wiki/Migration-Guides) for a list of deprcations and their replacements.

### Internal changes

* SwiftGen has migrated to [its own GitHub organization](https://github.com/SwiftGen/SwiftGen) 🎉.  
* SwiftGen has been split in multiple repositories and separate modules.  
  [@AliSoftware](https://github.com/AliSoftware)
  [@djbe](https://github.com/djbe)
  [#240](https://github.com/SwiftGen/SwiftGen/issues/240)
  [#265](https://github.com/SwiftGen/SwiftGen/pull/265)
  * The present [SwiftGen](https://github.com/SwiftGen/SwiftGen) is the CLI parsing. It is in charge of calling the frameworks, feeding them appropriate parameters according to the command line arguments.
  * [SwiftGenKit](https://github.com/SwiftGen/SwiftGenKit) is the framework responsible for parsing your assets/resources and turning them into a structured representation compatible with `Stencil` templates.
  * [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) is a framework adding some extensions to the template engine [Stencil](https://github.com/kylef/Stencil) used by SwiftGen. It adds some tags and filters as well as convenience methods shared both by SwiftGen itself and by [Sourcery](https://github.com/krzysztofzablocki/Sourcery).
  * The SwiftGen templates has been moved into [a dedicated templates repo](https://github.com/SwiftGen/templates) so they can evolve and be unit-tested separately of SwiftGen.

Note: The next minor version will focus on bringing more documentation for all this new structure and improve ease of future contributions.

## 4.1.0

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
* Support multiple input paths for some commands:  
  [David Jennes](https://github.com/djbe)
  [#213](https://github.com/SwiftGen/SwiftGen/pull/213)
  * `fonts` accepts multiple input directories, all found fonts will be added
    to the `families` template variable.
  * `images` now supports multiple asset catalogs as input. Templates can now
    use the `catalogs` variable to access each individual catalog.
  * `storyboards` accepts multiple paths (to folders or `storyboard` files).
    All found storyboards will be available in the `storyboards` template
    variable.

### Internal changes

* Better error handling in the `colors` command.  
  [David Jennes](https://github.com/djbe)
  [#227](https://github.com/SwiftGen/SwiftGen/pull/227)
* Stencil: added two new tags `macro` and `call`, see the
  [documentation](documentation/Templates.md). for in depth explanations on how
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
  _(Should still compile in Xcode 7.3 but the `Rakefile` to build, install and release requires Xcode 8)._  
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
  * `<name>` here can be either a subcommand name like `colors` or a
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
> e.g. to clone [the default `strings-default.stencil` template](https://github.com/SwiftGen/SwiftGen/blob/master/templates/strings-default.stencil):
>
> * use `swiftgen templates cat strings --output strings-custom.stencil`
> * modify the cloned `strings-custom.stencil` template to your liking
> * use it with `swiftgen strings … --templatePath strings-custom.stencil …` in your projects!

### Important Notes

* Some keys for various templates have changed to provide more flexibility and enable some new features in the templates. As a result, **if you created your own custom templates, they might not all be totally compatible with SwiftGen 3.0.0** (hence the new major version).
Please read the [Custom Templates documentation](documentation/Templates.md) to find out the new Stencil context keys and update your custom templates accordingly.

_If you're using one of the bundled templates, all of them have been updated appropriately._

* Also **if you use Swift 3**, and thus use the `-t swift3` flag to use the Swift 3 templates, be advised those has been modified
to take the latest Swift 3 modifications into account (including naming convensions) so your code might need to be updated
according to match the latest Swift 3 recommendations.

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

* Adding comments to generated color enums which allow you to see the color in the QuickHelp documentation

![colors QuickHelp](documentation/ColorsQuickHelp.png)

* The default translation of strings are now added as documentation comments to the enum cases.  
  _You can add translations to your own templates by using the `string.translation` variable._  
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
  * For more info, see [this dedicated documentation](documentation/Templates.md).  
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
  [Ahmed Mseddi](https://github.com/amseddi) & Guillaume Lagorce
  [#44](https://github.com/SwiftGen/SwiftGen/pull/44)
* Fix issue with Storyboards without any StoryboardID (all scenes being anonymous) not extending `StoryboardScene`.  
  [#36](https://github.com/SwiftGen/SwiftGen/issues/36)

## 0.6.0

### New Features: Templates

* `SwiftGen` now uses [Stencil](https://github.com/kylef/Stencil) template engine to produce the generated code.
* This means that the generate code will be easier to improve
* This also means that **you can use your own templates** to generate code that better suits your needs and preferences, using `swiftgen … --template FILE …`

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

* Fix color parsing with absent alpha  
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
