//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit
import Stencil

let colorsCommand = command(
    outputOption, templateOption("colors.stencil"),
    Argument<Path>("FILE", description: "Colors.txt file to parse.", validator: fileExists)
) { output, template, path in
  let enumBuilder = ColorEnumBuilder()

  do {
    try enumBuilder.parseTextFile(String(path))
    
    let template = try Template(path: try fileExists(path: template))
    template.parser.registerTag("identifier", parser: IdentifierNode.parse)
    
    let rendered = try template.render(enumBuilder.stencilContext())
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
