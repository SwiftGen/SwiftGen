//
//  ParserCommand.swift
//  SwiftGen
//
//  Created by David Jennes on 07/06/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let templateNameOption = Option<String>(
  "template", "", flag: "t",
  description: "The name of the template to use for code generation " +
  "(without the extension)."
)

let templatePathOption = Option<String>(
  "templatePath", "", flag: "p",
  description: "The path of the template to use for code generation. Overrides -t."
)

let paramsOption = VariadicOption<String>(
  "param", [],
  description: "List of template parameters"
)

struct ParserCommand {
  let parserType: Parser.Type
  let command: CommandType

  init(parserType: Parser.Type) {
    self.parserType = parserType
    self.command = Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      VariadicArgument<Path>("PATH", description: parserType.commandInfo.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, paths in
      let parser = try parserType.init(options: [:]) { msg, _, _ in
        printError(string: msg)
      }
      try parser.parse(paths: paths)

      do {
        let templateRealPath = try findTemplate(subcommand: parserType.commandInfo.name,
                                                templateShortName: templateName,
                                                templateFullPath: templatePath)

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
  }
}
