//
//  CustomCommands.swift
//  swiftgen
//
//  Created by Philippe Bernery on 15/01/2018.
//  Copyright © 2018 Backelite. All rights reserved.
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

private let templatePathOption = Option<String>(
  "templatePath", default: "", flag: "p",
  description: "The path of the template to use for code generation."
)

private let paramsOption = VariadicOption<String>(
  "param", default: [],
  description: "List of template parameters"
)

let customCommand = Commander.command(
  outputOption,
  templatePathOption,
  paramsOption
) { output, templatePath, parameters in
  try ErrorPrettifier.execute {
    let templateRef = try TemplateRef(templateShortName: "",
                                      templateFullPath: templatePath)
    let templateRealPath = try templateRef.resolvePath()

    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())

    let enriched = try StencilContext.enrich(context: [:], parameters: parameters)
    let rendered = try template.render(enriched)
    try output.write(content: rendered, onlyIfChanged: true)
  }
}
