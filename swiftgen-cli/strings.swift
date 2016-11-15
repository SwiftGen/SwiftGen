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
  templateOption(prefix: "strings"), templatePathOption,
  Option<String>("enumName", "L10n", flag: "e", description: "The name of the enum to generate"),
  Argument<Path>("FILE", description: "Localizable.strings file to parse.", validator: fileExists)
) { output, templateName, templatePath, enumName, path in
  let parser = StringsFileParser()

  do {
    try parser.parseFile(at: String(describing: path))

    let templateRealPath = try findTemplate(prefix: "strings", templateShortName: templateName, templateFullPath: templatePath)
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(enumName: enumName, tableName: path.lastComponentWithoutExtension)
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch let error as NSError {
    printError(string: "error: \(error.localizedDescription)")
  }
}
