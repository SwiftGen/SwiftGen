# Fonts parser

## Input

The fonts parser accepts a directory, which it'll recursively search for font files. Supported file types depend on the target platform, for example iOS only supports TTF and OTF font files.

## Output

The output context has the following structure:

 - `families`: `Array` — list of font families
   - `name` : `String` — name of the font family
   - `fonts`: `Array` — list of fonts in the font family
     - `name` : `String` — the font's postscript name
     - `path` : `String` — the path to the font, relative to the folder being scanned
     - `style`: `String` — the designer's description of the font's style, like "bold", "oblique", …

## Example

```yaml
families:
- fonts:
  - name: ".SFNSDisplay-Black"
    path: "Fonts/SFNSDisplay-Black.otf"
    style: "Black"
  - name: ".SFNSDisplay-Bold"
    path: "Fonts/SFNSDisplay-Bold.otf"
    style: "Bold"
  - name: ".SFNSDisplay-Heavy"
    path: "Fonts/SFNSDisplay-Heavy.otf"
    style: "Heavy"
  - name: ".SFNSDisplay-Regular"
    path: "Fonts/SFNSDisplay-Regular.otf"
    style: "Regular"
  name: ".SF NS Display"
- fonts:
  - name: ".SFNSText-Bold"
    path: "Fonts/SFNSText-Bold.otf"
    style: "Bold"
  - name: ".SFNSText-Heavy"
    path: "Fonts/SFNSText-Heavy.otf"
    style: "Heavy"
  - name: ".SFNSText-Regular"
    path: "Fonts/SFNSText-Regular.otf"
    style: "Regular"
  name: ".SF NS Text"
- fonts:
  - name: "Avenir-Black"
    path: "Fonts/Avenir.ttc"
    style: "Black"
  - name: "Avenir-BlackOblique"
    path: "Fonts/Avenir.ttc"
    style: "Black Oblique"
  - name: "Avenir-Book"
    path: "Fonts/Avenir.ttc"
    style: "Book"
  - name: "Avenir-Roman"
    path: "Fonts/Avenir.ttc"
    style: "Roman"
  name: "Avenir"
- fonts:
  - name: "ZapfDingbatsITC"
    path: "Fonts/ZapfDingbats.ttf"
    style: "Regular"
  name: "Zapf Dingbats"
- fonts:
  - name: "private"
    path: "Fonts/class.ttf"
    style: "internal"
  name: "public"
```
