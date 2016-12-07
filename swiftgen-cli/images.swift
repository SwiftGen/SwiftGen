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
  templateOption(prefix: "images"), templatePathOption,
  Option<String>("enumName", "Asset", flag: "e", description: "The name of the enum to generate"),
  VariadicArgument<Path>("PATHS", description: "Asset Catalog file(s)", validator: dirsExist)
) { output, templateName, templatePath, enumName, paths in
  let parser = AssetsCatalogParser()

  for path in paths {
    if path.extension == "xcassets" {
      parser.parseCatalog(at: path)
    } else {
      throw ArgumentError.invalidType(value: String(describing: path), type: "xcassets file", argument: nil)
    }
  }

  do {
    let templateRealPath = try findTemplate(
      prefix: "images", templateShortName: templateName, templateFullPath: templatePath
    )
    let template = try GenumTemplate(templateString: templateRealPath.read(), environment: genumEnvironment())
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: failed to render template \(error)")
  }
}
