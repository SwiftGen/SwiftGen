//
//  SwiftGen
//  Created by Derek Ostrander on 3/10/16.
//  Copyright (c) 2015 Olivier Halligon
//  MIT License
//

import Commander
import PathKit
import GenumKit

let fontsCommand = command(
  outputOption,
  templateOption("fonts"), templatePathOption,
  Option<String>("enumName", "FontFamily", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("DIR", description: "Directory to parse.", validator: dirExists)
  ) { output, templateName, templatePath, enumName, path in
    let parser = FontsFileParser()
    do {
      parser.parseFonts(String(path))
      let templateRealPath = try findTemplate("fonts", templateShortName: templateName, templateFullPath: templatePath)
      let template = try GenumTemplate(path: templateRealPath)
      let context = parser.stencilContext(enumName: enumName)
      let rendered = try template.render(context)
      output.write(rendered, onlyIfChanged: true)
    } catch let error as NSError {
      printError("error: \(error.localizedDescription)")
    }
}
