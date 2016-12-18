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
  templateOption(prefix: "fonts"), templatePathOption,
  Option<String>("enumName", "FontFamily", flag: "e", description: "The name of the enum to generate"),
  VariadicArgument<Path>("DIR", description: "Directory to parse.", validator: dirsExist)
  ) { output, templateName, templatePath, enumName, paths in
    let parser = FontsFileParser()
    do {
      for path in paths {
        parser.parseFile(at: path)
      }

      let templateRealPath = try findTemplate(
        prefix: "fonts", templateShortName: templateName, templateFullPath: templatePath
      )

      let template = try GenumTemplate(templateString: templateRealPath.read(), environment: genumEnvironment())
      let context = parser.stencilContext(enumName: enumName)
      let rendered = try template.render(context)
      output.write(content: rendered, onlyIfChanged: true)
    } catch let error as NSError {
      printError(string: "error: \(error.localizedDescription)")
    }
}
