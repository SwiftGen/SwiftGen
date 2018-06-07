//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

private let templateNameOption = Option<String>(
  "template",
  default: "",
  flag: "t",
  description: """
    The name of the template to use for code generation. \
    See `swiftgen templates list` for a list of available names
    """
)

private let templatePathOption = Option<String>(
  "templatePath",
  default: "",
  flag: "p",
  description: "The path of the template to use for code generation."
)

private let paramsOption = VariadicOption<String>(
  "param",
  default: [],
  description: "List of template parameters"
)

extension ParserCLI {
  func command() -> CommandType {
    return Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      VariadicArgument<Path>("PATH", description: self.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, paths in
      try ErrorPrettifier.execute {
        let parser = try self.parserType.init(options: [:]) { msg, _, _ in
          logMessage(.warning, msg)
        }
        try parser.parse(paths: paths)

        let templateRef = try TemplateRef(templateShortName: templateName,
                                          templateFullPath: templatePath)
        let templateRealPath = try templateRef.resolvePath(forSubcommand: self.templateFolder)

        let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                                environment: stencilSwiftEnvironment())

        let context = parser.stencilContext()
        let enriched = try StencilContext.enrich(context: context, parameters: parameters)
        let rendered = try template.render(enriched)
        try output.write(content: rendered, onlyIfChanged: true)
      }
    }
  }
}
