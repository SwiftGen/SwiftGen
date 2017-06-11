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

  for parser in parsers {
    let parserType = parser.parser
    $0.addCommand(parserType.commandName, parserType.commandDescription, parser.command)
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
