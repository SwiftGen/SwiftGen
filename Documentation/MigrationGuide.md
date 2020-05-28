# Migration Guides

All the migration guides for SwiftGen are spread out over a few files, depending on the target audience.

| Migration Guide | Target Audience | Abstract |
|-----------------|-----------------|---------|
| SwiftGen Migration Guide (this file) | All users of SwiftGen | Changes in configuration, CLI parameters and global changes overview |
| [Templates Migration Guide](templates/MigrationGuide.md) | Users of SwiftGen's bundled templates (`templateName` option) | Some templates may have been renamed, removed or merged, or their functionality may have changed |
| [SwiftGenKit Migration Guide](SwiftGenKit%20Contexts/MigrationGuide.md) | Template writers | Changes in names of variables provided by SwiftGenKit to your templates |
| [StencilSwiftKit Migration Guide](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md) | Template writers | Changes in extra filters and tags for use in templates |

----

# SwiftGen 6.0 Migration Guide

If you're migrating from SwiftGen 5.x to SwiftGen 6.0, there might be some migration steps you'll need to use.

Below is a list of pointers to help you migrate to the new SwiftGen 6.0.

## `storyboards` command has been renamed

The `storyboards` parser command has been renamed `ib`, for Interface Builder. This renaming was necessary to prepare for an upcoming feature of being able to parse `XIB` files too in a future release of SwiftGen.
You should replace invocations in your config files with the new `ib` command name, or command line invocations of `swiftgen storyboards …` with `swiftgen ib …`.

❗️ See below: the bundled `storyboards` templates have been split up into one for scenes and one for segues.

## Bundled Templates have been renamed & cleaned

