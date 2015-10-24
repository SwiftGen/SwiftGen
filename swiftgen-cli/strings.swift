//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let stringsCommand = command(
  outputOption, templateOption("strings.stencil"),
  Argument<Path>("FILE", description: "Localizable.strings file to parse.", validator: fileExists)
) { output, template, path in
  let enumBuilder = StringEnumBuilder()
  
  do {
    try enumBuilder.parseLocalizableStringsFile(String(path))
    
    let template = try GenumTemplate(path: try fileExists(path: template))
    let rendered = try template.render(enumBuilder.stencilContext())
    output.write(rendered)
  }
  catch let error as NSError {
    print("Error: \(error.localizedDescription)")
  }
}
