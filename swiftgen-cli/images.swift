//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let imagesCommand = command(
  outputOption,
  templateOption("images.stencil"),
  Option<String>("enumName", "Asset", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("DIR", description: "Directory to scan for .imageset files.", validator: dirExists)
) { output, template, enumName, path in
  let parser = AssetsCatalogParser()
  parser.parseDirectory(String(path))
  
  do {
    let template = try GenumTemplate(path: try fileExists(path: template))
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
