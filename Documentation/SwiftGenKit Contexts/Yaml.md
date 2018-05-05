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
