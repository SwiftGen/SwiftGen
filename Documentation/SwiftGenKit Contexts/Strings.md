# Strings parser

## Input

The strings parser accepts a `strings` file, typically `Localizable.strings`, or a directory.  
In case it is passed a file it will parse each string in this file, including the type information for formatting parameters.  
In the case of a directory it will look recursively in the directory and parse each `strings` file it finds. Bear in mind that only one language should be passed (to avoid parsing the same keys multiple times in different languages) so do not pass a directory that includes multiple `.lproj` folders with the same `strings` file.

The strings file will be converted into a structured tree version, where each string is separated into components by the `.` character. We call this the `dot syntax`, each component representing a level. For example, the following strings:

```
"some.deep.structure"
"some.deep.something"
"hello.world"
```

will be parsed into the following structure (not showing the rest of the structure, such as values and types):

```swift
[
  "some": [
    "deep": [
      "structure",
      "something"
    ]
  ],
  "hello": [
    "world"
  ]
]
```

## Output

The output context has the following structure:

 - `tables`: `Array` — List of string tables
   - `name`  : `String` — name of the `.strings` file (usually `"Localizable"`)
   - `levels`: `Array` — Tree structure of strings (based on dot syntax), each level has:
     - `name`    : `String` — name of the level (that is, part of the key split by `.` that we're describing)
     - `children`: `Array` — list of sub-levels, repeating the same structure as a level
     - `strings` : `Array` — list of strings at this level:
       - `name` : `String` — contains only the last part of the key (after the last `.`)
         (useful to do recursion when splitting keys against `.` for structured templates)
       - `key`  : `String` — the full translation key, as it appears in the strings file
       - `translation`: `String` — the translation for that key in the strings file
       - `types`: `Array<String>` — defined only if localized string has parameter placeholders like `%d` and `%@` etc.
          Contains a list of types like `"String"`, `"Int"`, etc
