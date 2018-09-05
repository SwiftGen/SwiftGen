# Master

*** Work In Progress — Will be consolidated once the release is ready ***

Breaking:

* Strings #257: don't normalize keys anymore (this can lead to dupe keys for string keys such as `abcNews` and `ABCNews`). It's up to the user to fix their strings files.

Improvements:

* XCAssets #453: added `isNamespaced` property to groups.

# SwiftGenKit 2.0 (SwiftGen 5.0) Migration Guide

If you're migrating from SwiftGenKit 1.x to SwiftGenKit 2.0 — which is the case if you are migrating from SwiftGen 4.x to SwiftGen 5.0 — then you should be aware of the following changes in variable names generated in the output context by SwiftGenKit, and adapt your custom templates accordingly to change the name of the variables you use.

## Changes for template writers

As a reminder, you can find all the documentation for the context structures provided as variables to your templates [in the Documentation folder of this repository](https://github.com/SwiftGen/SwiftGenKit/tree/master/Documentation/) — one MarkDown file for each SwiftGen subcommand / SwiftGenKit parser.

### Common changes and the new `--param` flags

One common changes across all templates is that the `enumName` variable (or `sceneEnumName` & `segueEnumName` for storyboards) have been replaced by their `param.enumName` counterparts. Those are variables provided by the user via the `--param enumName=…` flag during SwiftGen's command line invocation.

This means that you are now also responsible for providing a default value for those `param.enumName` if you use them, in case the user didn't provide the `--param enumName=…` flag at all. You can use that with Stencil's `default` filter, e.g. `enum {{param.enumName|default:"Assets"}}`

You can also take advantage of that new `--param` feature to make your own templates more customizable, by allowing users to provide arbitrary values via the command line, e.g. using `{{param.foo|default:"Foo"}}` and `{{param.bar|default:"-"}}` in your templates to let users provide custom values using `--param foo=MyFoo --param bar=_`. Just don't forget to document the available params somewhere to let the users of your templates know about those.

### Colors

_📖 see the full context structure [in the documentation here](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/Colors.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- `colors` has been replaced by the `palettes` array, each entry having a `name` and a `colors` property.
- for each `color`:
  - `rgb` and `rgba` have been removed, as they can be composed from the other components (e.g. `#{{color.red}}{{color.green}}{{color.blue}}{{color.alpha}}`).

### Fonts

_📖 see the full context structure [in the documentation here](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/Fonts.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- for each `font`:
  - `fontName` has been replaced by the `name` property.

### XCAssets (formerly Images)

_📖 see the full context structure [in the documentation here](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/Assets.md)._

- `enumName` has been replaced by `param.enumName` — [see above](#common-changes-and-the-new---param-flags).
- `images` is deprecated. The new root key is named `catalogs` and contains the structured information.

### Storyboards

_📖 see the full context structure [in the documentation here](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/Storyboards.md)._

- `extraImports` has been renamed `modules` (see [SwiftGen/SwftGen#243](https://github.com/SwiftGen/SwiftGen/pull/243))
- `sceneEnumName` has been replaced by `param.sceneEnumName` — [see above](#common-changes-and-the-new---param-flags).
- `segueEnumName` has been replaced by `param.segueEnumName` — [see above](#common-changes-and-the-new---param-flags).
- for each `scene`:
  - `isBaseViewController` has been removed. You can replace it with a test for `baseType == "ViewController"` as Stencil now implements the `==` test operator.

### Strings

_📖 see the full context structure [in the documentation here](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/Strings.md)._

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
