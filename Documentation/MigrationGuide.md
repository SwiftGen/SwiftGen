# Master

*** Work In Progress — Will be consolidated once the release is ready ***

Breaking:

* IB #423: Renamed `storyboards` to `ib`, to support future functionality.
* Config #424: Commands now can have multiple outputs, each having an `output` path, a `templateName`/`templatePath` and `params`.
* Config #424: `output` is deprecated (see `output`), same with `templateName`, `templatePath` and `params`.
* Config #424: `paths` has been renamed to `inputs` (so `paths` is deprecated).

Improvements:

* #411: SPM (partially, it builds) and Mint support.
* #379: Json, Plist and YAML support.
* #475: Stencil 0.12 (from 0.10), which adds variable subscripting, `indent` filter, better error reporting, etc...

# SwiftGen 5.1 Migration Guide

## Template functionality changes

Only a small change in the generated code that'll affect a tiny subset of users: the `allValues` variable has been deprecated. See the [templates Migration Guide](https://github.com/SwiftGen/SwiftGen/blob/master/Documentation/Templates/MigrationGuide.md#functionality-changes-in-21-swiftgen-51) for more information.

# SwiftGen 5.0 Migration Guide

If you're migrating from SwiftGen 4.x to SwiftGen 5.0, there might be some migration steps you'll need to use.

Below is a list of pointers to help you migrate to the new SwiftGen 5.0

## Command Line invocation

### `images` command has been renamed

The `images` subcommand has been renamed `xcassets`.
You should replace invocations of `swiftgen images …` by `swiftgen xcassets …`

### `--enumName` flag migrated to `--param`

The `--enumName` flag (`--sceneEnumName` & `--segueEnumName` for storyboards) is no longer supported.
Instead, you can now pass arbitrary parameters to your templates using the `--param X=Y` flag.

All the templates bundled in SwiftGen accept the `enumName` parameter (`sceneEnumName` + `segueEnumName` for storyboards) to provide at least the same customization as before.

So if you used `swiftgen <command> --enumName Foo` when invoking SwiftGen before, you should now invoke it via `swiftgen <command> --param enumName=Foo`

### You're required to specify a template name or path (no more default template)

Swift evolves so fast that deciding which template should be declared as the default one would require us to change the default template every time a new major version of Swift is released. Besides, our default might not be everyone's default. That's why we decided to not fallback to a default template anymore.

Instead, you're now **required** to provide a template when invoking SwiftGen, either via `-t <templatename>` (you can see the list of available template names using the `swiftgen templates list` command) or via `-p <templatepath>`.

ℹ️ The templates that were used as default template in SwiftGen 4.0 are still bundled with SwiftGen, but they have been renamed (mainly to `"swift2"` since the "default" template in SwiftGen 4 was the one we wrote back in Swift 2 times!) and you now have to explicitly tell which to use. See [below](#bundled-templates-have-been-renamed--cleaned) for more info.

✅ **Most of you probably already use the `-t swift3` option** if you were writing Swift3 code, so **you won't need to change anything**. But in the unlikely event that you were still writing Swift2 and didn't specify a template, you'll then have to use `-t swift2` to force using this (previously default) template.

## Bundled Templates have been renamed & cleaned

Some templates bundled with SwiftGen have been **renamed** to have a better naming consistency. Some others have been **removed** or **merged with others** (for example the storyboard templates between iOS & macOS are now merged into a single one compatible with both platforms, other templates now use the `--param` feature to be customizable, removing the need to maintain 2 separate templates for some variants)

Be sure to consult the [templates Migration Guide](https://github.com/SwiftGen/SwiftGen/blob/master/Documentation/Templates/MigrationGuide.md#templates-20-migration-guide) to see the list of changes (renamings or removal) in templates bundled in SwiftGen.

📖 Also, **each template bundled in SwiftGen has a dedicated documentation now**, listing what the template is for, what does the generated code looks like, when you might want to choose that template over another one, and the parameters (`--param X=Y`) supported by this template for customization via the command line.  
This should help you choose the right template to use for your use case (or help you decide if you need to create your own if none of the provided ones fit your needs) and see what's customizable for each.

📖 See [the dedicated documentation folder](https://github.com/SwiftGen/SwiftGen/tree/master/Documentation/Templates) for those templates documentation. This folder is organized the same way the templates are: one subfolder for each SwiftGen command (`colors`, `strings`, …), then one markdown file for each template name.

### Breaking template functionality changes

❗️ The code generated by the `storyboards` templates is **not** backward compatible with the one generated by SwiftGen 4.x. This means that you'll need to adapt your codebase and call sites accordingly.

Please read the [templates migration guide](https://github.com/SwiftGen/SwiftGen/blob/master/Documentation/Templates/MigrationGuide.md#functionality-changes-in-20-swiftgen-50) for more information, which includes a compatibility template. Essentially, you need to change calls like the following line:

```swift
StoryboardScene.Message.instantiateMessageList()
```

To the following call:

```swift
StoryboardScene.Message.messageList.instantiate()
```

## If you wrote your own templates

### Stencil Context keys have been refactored

If you decided to write your own templates for SwiftGen 4, you'll have to amend them to fit the new names for context variables, as some of the variables provided by SwiftGenKit to your templates have been renamed for more consistency.

For example:

* now that the `colors` command supports more than one color palette, the context's root key `colors` that you used to iterate over the list of colors has been replaced by the root key `palettes` listing all the palettes parsed by SwiftGen, with their `name` and `colors`. Also `rgb` and `rgba` has been deprecated — they can be recreated from the `red`, `green`, `blue` keys;
* for the `xcassets` command — previously named `images` — the root key isn't the `images` array anymore, but the `catalogs` key instead, listing all the Assets Catalogs that SwiftGen parsed;
* for strings, now that SwiftGen support more than one `.strings` localizations table, the root key you iterate over isn't `strings` or `structuredStrings` but is not a `tables` array, and its structure has changed a bit.

These are just a few of the changes to the structure of the variables passed by SwiftGenKit to your templates. To learn more about all the variables which have been renamed, removed or added and the new structures for each SwiftGen command, see [SwiftGenKit's own Migration Guide](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/MigrationGuide.md#swiftgenkit-20-swiftgen-50-migration-guide).

### Some SwiftGen-specific Stencil filters evolved

Also, a few dedicated Stencil filters provided by SwiftGen (via StencilSwiftKit) have been renamed. Especially the `join` and `snakeToCamelCase` filters now take a parameter. See [StencilSwiftKit's own Migration Guide](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50) for more info.
