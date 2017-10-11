//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
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

let templatePathOption = Option<Path>(
  "templatePath", "", flag: "p",
  description: "The path of the template to use for code generation. Overrides -t.",
  validator: checkPath(type: "template file") { $0.isFile }
)

let paramsOption = VariadicOption<String>(
  "param", [],
  description: "List of template parameters"
)

extension ParserCommand {
  func command() -> CommandType {
    return Commander.command(
      outputOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      VariadicArgument<Path>("PATH", description: self.pathDescription, validator: pathsExist)
    ) { output, templateName, templatePath, parameters, paths in
      let parser = try self.parserType.init(options: [:]) { msg, _, _ in
        printError(string: msg)
      }
      try parser.parse(paths: paths)

      do {
        let templateRef = try TemplateRef(templateShortName: templateName,
                                                templateFullPath: templatePath)
        let templateRealPath = try templateRef.resolvePath(forSubcommand: self.name)

        let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                                environment: stencilSwiftEnvironment())

        let context = parser.stencilContext()
        let enriched = try StencilContext.enrich(context: context, parameters: parameters)
        let rendered = try template.render(enriched)
        output.write(content: rendered, onlyIfChanged: true)
      } catch let error as TemplateRef.Error {
        printError(string: "error: \(error)")
      } catch let error {
        printError(string: "error: failed to render template: \(error)")
      }
    }
  }
}
