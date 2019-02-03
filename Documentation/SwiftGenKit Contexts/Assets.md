# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse for supported set types and groups. We currently support the following types:
- Group Type (folder)
- Color Set Type (colorset)
- Data Set Type (dataset)
- Image Set Type (imageset)

For a full documentation of asset catalog types, please read the [Apple documentation](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html).

## Output

The output context has the following structure:

 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents a color asset, and has the following entries:
       - `type` : `String` — "color"
       - `name` : `String` — name of the color
       - `value`: `String` — the actual full name for loading the color
     - represents a data asset, and has the following entries:
       - `type` : `String` — "data"
       - `name` : `String` — name of the data asset
       - `value`: `String` — the actual full name for loading the data asset
     - represents a group and has the following entries:
       - `type`        : `String` — "group"
       - `name`        : `String` — name of the folder
       - `isNameSpaced`: `Bool` - Whether this group provides a namespace for child items
       - `items`       : `Array` — list of items, can be either groups, colors or images
     - represents an image asset, and has the following entries:
       - `type` : `String` — "image"
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image

## Example

```yaml
catalogs:
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
  name: "Colors"
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
  name: "Data"
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
  name: "Images"
```
