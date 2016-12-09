//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit
import Stencil

let colorsCommand = command(
  outputOption,
  templateOption(prefix: "colors"), templatePathOption,
  Option<String>("enumName", "ColorName", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Colors.txt|.clr|.xml|.json file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, path in

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
    let template = try GenumTemplate(templateString: templateRealPath.read(), environment: genumEnvironment())
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: failed to render template \(error)")
  }
}
