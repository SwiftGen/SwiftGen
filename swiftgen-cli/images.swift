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
  Argument<Path>("DIR", description: "Directory to scan for .imageset files.", validator: dirExists)
) { output, templateName, templatePath, enumName, path in
  guard path.extension == "xcassets" else {
    throw ArgumentError.invalidType(value: String(describing: path), type: "xcassets file", argument: nil)
  }

  let parser = AssetsCatalogParser()
  parser.parseCatalog(at: path)

  do {
    let templateRealPath = try findTemplate(
      prefix: "images", templateShortName: templateName, templateFullPath: templatePath
    )
    let template = try GenumTemplate(templateString: templateRealPath.read(), environment: genumEnvironment())
    let context = parser.context(enumName: enumName)
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: failed to render template \(error)")
  }
}
