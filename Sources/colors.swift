//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

let colorsCommand = command(
  outputOption,
  templateOption(prefix: "colors"), templatePathOption,
  Option<String>("enumName", "", flag: "e", description: "The name of the enum to generate (DEPRECATED)"),
  VariadicOption<String>("param", [], description: "List of template parameters"),
  Argument<Path>("FILE", description: "Colors.txt|.clr|.xml|.json file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, parameters, path in
  // show error for old deprecated option
  guard enumName.isEmpty else {
    throw TemplateError.deprecated(option: "enumName", replacement: "Please use '--param enumName=...' instead.")
  }

  let parser: ColorsFileParser
  switch path.extension {
  case "clr"?:
    let clrParser = ColorsCLRFileParser()
    try clrParser.parseFile(at: path)
    parser = clrParser
  case "txt"?:
    let textParser = ColorsTextFileParser()
    try textParser.parseFile(at: path)
    parser = textParser
  case "xml"?:
    let textParser = ColorsXMLFileParser()
    try textParser.parseFile(at: path)
    parser = textParser
  case "json"?:
    let textParser = ColorsJSONFileParser()
    try textParser.parseFile(at: path)
    parser = textParser
  default:
    throw ArgumentError.invalidType(value: path.description, type: "CLR, TXT, XML or JSON file", argument: nil)
  }

  do {
    let templateRealPath = try findTemplate(
      prefix: "colors", templateShortName: templateName, templateFullPath: templatePath
    )
    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())
    let context = parser.stencilContext()
    let enriched = try StencilContext.enrich(context: context, parameters: parameters)
    let rendered = try template.render(enriched)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: failed to render template \(error)")
  }
}
