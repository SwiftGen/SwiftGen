//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let nibsCommand = command(
  outputOption,
  templateOption("nibs"), templatePathOption,
  Option<String>("enumName", "Nib", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("PATH", description: "Directory to scan for .xib files. Can also be a path to a single .xib", validator: pathExists)
  ) { output, templateName, templatePath, enumName, path in
    let parser = XibParser()
    parser.parseDirectory(String(path))
    
    do {
      let templateRealPath = try findTemplate("nibs", templateShortName: templateName, templateFullPath: templatePath)
      let template = try GenumTemplate(path: templateRealPath)
      let context = parser.stencilContext(enumName: enumName)
      let rendered = try template.render(context)
      output.write(rendered, onlyIfChanged: true)
    } catch {
      print("Failed to render template \(error)")
    }
}