A few minor template functionality changes have been made, mostly cleaning up some old code and old behaviours. You can read more about it in the [templates Migration Guide](templates/MigrationGuide.md#swiftgen-60-migration-guide).

### Removed Swift 2 support

We've (finally) removed the bundled `swift2` templates. These have been deprecated for a while and were not being tested, so we're dropping them with this release. We assume most of you are already developing in a newer version of Swift (3 or 4).

### Asset Catalog changes

The `xcassets` templates now support `NSDataAssets`, and they will now only group assets if the "Provides Namespace" checkbox is ticked for a group (you can change back to the old behaviour if needed).

### Storyboards template has been split into scenes and segues templates

The biggest change is that the `storyboards` (`ib`) templates have been split up into separate templates, grouping functionality into a specific template. There's now a template for your scene information `scenes-swift3/4`, and a template for your segue information `segues-swift3/4`. We've split these up in preparation for more upcoming functionality, such as accessibility labels. To learn how to use both templates at the same time for a single set of IB files, see below.

## Commands can have multiple outputs

This is only available for users with a configuration file, not via command line invocation of a dedicated parser. For each command you can now have a list of `outputs`, each output with a template name (`templateName`) or path (`templatePath`), an output file to generate (`output`), and an optional list of parameters (`params`).

This allows you to generate multiple different outputs for the same input (for example both scenes and segues of storyboards, or both `.h` and `.m` for and Objective-C template, or both Swift code constants and html code for your documentation, …). For example:

```yaml
ib:
  inputs: dir/to/search/for/storyboards
  outputs:
    - templateName: scenes-swift4
      output: Storyboard Scenes.swift
    - templateName: segues-swift4
      output: Storyboard Segues.swift
```

As an extra advantage, the resources for that command will only be parsed once, giving you a nice performance boost.

You'll notice that the configuration structure has changed a little bit, see below for more information.

## Configuration changes

Now that each command can have multiple outputs, we're deprecating the following configuration settings.

- `output` has been renamed `outputs`, which now accepts one dictionary or an array of dictionaries (with the keys described next).
- `templateName`, `templatePath`, `output` and `params` have been moved down to the `outputs` level, so that each output can have a template name (or path), an output file path, and optional parameters.
- `paths` has been renamed to `inputs`.

So if you had the following configuration:

```yaml
colors:
  paths: path/to/colors.json
  templateName: swift4
  output: Colors.swift
storyboards:
  paths: path/to/storyboards
  templateName: swift4
  output: Storyboards.swift
```

It would become:

```yaml
colors:
  inputs: path/to/colors.json
  outputs:
    templateName: swift4
    output: Colors.swift
ib:
  inputs: path/to/storyboards
  outputs:
    - templateName: scenes-swift4
      output: Storyboard Scenes.swift
    - templateName: segues-swift4
      output: Storyboard Segues.swift
```

## New Features

We've added many new features to SwiftGen since our last release, below are the most significant ones.

### Mint installation

You can now install SwiftGen using Mint, see our [installation instructions](../README.md#installation) for more information.

### JSON, Plist and YAML support

You can read all about it in our [Read Me](../README.md). SwiftGen can now parse JSON, Plist and YAML files. We even provide a few bundled templates for each of these commands to get you started, so you can access your data in a type-safe and easy way:

* `inline-swift3/4`: These templates embed the contents of the data into the swift file, so it doesn't have to be loaded at runtime.
* `runtime-swift3/4`: With these templates, you can generate swift code that will load the underlying JSON/Plist file at runtime, and parses the content in a type-safe way.

Please note that the bundled templates are only meant for the most basic uses for these data types. If you need to access these data files in a different way, especially since you'll probably use some custom structure in your JSON/Plist/YAML files, you may want to write your own templates that better fit those structures (for example to write a template that expects specific keys in your custom YAML to generate code based on the values in those keys…).

For more information, read the [creating your own templates](Creating-your-templates.md) documentation.

## If you wrote your own templates

SwiftGen 6.0 uses the latest Stencil and StencilSwiftKit libraries, so there are plenty of new features for template writers, such as variable subscripting, an `indent` filter, better error reporting, ...

There have been a few minor context changes, see [SwiftGenKit's own Migration Guide](SwiftGenKit%20Contexts/MigrationGuide.md#swiftgenkit-20-swiftgen-50-migration-guide) for more information.

## Command Line invocation

If you still invoked SwiftGen parsers directly using command line flags and options (instead of a configuration file), be sure to use `--templateName` or `--templatePath` instead of the `--template`/`-t` option (which has been deprecated).

# SwiftGen 5.1 Migration Guide

<details>
<summary>Migration Guide</summary>

## Template functionality changes

Only a small change in the generated code that'll affect a tiny subset of users: the `allValues` variable has been deprecated. See the [templates Migration Guide](templates/MigrationGuide.md#functionality-changes-in-21-swiftgen-51) for more information.

</details>

# SwiftGen 5.0 Migration Guide

<details>
<summary>Migration Guide</summary>

If you're migrating from SwiftGen 4.x to SwiftGen 5.0, there might be some migration steps you'll need to use.

Below is a list of pointers to help you migrate to the new SwiftGen 5.0

## Command Line invocation

### `images` command has been renamed

The `images` parser command has been renamed `xcassets`.
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

Be sure to consult the [templates Migration Guide](templates/MigrationGuide.md#templates-20-migration-guide) to see the list of changes (renamings or removal) in templates bundled in SwiftGen.

📖 Also, **each template bundled in SwiftGen has a dedicated documentation now**, listing what the template is for, what does the generated code looks like, when you might want to choose that template over another one, and the parameters (`--param X=Y`) supported by this template for customization via the command line.  
This should help you choose the right template to use for your use case (or help you decide if you need to create your own if none of the provided ones fit your needs) and see what's customizable for each.

📖 See [the dedicated documentation folder](templates) for those templates documentation. This folder is organized the same way the templates are: one subfolder for each SwiftGen command (`colors`, `strings`, …), then one markdown file for each template name.

### Breaking template functionality changes

❗️ The code generated by the `storyboards` templates is **not** backward compatible with the one generated by SwiftGen 4.x. This means that you'll need to adapt your codebase and call sites accordingly.

Please read the [templates migration guide](templates/MigrationGuide.md#functionality-changes-in-20-swiftgen-50) for more information, which includes a compatibility template. Essentially, you need to change calls like the following line:

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

These are just a few of the changes to the structure of the variables passed by SwiftGenKit to your templates. To learn more about all the variables which have been renamed, removed or added and the new structures for each SwiftGen command, see [SwiftGenKit's own Migration Guide](SwiftGenKit%20Contexts/MigrationGuide.md#swiftgenkit-20-swiftgen-50-migration-guide).

### Some SwiftGen-specific Stencil filters evolved

Also, a few dedicated Stencil filters provided by SwiftGen (via StencilSwiftKit) have been renamed. Especially the `join` and `snakeToCamelCase` filters now take a parameter. See [StencilSwiftKit's own Migration Guide](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50) for more info.

</details>


# SwiftGen 4.2 Migration Guide

<details>
<summary>Migration Guide</summary>

If you're still using SwiftGen 4.x, you should at least consider follow the [SwiftGen 4.2 Migration Guide](SwiftGenKit%20Contexts/MigrationGuide.md#swiftgen-42-migration-guide) to prepare your migration to SwiftGen 5.0 smoothly, by getting rid of deprecated variables in your contexts.

</details>
