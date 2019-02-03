# Strings parser

## Input

The strings parser accepts a `strings` file, typically `Localizable.strings`. It will parse each string in this file, including the type information for formatting parameters.

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

### Filter

The default filter for this command is: `[^/]\.strings$`. That means it'll accept any file with the extension `strings`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

## Templates

* [See here](../templates/strings) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/Strings.md) to see what data is available after parsing.
