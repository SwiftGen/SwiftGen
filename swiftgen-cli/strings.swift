//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let stringsCommand = command(
  outputOption,
  templateOption("strings.stencil"),
  Option<String>("enumName", "L10n", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Localizable.strings file to parse.", validator: fileExists)
) { output, template, enumName, path in
  let parser = StringsFileParser()
  
  do {
    try parser.parseStringsFile(String(path))
    
    let template = try GenumTemplate(path: try fileExists(path: template))
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered)
  }
  catch let error as NSError {
    print("Error: \(error.localizedDescription)")
  }
}
