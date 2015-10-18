//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let colorsCommand = command(
  outputOption, templateOption("colors.stencil"),
  Argument<Path>("FILE", description: "Colors.txt file to parse.", validator: fileExists)
) { output, template, path in
  let enumBuilder = ColorEnumBuilder()
  
  do {
    try enumBuilder.parseTextFile(String(path))
    
    let template = try GenumTemplate(path: try fileExists(path: template))
    let rendered = try template.render(enumBuilder.stencilContext())
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
