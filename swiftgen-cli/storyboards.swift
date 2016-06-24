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
  Option<String>("cellEnumName", "StoryboardCell", flag: "g",
    description: "The name of the enum to generate for Cells"),
  Argument<Path>("PATH",
    description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
    validator: pathExists)
) { output, templateName, templatePath, sceneEnumName, segueEnumName, cellEnumName, path in
  let parser = StoryboardParser()
  if let `extension` = path.`extension` where ["storyboard", "xib"].contains(`extension`) {
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
    let context = parser.stencilContext(sceneEnumName: sceneEnumName,
                                        segueEnumName: segueEnumName,
                                        cellEnumName: cellEnumName)
    let rendered = try template.render(context)
    output.write(rendered, onlyIfChanged: true)
  } catch {
    print("Failed to render template \(error)")
  }
}
