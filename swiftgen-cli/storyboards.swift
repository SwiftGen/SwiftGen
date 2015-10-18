//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let storyboardsCommand = command(
  outputOption, templateOption("storyboards.stencil"),
  Argument<Path>("PATH", description: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard", validator: pathExists)
) { output, template, path in
  let enumBuilder = StoryboardEnumBuilder()
  if path.`extension` == "storyboard" {
    enumBuilder.addStoryboardAtPath(String(path))
  }
  else {
    enumBuilder.parseDirectory(String(path))
  }
  
  do {
    let template = try GenumTemplate(path: try fileExists(path: template))
    let rendered = try template.render(enumBuilder.stencilContext())
    output.write(rendered)
  } catch {
    print("Failed to render template \(error)")
  }
}
