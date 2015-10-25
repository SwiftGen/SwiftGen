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
  let parser = ColorsFileParser()
  
  do {
    try parser.parseTextFile(String(path))
    
    let template = try GenumTemplate(path: try fileExists(path: template))
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
