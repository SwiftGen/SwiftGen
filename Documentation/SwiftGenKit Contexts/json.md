# JSON parser

## Input

The JSON parser accepts multiple files or directories (which it'll recursively search). Each file's content will be loaded into the context, but the parser will also generate metadata about the structure of the file.

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
    - "Anna"
    - "Bob"
    metadata:
      element:
        type: "String"
      type: "Array"
  name: "array"
  path: "array.json"
- document:
    data:
      api-version: "2"
      country: null
      environment: "staging"
      options:
        screen-order:
        - "1"
        - "2"
        - "3"
    metadata:
      properties:
        api-version:
          type: "String"
        country:
          type: "Optional"
        environment:
          type: "String"
        options:
          properties:
            screen-order:
              element:
                type: "String"
              type: "Array"
          type: "Dictionary"
      type: "Dictionary"
  name: "configuration"
  path: "configuration.json"
```
