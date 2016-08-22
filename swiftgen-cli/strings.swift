//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let stringsCommand = command(
  outputOption,
  templateOption("strings"), templatePathOption,
  Option<String>("enumName", "L10n", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Localizable.strings file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, path in
  let parser = StringsFileParser()

  do {
    try parser.parseStringsFile(String(path))

    let templateRealPath = try findTemplate("strings", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName, tableName: path.lastComponentWithoutExtension)
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError("error: \(error.localizedDescription)")
  }
}
