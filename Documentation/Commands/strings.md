# Strings parser

## Input

The strings parser accepts a `strings` file, typically `Localizable.strings`. It will parse each string in this file, including the type information for formatting parameters.

The strings file will be converted into a structured tree version, where each string is separated into components by the `.` character (note: you can choose another separator if you need, using the `separator` option, see [Customization](#customization) below). We call this the `dot syntax`, each component representing a level. For example, the following strings:

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

The default filter for this command is: `[^/]\.(?i:strings|stringsdict)$`. That means it'll accept any file with the extension `strings` or `stringsdict`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

This parser currently doesn't accept any options.

| Option Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `separator` | `.` | Each key is separated into components using the given separator, to form a structure as described in the [explanation above](#input). |

## Templates

* [See here](../templates/strings) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/Strings.md) to see what data is available after parsing.

## Plurals

SwiftGen supports non-nested definitions of plurals in `.stringsdict` files.

### Supported

<details open>

<summary>Basic Example</summary>

This example should cover the most common use case of plurals that is also supported by most of the translation management services.

```xml
<key>competition.event.number-of-matches</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%#@Matches@</string>
    <key>Matches</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>ld</string>
        <key>zero</key>
        <string>No matches</string>
        <key>one</key>
        <string>%ld match</string>
        <key>other</key>
        <string>%ld matches</string>
    </dict>
</dict>
```

</details>

<details>

<summary>Multiple variables with different types in format key</summary>

```xml
<key>multiple.placeholders-and-variables.string-int</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%#@element@ %#@has_rating@</string>
    <key>element</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>@</string>
        <key>other</key>
        <string>%@</string>
    </dict>
        <key>has_rating</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>zero</key>
        <string>has no rating</string>
        <key>one</key>
        <string>has one rating</string>
        <key>other</key>
        <string>has %d ratings</string>
    </dict>
</dict>
```

</details>

<details>

<summary>Variables with positional arguments in format key</summary>

_Note:_ To have the correct sorting of the parameters of the generated method, in this case `Int, String, String`, it is required to use matching positional arguments for the format key and the placeholder in the rules of the variable.

```xml
<key>multiple.placeholders-and-variables.int-string-string</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>Your %3$#@third@ list contains %1$#@first@ %2$#@second@.</string>
    <key>first</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>zero</key>
        <string>no items.</string>
        <key>one</key>
        <string>one item. You should buy it</string>
        <key>other</key>
        <string>%1$d items. You should buy them</string>
    </dict>
    <key>second</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>@</string>
        <key>other</key>
        <string>%2$@</string>
    </dict>
    <key>third</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>@</string>
        <key>other</key>
        <string>%3$@</string>
    </dict>
</dict>
```

</details>

### Not supported

<details>

<summary>Nested format keys in variables</summary>

```xml
<key>nested.formatkey-in-variable</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%#@geese@</string>
    <key>geese</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>A goose landed on %#@goose_fields@</string>
        <key>other</key>
        <string>%d geese landed on %#@geese_fields@</string>
    </dict>
    <key>goose_fields</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>its own field</string>
        <key>other</key>
        <string>its own %d fields</string>
    </dict>
    <key>geese_fields</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>their shared field</string>
        <key>other</key>
        <string>their %d fields</string>
    </dict>
</dict>
```

</details>