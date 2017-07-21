//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

// MARK: - All Parser Commands

let allParserCommands: [ParserCommand] = [
  ParserCommand(
    parserType: AssetsCatalogParser.self,
    name: "xcassets",
    description: "generate code for items in your Assets Catalog(s)",
    pathDescription: "Asset Catalog file(s)."
  ),
  ParserCommand(
    parserType: ColorsParser.self,
    name: "colors",
    description: "generate code for color palettes",
    pathDescription: "Colors.txt|.clr|.xml|.json file(s) to parse."
  ),
  ParserCommand(
    parserType: StringsParser.self,
    name: "strings",
    description: "generate code for your Localizable.strings file(s)",
    pathDescription: "Strings file(s) to parse."
  ),
  ParserCommand(
    parserType: StoryboardParser.self,
    name: "storyboards",
    description: "generate code for your storyboard scenes and segues",
    pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard"
  ),
  ParserCommand(
    parserType: FontsParser.self,
    name: "fonts",
    description: "generate code for your fonts",
    pathDescription: "Directory(ies) to parse."
  )
]

// MARK: Common

let templatesRelativePath: String
if let path = Bundle.main.object(forInfoDictionaryKey: "TemplatePath") as? String, !path.isEmpty {
  templatesRelativePath = path
} else if let path = Bundle.main.path(forResource: "templates", ofType: nil) {
  templatesRelativePath = path
} else {
  templatesRelativePath = "../templates"
}

let outputOption = Option(
  "output", OutputDestination.console, flag: "o",
  description: "The path to the file to generate (Omit to generate to stdout)"
)

// MARK: - Main

let main = Group {
  $0.group("templates", "manage custom templates") {
    $0.addCommand("list", "list bundled and custom templates", templatesListCommand)
    $0.addCommand("which", "print path of a given named template", templatesWhichCommand)
    $0.addCommand("cat", "print content of a given named template", templatesCatCommand)
  }

  for cmd in allParserCommands {
    $0.addCommand(cmd.name, cmd.description, cmd.command())
  }
}

let version = Bundle.main
  .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
let stencilVersion = Bundle(for: Stencil.Template.self)
  .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
let stencilSwiftKitVersion = Bundle(for: StencilSwiftKit.StencilSwiftTemplate.self)
  .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
let swiftGenKitVersion = Bundle(for: SwiftGenKit.AssetsCatalogParser.self)
  .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

main.run("SwiftGen v\(version) (" +
  "Stencil v\(stencilVersion), " +
  "StencilSwiftKit v\(stencilSwiftKitVersion), " +
  "SwiftGenKit v\(swiftGenKitVersion))")
