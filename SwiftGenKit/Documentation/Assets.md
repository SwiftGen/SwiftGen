# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse for supported set types and groups. We currently support the following types:
- Group Type
- Color Set Type (colorset)
- Image Set Type (imageset)

For a full documentation of asset catalog types, please read the [Apple documentation](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html).

## Output

The output context has the following structure:

 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents a group and has the following entries:
       - `type` : `String` — "group"
       - `name` : `String` — name of the folder
       - `items`: `Array` — list of items, can be either groups, colors or images
     - represents a color asset, and has the following entries:
       - `type` : `String` — "color"
       - `name` : `String` — name of the color
       - `value`: `String` — the actual full name for loading the color
     - represents an image asset, and has the following entries:
       - `type` : `String` — "image"
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image

## Example

```
{
  "catalogs": [
    {
      "name": "Images",
      "assets": [
        {
          "name": "Exotic",
          "type": "group",
          "items": [
            {
              "value": "Exotic\/Banana",
              "type": "image",
              "name": "Banana"
            },
            {
              "value": "Exotic\/Mango",
              "type": "image",
              "name": "Mango"
            }
          ]
        },
        {
          "value": "Logo",
          "type": "image",
          "name": "Logo"
        },
        {
          "value": "Primary Color",
          "type": "color",
          "name": "Primary Color"
        },
        {
          "name": "Round",
          "type": "group",
          "items": [
            {
              "value": "Round\/Apricot",
              "type": "image",
              "name": "Apricot"
            },
            {
              "value": "Round\/Orange",
              "type": "image",
              "name": "Orange"
            },
            {
              "name": "Red",
              "type": "group",
              "items": [
                {
                  "value": "Round\/Apple",
                  "type": "image",
                  "name": "Apple"
                },
                {
                  "name": "Double",
                  "type": "group",
                  "items": [
                    {
                      "value": "Round\/Double\/Cherry",
                      "type": "image",
                      "name": "Cherry"
                    }
                  ]
                },
                {
                  "value": "Round\/Tint Color",
                  "type": "color",
                  "name": "Tint Color"
                },
                {
                  "value": "Round\/Tomato",
                  "type": "image",
                  "name": "Tomato"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```
