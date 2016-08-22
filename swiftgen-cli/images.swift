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
  templateOption("images"), templatePathOption,
  Option<String>("enumName", "Asset", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("DIR", description: "Directory to scan for .imageset files.", validator: dirExists)
) { output, templateName, templatePath, enumName, path in
  let parser = AssetsCatalogParser()
  parser.parseDirectory(String(path))

  do {
    let templateRealPath = try findTemplate("images", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch {
    printError("error: failed to render template \(error)")
  }
}
