//
//  plist.swift
//  SwiftGen
//
//  Created by Toshihiro Suzuki on 4/12/17.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let plistCommand = command(
  outputOption,
  templateOption(prefix: "plist"),
  templatePathOption,
  VariadicOption<String>("param", [], description: "List of template parameters"),
  VariadicArgument<Path>("PATHS", description: "Info.plist file(s)", validator: filesExist)
) { output, templateName, templatePath, parameters, paths in
  let parser = PlistParser()

  for path in paths {
    if path.extension == "plist" {
      parser.parse(at: path)
    } else {
      throw ArgumentError.invalidType(value: String(describing: path), type: "plist file", argument: nil)
    }
  }

  do {
    let templateRealPath = try findTemplate(
      prefix: "plist", templateShortName: templateName, templateFullPath: templatePath
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
