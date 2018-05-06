# YAML (and JSON) parser

## Input

The YAML parser accepts mutiple files or directories (which it'll recursively search). Each file will be loaded into the context, but the parser will also generate metadata about the structure of the file.

YAML files can contain multiple documents, which is why each file can contain multiple `documents` in the structure below.

Note: The JSON, YAML and Plist parsers provide the same context structure, so you can easily switch input formats while keeping the same template.

## Output

The output context has the following structure:

 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `documents`: `Array` — List of documents. JSON files will only have 1 document
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
      key1: "value1"
      key2: "2"
      key3:
        nestedKey3:
        - "1"
        - "2"
        - "3"
    metadata:
      properties:
      - name: "key1"
        type: "String"
      - name: "key2"
        type: "String"
      - name: "key3"
        properties:
        - element:
            type: "String"
          name: "nestedKey3"
          type: "Array"
        type: "Dictionary"
      type: "Dictionary"
  name: "json"
  path: "json.json"
```
