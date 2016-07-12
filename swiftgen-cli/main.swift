//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import GenumKit
import PathKit

// MARK: Common

let templatesRelativePath = "../templates"


func templateOption(prefix: String) -> Option<String> {
  return Option<String>(
    "template", "default", flag: "t",
    description: "The name of the template to use for code generation " +
      "(without the \"\(prefix)\" prefix nor extension)."
  )
}

let templatePathOption = Option<String>(
  "templatePath", "", flag: "p",
  description: "The path of the template to use for code generation. Overrides -t."
)

let outputOption = Option(
  "output", OutputDestination.Console, flag: "o",
  description: "The path to the file to generate (Omit to generate to stdout)"
)

// MARK: - Main

let main = Group {
  $0.group("templates", "manage custom templates") {
    $0.addCommand("list", "list bundled and custom templates", templatesListCommand)
    $0.addCommand("which", "print path of a given named template", templatesWhichCommand)
    $0.addCommand("cat", "print content of a given named template", templatesCatCommand)
  }
  $0.addCommand("colors", "generate code for UIColors", colorsCommand)
  $0.addCommand("images", "generate code for UIImages based on your Assets Catalog", imagesCommand)
  $0.addCommand("storyboards", "generate code for your Storyboard scenes and segues", storyboardsCommand)
  $0.addCommand("strings", "generate code for your Localizable.strings", stringsCommand)
  $0.addCommand("fonts", "generate code for your UIFonts", fontsCommand)
}

let version = NSBundle(forClass: GenumKit.GenumTemplate.self)
  .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
main.run("SwiftGen v\(version)")
