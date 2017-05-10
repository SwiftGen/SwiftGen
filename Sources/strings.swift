//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let stringsCommand = command(
  outputOption, templateNameOption, templatePathOption, paramsOption,
  Option<String>("enumName", "", flag: "e", description: "The name of the enum to generate (DEPRECATED)"),
  Argument<Path>("FILE", description: "Localizable.strings file to parse.", validator: fileExists)
) { output, templateName, templatePath, parameters, enumName, path in
  // show error for old deprecated option
  guard enumName.isEmpty else {
    throw TemplateError.deprecated(option: "enumName", replacement: "Please use '--param enumName=...' instead.")
  }
  let parser = StringsFileParser()

  do {
    try parser.parseFile(at: path)

    let templateRealPath = try findTemplate(
      subcommand: "strings", templateShortName: templateName, templateFullPath: templatePath
    )
    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())
    let context = parser.stencilContext(tableName: path.lastComponentWithoutExtension)
    let enriched = try StencilContext.enrich(context: context, parameters: parameters)
    let rendered = try template.render(enriched)
    output.write(content: rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError(string: "error: \(error.localizedDescription)")
  }
}
