//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let colorsCommand = command(
  outputOption,
  templateOption("colors.stencil"),
  Option<String>("enumName", "Name", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Colors.txt file to parse.", validator: fileExists)
) { output, template, enumName, path in
  let enumBuilder = ColorEnumBuilder()
  
  do {
    try enumBuilder.parseTextFile(String(path))
    
    let template = try GenumTemplate(path: try fileExists(path: template))
    let rendered = try template.render(enumBuilder.stencilContext(enumName: enumName))
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
