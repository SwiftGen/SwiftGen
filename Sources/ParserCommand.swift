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
  let parser: Parser.Type
  let command: CommandType

  init(parser: Parser.Type) {
    self.parser = parser
    self.command = Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      VariadicArgument<Path>("PATH", description: parser.commandInfo.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, paths in

      try ParserCommand.execute(parserType: parser,
                                output: output,
                                templateName: templateName,
                                templatePath: templatePath,
                                parameters: parameters,
                                paths: paths)
    }
  }

  init(parser: Parser.Type,
       deprecatedOption: Option<String>,
       deprecatedHandler: @escaping (String) throws -> Void) {
    self.parser = parser
    self.command = Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      deprecatedOption,
      VariadicArgument<Path>("PATH", description: parser.commandInfo.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, deprecated, paths in

      try deprecatedHandler(deprecated)

      try ParserCommand.execute(parserType: parser,
                                output: output,
                                templateName: templateName,
                                templatePath: templatePath,
                                parameters: parameters,
                                paths: paths)
    }
  }

  init(parser: Parser.Type,
       deprecatedOption1: Option<String>,
       deprecatedOption2: Option<String>,
       deprecatedHandler: @escaping (String, String) throws -> Void) {
    self.parser = parser
    self.command = Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      deprecatedOption1,
      deprecatedOption2,
      VariadicArgument<Path>("PATH", description: parser.commandInfo.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, deprecated1, deprecated2, paths in

      try deprecatedHandler(deprecated1, deprecated2)

      try ParserCommand.execute(parserType: parser,
                                output: output,
                                templateName: templateName,
                                templatePath: templatePath,
                                parameters: parameters,
                                paths: paths)
    }
  }

  // swiftlint:disable:next function_parameter_count
  private static func execute(parserType: Parser.Type,
                              output: OutputDestination,
                              templateName: String,
                              templatePath: String,
                              parameters: [String],
                              paths: [Path]) throws {

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
