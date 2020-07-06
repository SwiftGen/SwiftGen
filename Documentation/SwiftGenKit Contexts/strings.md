# Strings parser

## Input

The strings parser accepts a `strings` file, typically `Localizable.strings`. It will parse each string in this file, including the type information for formatting parameters.

The strings file will be converted into a structured tree version, where each string is separated into components by the `.` character (note: you can choose another separator if you need, using the `separator` option, see [Command Customization](../Parsers/strings.md#customization)). We call this the `dot syntax`, each component representing a level. For example, the following strings:

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

## Example

```yaml
tables:
- levels:
    children:
    - name: "apples"
      strings:
      - key: "apples.count"
        name: "count"
        translation: "You have %d apples"
        types:
        - "Int"
    - name: "bananas"
      strings:
      - key: "bananas.owner"
        name: "owner"
        translation: "Those %d bananas belong to %@."
        types:
        - "Int"
        - "String"
    - children:
      - name: "user_profile_section"
        strings:
        - key: "settings.user_profile_section.footer_text"
          name: "footer_text"
          translation: "Here you can change some user profile settings."
        - key: "settings.user_profile_section.HEADER_TITLE"
          name: "HEADER_TITLE"
          translation: "User Profile Settings"
      name: "settings"
    strings:
    - key: "alert_message"
      name: "alert_message"
      translation: "Some alert body there"
    - key: "alert_title"
      name: "alert_title"
      translation: "Title of the alert"
    - key: "ObjectOwnership"
      name: "ObjectOwnership"
      translation: "These are %3$@'s %1$d %2$@."
      types:
      - "Int"
      - "String"
      - "String"
    - key: "private"
      name: "private"
      translation: "Hello, my name is %@ and I'm %d"
      types:
      - "String"
      - "Int"
  name: "Localizable"
```
