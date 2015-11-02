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

func templateOption(prefix: String) -> Option<String> {
  return Option<String>("template", "default", flag: "t", description: "The name of the template to use for code generation (without the \"\(prefix)\" prefix nor extension).")
}
let templatePathOption = Option<String>("templatePath", "", flag: "p", description: "The path of the template to use for code generation. Overrides -t.")
let outputOption = Option("output", OutputDestination.Console, flag: "o", description: "The path to the file to generate (Omit to generate to stdout)")

func findTemplate(prefix: String, templateShortName: String, templateFullPath: String) throws -> Path {
  guard templateFullPath.isEmpty else {
    return try fileExists(path: Path(templateFullPath))
  }
  let bundledTemplatesPath = Path(NSProcessInfo.processInfo().arguments[0]).parent() + TEMPLATES_RELATIVE_PATH
  let path = bundledTemplatesPath + "\(prefix)-\(templateShortName).stencil"
  return try fileExists(path: path)
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
