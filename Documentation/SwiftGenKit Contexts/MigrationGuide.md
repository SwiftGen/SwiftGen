# SwiftGen 6.2.1 Migration Guide

## Changes for template writers

### JSON and Plist

The `documents` variable of each "file" is now considered as deprecated, it's replacement is `document`. The `documents` variable is still available, but will be removed in SwiftGen 7.0.

Initially we provided `documents` to keep the (context) data model the same for the JSON, Plist and YAML parsers, even though only YAML files can have multiple documents in one file. We've decided to forgo that approach, as our contexts should match the underlying content.

# SwiftGen 6.0 Migration Guide

<details>
<summary>Migration Guide</summary>

## Changes for users

### Strings

The parser will no longer normalize string keys, which can lead to duplicate keys if your file contain similar keys but with different casing. For example, if your file contains:

```
"abcNews.something" = "foo";
"ABCNews.somethingElse" = "bar";
```

SwiftGenKit will no longer consolidate these into one "abcNews" case. It is up to the user to fix this inconsistent casing in their `strings` files, or to adapt a custom template to take that into consideration.

## Changes for template writers

### XCAssets

Groups now have an extra attribute `isNamespaced` that reflects the "provides namespace" setting in Xcode.

</details>

# SwiftGenKit 2.0 (SwiftGen 5.0) Migration Guide

<details>
<summary>Migration Guide</summary>

If you're migrating from SwiftGenKit 1.x to SwiftGenKit 2.0 — which is the case if you are migrating from SwiftGen 4.x to SwiftGen 5.0 — then you should be aware of the following changes in variable names generated in the output context by SwiftGenKit, and adapt your custom templates accordingly to change the name of the variables you use.

## Changes for template writers

As a reminder, you can find all the documentation for the context structures provided as variables to your templates [in the Contexts Documentation folder of this repository](.) — one MarkDown file for each SwiftGen subcommand / SwiftGenKit parser.

### Common changes and the new `--param` flags

One common changes across all templates is that the `enumName` variable (or `sceneEnumName` & `segueEnumName` for storyboards) have been replaced by their `param.enumName` counterparts. Those are variables provided by the user via the `--param enumName=…` flag during SwiftGen's command line invocation.

This means that you are now also responsible for providing a default value for those `param.enumName` if you use them, in case the user didn't provide the `--param enumName=…` flag at all. You can use that with Stencil's `default` filter, e.g. `enum {{param.enumName|default:"Assets"}}`

You can also take advantage of that new `--param` feature to make your own templates more customizable, by allowing users to provide arbitrary values via the command line, e.g. using `{{param.foo|default:"Foo"}}` and `{{param.bar|default:"-"}}` in your templates to let users provide custom values using `--param foo=MyFoo --param bar=_`. Just don't forget to document the available params somewhere to let the users of your templates know about those.

### Colors

_📖 see the full context structure [in the documentation here](Colors.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- `colors` has been replaced by the `palettes` array, each entry having a `name` and a `colors` property.
- for each `color`:
  - `rgb` and `rgba` have been removed, as they can be composed from the other components (e.g. `#{{color.red}}{{color.green}}{{color.blue}}{{color.alpha}}`).

### Fonts

_📖 see the full context structure [in the documentation here](Fonts.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- for each `font`:
  - `fontName` has been replaced by the `name` property.

### XCAssets (formerly Images)

_📖 see the full context structure [in the documentation here](Assets.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- `images` is deprecated. The new root key is named `catalogs` and contains the structured information.

### Storyboards

_📖 see the full context structure [in the documentation here](Storyboards.md)._

- `extraImports` has been renamed `modules` (see [SwiftGen/SwftGen#243](https://github.com/SwiftGen/SwiftGen/pull/243))
- `sceneEnumName` has been replaced by `param.sceneEnumName` — [see above](#common-changes-and-the-new---param-flags).
- `segueEnumName` has been replaced by `param.segueEnumName` — [see above](#common-changes-and-the-new---param-flags).
- for each `scene`:
  - `isBaseViewController` has been removed. You can replace it with a test for `baseType == "ViewController"` as Stencil now implements the `==` test operator.

### Strings

_📖 see the full context structure [in the documentation here](Strings.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- `strings` and `structuredStrings` have been replaced by the `tables` array, where each table has a structured `levels` property.
- `tableName` has been superseded by `tables` array, where each table has a `name` property.
- for each `level`:
  - `subenums` has been renamed to `children`.
- for each `string`:
  - `keytail` has been renamed to `name`.
  - the `params` structure with the `names`, `typednames`, `types`, `count` and `declarations` arrays have been removed. These have been replaced by `types` which is an array of types. The previous variables can now be reconstructed using template tags now that Stencil has become more powerful.

## Changes for developers using SwiftGenKit as a dependency

Previously the parser context generation method (`stencilContext()`) accepted parameters such as `enumName`, this has been removed in favor of the `--param` system.

Templates will automatically receive a `param` object with parameters from the CLI invocation, and should provide default values in case no value was present in the invocation.

</details>

# SwiftGen 4.2 Migration Guide

<details>
<summary>Migration Guide</summary>

## Deprecated context variables in SwiftGen 4.2 ##

The following Stencil context variables have been renamed or replaced in SwiftGen 4.2.
They will no longer be available after the next major release of SwiftGen 5.0.

**If you wrote custom templates for SwiftGen, we advise you to migrate your template to use to these new context variables** instead of the old one so that they'll continue to work in 4.2 but also in the upcoming 5.0.

### Colors ###

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `rgb` and `rgba` (for each color): can be composed from the other components.

### Fonts ###

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `fontName` (for each font): has been replaced by the `name` property.

### Images ###

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `images`: just old, `catalogs` contains the structured information.

### Storyboards ###

- `extraImports`: replaced by `modules` (https://github.com/SwiftGen/SwiftGen/pull/243)
- `sceneEnumName`: has been replaced by `param. sceneEnumName`, should provide default value.
- `segueEnumName`: has been replaced by `param. segueEnumName `, should provide default value.template using Stencil.
- For each `scene`:
  - `isBaseViewController`: removed. You can replace it with a test for `baseType == "ViewController"`.

### Strings ###

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `strings` and `structuredStrings`: replaced by `tables` array, where each table has a structured `levels` property.
- `tableName`: replaced by `tables` array, where each table has a `name` property.
- for each `level`:
  - `subenums`: renamed to `children`.
- for each `string`:
  - `keytail`: renamed to `name`.
  - `params` structure with the `names`, `typednames`, `types`, `count` and `declarations` arrays: removed.
  - These have been replaced by `types` which is an array of types. The previous variables
 can now be reconstructed using template tags now that Stencil has become more powerful.

</details>
