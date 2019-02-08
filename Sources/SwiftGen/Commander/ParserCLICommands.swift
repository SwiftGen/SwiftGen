//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

extension ParserCLI {
  private enum CLIOption {
    // deprecated option
    static let deprecatedTemplateName = Option<String>(
      "template",
      default: "",
      flag: "t",
      description: """
        DEPRECATED, use `--templateName` instead
        """
    )

    static func filter(for parser: ParserCLI) -> Option<String> {
      return Option<String>(
        "filter",
        default: parser.parserType.defaultFilter,
        flag: "f",
        description: "The regular expression to filter input paths."
      )
    }

    static func options(for parser: ParserCLI) -> VariadicOption<String> {
      return VariadicOption<String>(
        "option",
        default: [],
        description: "List of parser options. \(parser.parserType.allOptions)"
      )
    }

    static let params = VariadicOption<String>(
      "param",
      default: [],
      description: "List of template parameters"
    )

    static let templateName = Option<String>(
      "templateName",
      default: "",
      flag: "n",
      description: """
        The name of the template to use for code generation. \
        See `swiftgen templates list` for a list of available names
        """
    )

    static let templatePath = Option<String>(
      "templatePath",
      default: "",
      flag: "p",
      description: "The path of the template to use for code generation."
    )
  }
}

extension ParserCLI {
  func command() -> CommandType {
    return Commander.command(
      CLIOption.deprecatedTemplateName,
      CLIOption.templateName,
      CLIOption.templatePath,
      CLIOption.options(for: self),
      CLIOption.params,
      CLIOption.filter(for: self),
      OutputDestination.cliOption,
      VariadicArgument<Path>("PATH", description: self.pathDescription, validator: pathsExist)
    ) { oldTemplateName, templateName, templatePath, parserOptions, parameters, filter, output, paths in
      try ErrorPrettifier.execute {
        let options = try Parameters.parse(items: parserOptions)
        try self.parserType.allOptions.check(options: options)
        let parser = try self.parserType.init(options: options) { msg, _, _ in
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
