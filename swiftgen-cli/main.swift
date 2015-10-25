//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import GenumKit
import PathKit

// MARK: Common

let TEMPLATES_RELATIVE_PATH = "../templates"

let outputOption = Option("output", OutputDestination.Console, flag: "o", description: "The path to the file to generate. Use - to generate in stdout")

func templateOption(name: String) -> Option<Path> {
  let defaultTemplateRelativePath = Path(TEMPLATES_RELATIVE_PATH) + name
  let defaultTemplate = Path(NSProcessInfo.processInfo().arguments[0]).parent() + defaultTemplateRelativePath
  return Option<Path>("template",
    defaultTemplate,
    flag: "t",
    description: "The template to use for code generation. (defaults to $swiftgen/\(defaultTemplateRelativePath))",
    validator: fileExists)
}


// MARK: - Main

let main = Group {
  $0.addCommand("colors", colorsCommand)
  $0.addCommand("images", imagesCommand)
  $0.addCommand("storyboards", storyboardsCommand)
  $0.addCommand("strings", stringsCommand)
}

let version = NSBundle(forClass: GenumKit.GenumTemplate.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
main.run("SwiftGen v\(version)")
