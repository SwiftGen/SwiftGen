//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import Foundation
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

// MARK: Common

let outputOption = Option(
  "output",
  default: OutputDestination.console,
  flag: "o",
  description: "The path to the file to generate (Omit to generate to stdout)"
)

// MARK: - Main

let main = Group {
  $0.noCommand = { path, group, parser in
    if parser.hasOption("help") {
      logMessage(.info, "Note: If you invoke swiftgen with no subcommand, it will default to `swiftgen config run`\n")
      throw GroupError.noCommand(path, group)
    } else {
      try configRunCommand.run(parser)
    }
  }
  $0.group("config", "manage and run configuration files") {
    $0.addCommand("lint", "Lint the configuration file", configLintCommand)
    $0.addCommand("run", "Run commands listed in the configuration file", configRunCommand)
  }

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
let swiftGenKitVersion = Bundle(for: SwiftGenKit.AssetsCatalog.Parser.self)
  .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

main.run("""
  SwiftGen v\(version) (\
  Stencil v\(stencilVersion), \
  StencilSwiftKit v\(stencilSwiftKitVersion), \
  SwiftGenKit v\(swiftGenKitVersion))
  """)
