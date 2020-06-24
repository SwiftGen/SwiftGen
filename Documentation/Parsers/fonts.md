# Fonts parser

## Input

The fonts parser accepts a directory, which it'll recursively search for font files. Supported file types depend on the target platform, for example iOS only supports TTF and OTF font files.

### Filter

The default filter for this command is: `[^/]\.(?i:otf|ttc|ttf)$`. That means it'll accept any file with the extensions `otf`, `ttc` or `ttf`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/fonts) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/fonts.md) to see what data is available after parsing.
