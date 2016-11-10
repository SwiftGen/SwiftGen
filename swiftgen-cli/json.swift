//
//  SwiftGen
//  Created by Peter Livesey on 9/16/16.
//  Copyright (c) 2015 Olivier Halligon
//  MIT License
//

import Commander
import PathKit
import GenumKit

let jsonCommand = command(
  outputOption,
  templateOption("json"),
  templatePathOption,
  Argument<Path>("FILE", description: "JSON to parse", validator: fileExists)
) { output, templateName, templatePath, path in
  let parser = JSONFileParser()
  do {
    try parser.parseFile(String(path))
    let templateRealPath = try findTemplate("json", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext()
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError("error: \(error.localizedDescription)")
  }
}
