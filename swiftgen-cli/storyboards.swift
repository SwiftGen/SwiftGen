//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let storyboardsCommand = command(
  outputOption,
  templateOption(prefix: "storyboards"), templatePathOption,
  Option<String>("sceneEnumName", "StoryboardScene", flag: "e",
    description: "The name of the enum to generate for Scenes"),
  Option<String>("segueEnumName", "StoryboardSegue", flag: "g",
    description: "The name of the enum to generate for Segues"),
  Options<String>("import", [], count: 0,
		description: "Additional imports to be added to the generated file"),
  Argument<Path>("PATH",
    description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
    validator: pathExists)
) { output, templateName, templatePath, sceneEnumName, segueEnumName, extraImports, path in
  let parser = StoryboardParser()
  if path.`extension` == "storyboard" {
    parser.addStoryboardAtPath(String(describing: path))
  } else {
    parser.parseDirectory(String(describing: path))
  }

  do {
    let templateRealPath = try findTemplate(
      prefix: "storyboards",
      templateShortName: templateName,
      templateFullPath: templatePath
    )
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(
      sceneEnumName: sceneEnumName, segueEnumName: segueEnumName, extraImports: extraImports
    )
    let rendered = try template.render(context)
    output.write(content: rendered, onlyIfChanged: true)
  } catch {
    printError(string: "error: failed to render template \(error)")
  }
}
