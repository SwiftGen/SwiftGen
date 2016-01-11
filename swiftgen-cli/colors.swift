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
  Option<String>("enumName", "Name", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Colors.txt|.clr file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, path in

  let filePath = String(path)

  let parser: ColorsFileParser
  if filePath.hasSuffix("clr") {
    let clrParser = CLRFileParser()
    clrParser.parseFile(filePath)
    parser = clrParser
  } else {
    let textParser = ColorsTextFileParser()
    try textParser.parseTextFile(filePath)
    parser = textParser
  }

  do {
    let templateRealPath = try findTemplate("colors", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName)
    let rendered = try template.render(context)
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
