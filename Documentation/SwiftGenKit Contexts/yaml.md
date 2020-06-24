# YAML parser

## Input

The YAML parser accepts multiple files or directories (which it'll recursively search). Each file's content will be loaded into the context, but the parser will also generate metadata about the structure of the file.

YAML files can contain multiple documents, which is why each file can contain multiple `documents` in the structure below.

Note: The JSON, YAML and Plist parsers provide a similar context structure, so you can easily switch input formats while keeping the same template.

## Output

The output context has the following structure:

 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `documents`: `Array` — List of documents. JSON files will only have 1 document
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
- documents:
  - data:
    - "Mark McGwire"
    - "Sammy Sosa"
    - "Ken Griffey"
    metadata:
      element:
        type: "String"
      type: "Array"
  - data:
    - "Chicago Cubs"
    - "St Louis Cardinals"
    metadata:
      element:
        type: "String"
      type: "Array"
  name: "documents"
  path: "documents.yaml"
- documents:
  - data:
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
