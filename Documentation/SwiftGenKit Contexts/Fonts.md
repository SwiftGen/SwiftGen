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
