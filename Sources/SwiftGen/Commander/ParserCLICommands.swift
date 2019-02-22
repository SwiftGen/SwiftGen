//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

// deprecated option
private let deprecatedTemplateNameOption = Option<String>(
  "template",
  default: "",
  flag: "t",
  description: """
    DEPRECATED, use `--templateName` instead
    """
)

private let templateNameOption = Option<String>(
  "templateName",
  default: "",
  flag: "n",
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
  private var filterOption: Option<String> {
    return Option<String>(
      "filter",
      default: parserType.defaultFilter,
      flag: "f",
      description: "The regular expression to filter input paths."
    )
  }

  func command() -> CommandType {
    return Commander.command(
      outputOption,
      deprecatedTemplateNameOption,
      templateNameOption,
      templatePathOption,
      paramsOption,
      filterOption,
      VariadicArgument<Path>("PATH", description: self.pathDescription, validator: pathsExist)
    ) { output, oldTemplateName, templateName, templatePath, parameters, filter, paths in
      try ErrorPrettifier.execute {
        let parser = try self.parserType.init(options: [:]) { msg, _, _ in
          logMessage(.warning, msg)
        }
        let filter = try Filter(pattern: filter)
        try parser.searchAndParse(paths: paths, filter: filter)

        let resolvedTemplateName = templateName.isEmpty ? oldTemplateName : templateName
        let templateRef = try TemplateRef(
          templateShortName: resolvedTemplateName,
          templateFullPath: templatePath
        )
        let templateRealPath = try templateRef.resolvePath(forSubcommand: self.templateFolder)

        let template = try StencilSwiftTemplate(
          templateString: templateRealPath.read(),
          environment: stencilSwiftEnvironment()
        )

        let context = parser.stencilContext()
        let enriched = try StencilContext.enrich(context: context, parameters: parameters)
        let rendered = try template.render(enriched)
        try output.write(content: rendered, onlyIfChanged: true)
      }
    }
  }
}
