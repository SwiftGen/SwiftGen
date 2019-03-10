# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse for supported set types and groups. We currently support the following types:
- Group Type (folder)
- AR Resource Group (arresourcegroup)
- Color Set Type (colorset)
- Data Set Type (dataset)
- Image Set Type (imageset)

For a full documentation of asset catalog types, please read the [Apple documentation](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html).

## Output

The output context has the following structure:

 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents an asset, and has the following entries:
       - `type` : `String` — one of "arresourcegroup", "color", "data" or "image"
       - `name` : `String` — name of the asset
       - `value`: `String` — the actual full name for loading the asset
     - represents a group and has the following entries:
       - `type`        : `String` — "group"
       - `name`        : `String` — name of the folder
       - `isNameSpaced`: `Bool` - Whether this group provides a namespace for child items
       - `items`       : `Array` — list of items, can be either groups or other assets


## Example

```yaml
catalogs:
- assets:
  - name: "Data"
    type: "data"
    value: "Data"
  - isNamespaced: "true"
    items: []
    name: "Empty"
    type: "group"
  - isNamespaced: "true"
    items:
    - name: "Data"
      type: "data"
      value: "Json/Data"
    name: "Json"
    type: "group"
  - name: "README"
    type: "data"
    value: "README"
  name: "Files"
- assets:
  - isNamespaced: "true"
    items:
    - name: "Banana"
      type: "image"
      value: "Exotic/Banana"
    - name: "Mango"
      type: "image"
      value: "Exotic/Mango"
    name: "Exotic"
    type: "group"
  - isNamespaced: "true"
    items:
    - name: "Apricot"
      type: "image"
      value: "Round/Apricot"
    name: "Round"
    type: "group"
  name: "Food"
- assets:
  - isNamespaced: "true"
    items:
    - name: "Background"
      type: "color"
      value: "24Vision/Background"
    - name: "Primary"
      type: "color"
      value: "24Vision/Primary"
    name: "24Vision"
    type: "group"
  - name: "Orange"
    type: "image"
    value: "Orange"
  name: "Styles"
resourceCount:
  arresourcegroup: 0
  color: 4
  data: 3
  image: 8
```
