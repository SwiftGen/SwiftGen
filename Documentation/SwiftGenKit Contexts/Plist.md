# Plist parser

## Input

The PList parser accepts mutiple files or directories (which it'll recursively search). Each file will be loaded into the context, but the parser will also generate metadata about the structure of the file.

Note: The JSON, YAML and Plist parsers provide the same context structure, so you can easily switch input formats while keeping the same template.

## Output

The output context has the following structure:

 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `documents`: `Array` — List of documents. Plist files will only have 1 document
       - `data`: `Any` — The contents of the document
       - `metadata`: `Dictionary` — Describes the structure of the document

The metadata has the following properties:

 - `type`: `String` — The type of the object (Array, Dictionary, Int, Float, String, Bool, Date, Data)
 - `properties`: `Array` — List of properties metadata (only if a dictionary, repeats this metadata structure)
    - name: `String` — Name of the property (dictionary key)
    - repeats the rest of the metadata structure
 - `element`: `Dictionary` — Element metadata (only if an array, repeats this metadata structure)

## Example

```yaml
files:
- documents:
  - data:
      UILaunchStoryboardName: "LaunchScreen"
      UIMainStoryboardFile: "Start"
      User Ambiguous Integer: true
      User Boolean: false
      User Date: 2018-05-05T03:39:26Z
      User Float: 3.14e+0
      User Integer: 5
    metadata:
      properties:
      - name: "UILaunchStoryboardName"
        type: "String"
      - name: "UIMainStoryboardFile"
        type: "String"
      - name: "User Ambiguous Integer"
        type: "Bool"
      - name: "User Boolean"
        type: "Bool"
      - name: "User Date"
        type: "Date"
      - name: "User Float"
        type: "Double"
      - name: "User Integer"
        type: "Int"
      type: "Dictionary"
  name: "Info"
  path: "Info.plist"
- documents:
  - data:
    - "value1"
    - "value2"
    metadata:
      element:
        type: "String"
      type: "Array"
  name: "array"
  path: "array.plist"
```
