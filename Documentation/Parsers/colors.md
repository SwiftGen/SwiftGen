# Colors parser

## Input

The colors parser supports multiple input file types:

 - CLR: NSColor​List palette file ([see docs](https://developer.apple.com/reference/appkit/nscolorlist)). When you create color palettes in image editors or in Xcode, these are stored in `~/Library/Colors`.
 - JSON: Simple root object where each key is the name, each value is a hex color string.
 - TXT: Each line has a name and a color, separated by a `:`. A color can either be a color hex value, or the name of another color in the file.
 - XML: Android colors.xml file parser ([see docs](https://developer.android.com/guide/topics/resources/more-resources.html#Color)).

### Filter

The default filter for this command is: `[^/]\.(?i:clr|json|txt|xml)$`. That means it'll accept any file with the extensions `clr`, `json`, `txt` or `xml`.

You can provide a custom filter using the `filter` option, it accepts any valid regular expression. See the [Config file documentation](../ConfigFile.md) for more information.

## Customization

| Option Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `colorFormat` | `rgba` | Each color value is interpreted using the given color format. The supported formats are: <ul><li>`rgba`: 8 hexadecimal digits, with each pair of the hexadecimal digits representing the values of the Red, Green, Blue and Alpha channel, respectively.</li><li>`argb`: 8 hexadecimal digits, with each pair of the hexadecimal digits representing the values of the Alpha, Red, Green and Blue channel, respectively.</li></ul> |

## Templates

* [See here](../templates/colors) for a list of templates bundled with SwiftGen and their documentation.
* If you want to write custom templates, make sure to check the [stencil context documentation](../SwiftGenKit%20Contexts/colors.md) to see what data is available after parsing.
