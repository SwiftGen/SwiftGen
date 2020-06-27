# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse for supported set types and groups. We currently support the following types:
- Group Type (folder)
- AR Resource Group (arresourcegroup) with reference images and objects
- Color Set Type (colorset)
- Data Set Type (dataset)
- Image Set Type (imageset)

For a full documentation of asset catalog types, please read the [Apple documentation](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html).

### Filter

The default filter for this command is: `[^/]\.xcassets$`. That means it'll accept any file with the extension `xcassets`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/xcassets) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/xcassets.md) to see what data is available after parsing.
