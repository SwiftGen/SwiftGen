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

func parserCommand(name: String,
                   parser parserType: Parser.Type,
                   pathDescription: String,
                   pathValidator: @escaping PathValidator = pathsExist) -> CommandType {

  return command(
    outputOption,
    templateNameOption,
    templatePathOption,
    paramsOption,
    VariadicArgument<Path>("PATH", description: pathDescription, validator: pathValidator)
  ) { output, templateName, templatePath, parameters, paths in

    try executeCommand(name: name,
                       parserType: parserType,
                       output: output,
                       templateName: templateName,
                       templatePath: templatePath,
                       parameters: parameters,
                       paths: paths)
  }
}

func parserCommand(name: String,
                   parser parserType: Parser.Type,
                   pathDescription: String,
                   pathValidator: @escaping PathValidator = pathsExist,
                   deprecatedOption: Option<String>,
                   deprecatedHandler: @escaping (String) throws -> Void) -> CommandType {

  return command(
    outputOption,
    templateNameOption,
    templatePathOption,
    paramsOption,
    deprecatedOption,
    VariadicArgument<Path>("PATH", description: pathDescription, validator: pathValidator)
  ) { output, templateName, templatePath, parameters, deprecated, paths in

    try deprecatedHandler(deprecated)

    try executeCommand(name: name,
                       parserType: parserType,
                       output: output,
                       templateName: templateName,
                       templatePath: templatePath,
                       parameters: parameters,
                       paths: paths)
  }
}

// swiftlint:disable:next function_parameter_count
func parserCommand(name: String,
                   parser parserType: Parser.Type,
                   pathDescription: String,
                   pathValidator: @escaping PathValidator = pathsExist,
                   deprecatedOption1: Option<String>,
                   deprecatedOption2: Option<String>,
                   deprecatedHandler: @escaping (String, String) throws -> Void) -> CommandType {

  return command(
    outputOption,
    templateNameOption,
    templatePathOption,
    paramsOption,
    deprecatedOption1,
    deprecatedOption2,
    VariadicArgument<Path>("PATH", description: pathDescription, validator: pathValidator)
  ) { output, templateName, templatePath, parameters, deprecated1, deprecated2, paths in

    try deprecatedHandler(deprecated1, deprecated2)

    try executeCommand(name: name,
                       parserType: parserType,
                       output: output,
                       templateName: templateName,
                       templatePath: templatePath,
                       parameters: parameters,
                       paths: paths)
  }
}

// swiftlint:disable:next function_parameter_count
private func executeCommand(name: String,
                            parserType: Parser.Type,
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
    let templateRealPath = try findTemplate(subcommand: name,
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
