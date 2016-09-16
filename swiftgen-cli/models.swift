//
//  SwiftGen
//  Created by Peter Livesey on 9/16/16.
//  Copyright (c) 2015 Olivier Halligon
//  MIT License
//

import Commander
import PathKit
import GenumKit

let modelsCommand = command(
  outputOption,
  templateOption("models"), templatePathOption,
  Option<String>("enumName", "FontFamily", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("DIR", description: "Directory to parse.", validator: dirExists)
) { output, templateName, templatePath, enumName, path in
  let parser = ModelsJSONFileParser()
  do {
    try parser.parseDirectory(String(path))
    let templateRealPath = try findTemplate("models", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext()
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError("error: \(error.localizedDescription)")
  }
}
