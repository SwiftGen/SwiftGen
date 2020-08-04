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

| Option Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `separator` | `.` | Each key is separated into components using the given separator, to form a structure as described in the [explanation above](#input). |

## Templates

* [See here](../templates/strings) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/strings.md) to see what data is available after parsing.

## Plurals

SwiftGen supports definitions of plurals in `.stringsdict` files. (Note: only non-nested plural variables are supported for now)

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

<summary>Mixed placeholders and variables in format key</summary>

```xml
<key>mixed.placeholders-and-variables.string-int</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%@ %#@has_rating@</string>
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

```xml
<key>multiple.placeholders-and-variables.int-string-string</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <!-- Your <Grocery> list contains <3 items. You should buy them> <today>. -->
    <string>Your %3$@ list contains %1$#@first@ %2$@.</string>
    <key>first</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>zero</key>
        <string>no items. Add one</string>
        <key>one</key>
        <string>one item. You should buy it</string>
        <key>other</key>
        <string>%1$d items. You should buy them</string>
    </dict>
</dict>
```

</details>

<details>

<summary>Multiple variables in format key</summary>

```xml
<key>multiple.variables.three-variables-in-formatkey</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%#@files@ (%#@bytes@, %#@minutes@)</string>
    <key>files</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>%d file remaining</string>
        <key>other</key>
        <string>%d files remaining</string>
    </dict>
    <key>bytes</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>%d byte</string>
        <key>other</key>
        <string>%d bytes</string>
    </dict>
    <key>minutes</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>one</key>
        <string>%d minute</string>
        <key>other</key>
        <string>%d minutes</string>
    </dict>
</dict>
```

</details>

### Not supported

<details>

<summary>Nested format keys in variables</summary>

Note: in practice this should hopefully be very rare. Especially, if you're using tools like Lokalize, PhraseApp, POEditor, or similar to export your `stringsdict`, it's unlikely that they'll ever generate that kind of convoluted structure for your `stringsdict`.

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
        <!-- This uses a nested key, i.e. you're referencing goose_fields variable inside the definition of geese variable -->
        <!-- This is currently not properly supported as it's not parsed recursively by SwiftGen. -->
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


<details>

<summary>Placeholders that are only used in the variables but not in the format key</summary>

This plural entry would work with plain `NSLocalizedString`, as Foundation will pass the whole list of arguments to each substituted format specifier – e.g. in this case passing a `String` and an `Int` would work with `NSLocalizedString`.  
But SwiftGen only parses the `NSStringLocalizedFormatKey` in a `stringsdict` to find possible placeholders, because parsing all possible plural rules for placeholders as well could result in different amounts of placeholders for different amounts or different languages.

```xml
<key>unsupported-use.placeholders-in-variable-rule.string-int</key>
<dict>
    <key>NSStringLocalizedFormatKey</key>
    <string>%#@elements@</string>
    <key>elements</key>
    <dict>
        <key>NSStringFormatSpecTypeKey</key>
        <string>NSStringPluralRuleType</string>
        <key>NSStringFormatValueTypeKey</key>
        <string>d</string>
        <key>zero</key>
        <string>%@ has no rating</string>
        <key>one</key>
        <string>%@ has one rating</string>
        <key>other</key>
        <string>%@ has %d ratings</string>
    </dict>
</dict>
```

</details>
