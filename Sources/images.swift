//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let imagesCommand = command(
  outputOption,
  templateOption(prefix: "images"), templatePathOption,
  Option<String>("enumName", "", flag: "e", description: "The name of the enum to generate (DEPRECATED)"),
  VariadicOption<String>("param", [], description: "List of template parameters"),
  VariadicArgument<Path>("PATHS", description: "Asset Catalog file(s)", validator: dirsExist)
) { output, templateName, templatePath, enumName, parameters, paths in
  // show error for old deprecated option
  guard enumName.isEmpty else {
    throw TemplateError.deprecated(option: "enumName", replacement: "Please use '--param enumName=...' instead.")
  }
  let parser = AssetsCatalogParser()

  for path in paths {
    if path.extension == "xcassets" {
      parser.parseCatalog(at: path)
    } else {
      throw ArgumentError.invalidType(value: String(describing: path), type: "xcassets file", argument: nil)
    }
  }

  do {
    let templateRealPath = try findTemplate(
      prefix: "images", templateShortName: templateName, templateFullPath: templatePath
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
