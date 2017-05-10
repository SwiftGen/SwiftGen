//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

let storyboardsCommand = command(
  outputOption, templateNameOption, templatePathOption, paramsOption,
  Option<String>("sceneEnumName", "", flag: "e",
    description: "The name of the enum to generate for Scenes (DEPRECATED)"),
  Option<String>("segueEnumName", "", flag: "g",
    description: "The name of the enum to generate for Segues (DEPRECATED)"),
  // Note: import option is deprecated.
  VariadicOption<String>("import", [],
    description: "Additional imports to be added to the generated file (DEPRECATED)"),
  VariadicArgument<Path>("PATH",
    description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
    validator: pathsExist)
) { output, templateName, templatePath, parameters, sceneEnumName, segueEnumName, _, paths in
  // show error for old deprecated option
  guard sceneEnumName.isEmpty else {
    throw TemplateError.deprecated(option: "sceneEnumName",
                                   replacement: "Please use '--param sceneEnumName=...' instead.")
  }
  guard segueEnumName.isEmpty else {
    throw TemplateError.deprecated(option: "segueEnumName",
                                   replacement: "Please use '--param segueEnumName=...' instead.")
  }
  let parser = StoryboardParser()

  do {
    for path in paths {
      if path.extension == "storyboard" {
        try parser.addStoryboard(at: path)
      } else {
        try parser.parseDirectory(at: path)
      }
    }

    let templateRealPath = try findTemplate(
      subcommand: "storyboards",
      templateShortName: templateName,
      templateFullPath: templatePath
    )
    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())
    let context = parser.stencilContext()
    let enriched = try StencilContext.enrich(context: context, parameters: parameters)
    let rendered = try template.render(enriched)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: \(error.localizedDescription)")
  }
}
