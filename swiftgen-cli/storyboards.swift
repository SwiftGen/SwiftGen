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
  templateOption("storyboards"), templatePathOption,
  Option<String>("sceneEnumName", "StoryboardScene", flag: "e",
    description: "The name of the enum to generate for Scenes"),
  Option<String>("segueEnumName", "StoryboardSegue", flag: "g",
    description: "The name of the enum to generate for Segues"),
  Argument<Path>("PATH",
    description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
    validator: pathExists)
) { output, templateName, templatePath, sceneEnumName, segueEnumName, path in
  let parser = StoryboardParser()
  if path.`extension` == "storyboard" {
    parser.addStoryboardAtPath(String(path))
  } else {
    parser.parseDirectory(String(path))
  }

  do {
    let templateRealPath = try findTemplate(
      "storyboards",
      templateShortName: templateName,
      templateFullPath: templatePath
    )
    let template = try GenumTemplate(path: templateRealPath)
    let context = parser.stencilContext(sceneEnumName: sceneEnumName, segueEnumName: segueEnumName)
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch {
    printError("error: failed to render template \(error)")
  }
}
