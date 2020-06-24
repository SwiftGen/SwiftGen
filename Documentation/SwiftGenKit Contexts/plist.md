# Plist parser

## Input

The PList parser accepts multiple files or directories (which it'll recursively search). Each file's content will be loaded into the context, but the parser will also generate metadata about the structure of the file.

Note: The JSON, YAML and Plist parsers provide a similar context structure, so you can easily switch input formats while keeping the same template.

## Output

The output context has the following structure:

 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `document`: `Dictionary` - Describes the structure of the document
       - `data`: `Any` — The contents of the document
       - `metadata`: `Dictionary` — Describes the structure of the document

The metadata has the following properties:

 - `type`: `String` — The type of the object (Array, Bool, Data, Date, Dictionary, Double, Int, String, Optional and Any)
 - `properties`: `Dictionary` — List of properties metadata (only if a dictionary, repeats this metadata structure)
 - `element`: `Dictionary` — Element metadata (only if an array, repeats this metadata structure)
 - `items`: `Array` — List of metadata objects for each array element (only if the element.type is `Any`, `Dictionary`
            or `Array`)

## Example

```yaml
files:
- document:
    data:
      UILaunchStoryboardName: "LaunchScreen"
      UIMainStoryboardFile: "Start"
      User Ambiguous Integer: true
      User Boolean: false
      User Date: 2018-05-05T03:39:26Z
      User Float: 3.14e+0
      User Integer: 5
    metadata:
      properties:
        Fabric:
          type: "Dictionary"
          properties:
            APIKey:
              type: "String"
            Kits:
              type: "Array"
              element:
                type: "Dictionary"
                items:
                - type: "Dictionary"
                  properties:
                    KitInfo:
                      properties: {}
                      type: "Dictionary"
                    KitName:
                      type: "String"
        UILaunchStoryboardName:
          type: "String"
        UIMainStoryboardFile:
          type: "String"
        User Ambiguous Integer:
          type: "Bool"
        User Boolean:
          type: "Bool"
        User Date:
          type: "Date"
        User Float:
          type: "Double"
        User Integer:
          type: "Int"
      type: "Dictionary"
  name: "Info"
  path: "Info.plist"
- document:
    data:
    - "Eggs"
    - "Bread"
    - "Milk"
    metadata:
      element:
        type: "String"
      type: "Array"
  name: "shopping-list"
  path: "shopping-list.plist"
```
