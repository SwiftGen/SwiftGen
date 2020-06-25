# Core Data parser

## Input

The core data parser accepts a `xcdatamodeld` (or `xcdatamodel`) file. The parser will load all the configurations, entities, and fetch requests for each model.

### Filter

The default filter for this command is: `[^/]\.xcdatamodeld?$`. That means it'll accept any file with the extensions `xcdatamodel` or `xcdatamodeld`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/coredata) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/coredata.md) to see what data is available after parsing.
