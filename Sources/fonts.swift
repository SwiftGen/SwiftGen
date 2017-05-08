//
//  SwiftGen
//  Created by Derek Ostrander on 3/10/16.
//  Copyright (c) 2015 Olivier Halligon
//  MIT License
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let fontsCommand = command(
  outputOption,
  templateOption(prefix: "fonts"), templatePathOption,
  Option<String>("enumName", "", flag: "e", description: "The name of the enum to generate (DEPRECATED)"),
  VariadicOption<String>("param", [], description: "List of template parameters"),
  VariadicArgument<Path>("DIR", description: "Directory to parse.", validator: dirsExist)
  ) { output, templateName, templatePath, enumName, parameters, paths in
    // show error for old deprecated option
    guard enumName.isEmpty else {
      throw TemplateError.deprecated(option: "enumName", replacement: "Please use '--param enumName=...' instead.")
    }
    let parser = FontsFileParser()
    do {
      for path in paths {
        parser.parseFile(at: path)
      }

      let templateRealPath = try findTemplate(
        prefix: "fonts", templateShortName: templateName, templateFullPath: templatePath
      )

      let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                              environment: stencilSwiftEnvironment())
      let context = parser.stencilContext()
      let enriched = try StencilContext.enrich(context: context, parameters: parameters)
      let rendered = try template.render(enriched)
      output.write(content: rendered, onlyIfChanged: true)
    } catch let error as NSError {
      printError(string: "error: \(error.localizedDescription)")
    }
}
