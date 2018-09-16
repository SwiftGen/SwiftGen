# Colors parser

## Input

The colors parser supports multiple input file types:

 - CLR: NSColor​List palette file ([see docs](https://developer.apple.com/reference/appkit/nscolorlist)). When you create color palettes in image editors or in Xcode, these are stored in `~/Library/Colors`.
 - JSON: Simple root object where each key is the name, each value is a hex color string.
 - TXT: Each line has a name and a color, separated by a `:`. A color can either be a color hex value, or the name of another color in the file.
 - XML: Android colors.xml file parser ([see docs](https://developer.android.com/guide/topics/resources/more-resources.html#Color)).

## Output

The output context has the following structure:

 - `palettes`: `Array` of:
   - `name`  : `String` — name of the palette
   - `colors`: `Array` of:
     - `name` : `String` — name of each color
     - `red`  : `String` — hex value of the red component
     - `green`: `String` — hex value of the green component
     - `blue` : `String` — hex value of the blue component
     - `alpha`: `String` — hex value of the alpha component

## Example

```yaml
palettes:
- colors:
  - alpha: "ff"
    blue: "66"
    green: "96"
    name: "ArticleBody"
    red: "33"
  - alpha: "ff"
    blue: "cc"
    green: "66"
    name: "ArticleFootnote"
    red: "ff"
  - alpha: "ff"
    blue: "66"
    green: "fe"
    name: "ArticleTitle"
    red: "33"
  - alpha: "cc"
    blue: "ff"
    green: "ff"
    name: "private"
    red: "ff"
  name: "colors"
```
