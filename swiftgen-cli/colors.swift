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
  templateOption("colors"), templatePathOption,
  Option<String>("enumName", "ColorName", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Colors.txt|.clr|.xml|.json file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, path in

  let filePath = String(path)

  let parser: ColorsFileParser
  switch path.`extension` {
  case "clr"?:
    let clrParser = ColorsCLRFileParser()
    clrParser.parseFile(filePath)
    parser = clrParser
  case "txt"?:
    let textParser = ColorsTextFileParser()
    try textParser.parseFile(filePath)
    parser = textParser
  case "xml"?:
    let textParser = ColorsXMLFileParser()
    try textParser.parseFile(filePath)
    parser = textParser
  case "json"?:
    let textParser = ColorsJSONFileParser()
    try textParser.parseFile(filePath)
    parser = textParser
  default:
    throw ArgumentError.InvalidType(value: filePath, type: "CLR, TXT, XML or JSON file", argument: nil)
  }

  do {
    let templateRealPath = try findTemplate("colors", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch {
    printError("error: failed to render template \(error)")
  }
}
