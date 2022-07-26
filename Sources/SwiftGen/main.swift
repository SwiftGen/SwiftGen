//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Commander
import Foundation
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenCLI
import SwiftGenKit

// MARK: - Main

// swiftlint:disable:next closure_body_length prefixed_toplevel_constant
let main = Group { group in
  group.noCommand = { path, group, parser in
    if path == nil && !parser.hasOption("help") {
      // `swiftgen` invoked with no subcommand AND no `--help` flag ==> run `swiftgen config run`
      try ConfigCLI.run.run(parser)
    } else {
      // invoked with either an incomplete subcommand (e.g. `swiftgen config`) OR with `--help` flag ==> show help
      if path == nil { // no subcommand, so just `swiftgen --help`
        logMessage(.info, "Note: If you invoke swiftgen with no subcommand, it will default to `swiftgen config run`\n")
      }
      throw GroupError.noCommand(path, group)
    }
  }
  group.group("config", "manage and run configuration files") { group in
    group.addCommand("lint", "lint the configuration file", ConfigCLI.lint)
    group.addCommand("run", "run commands listed in the configuration file", ConfigCLI.run)
    group.addCommand("init", "create an initial configuration file", ConfigCLI.create)
    group.addCommand("doc", "open the documentation for the configuration file on GitHub", ConfigCLI.doc)
    group.addCommand(
      "generate-xcfilelists",
      """
      generates xcfilelists based on the configuration file, \
      for use in an Xcode build step that executes `swiftgen config run`
      """,
      ConfigCLI.generateXCFileLists
    )
  }

  group.group("template", "manage custom templates") { group in
    group.addCommand("list", "list bundled and custom templates", TemplateCLI.list)
    group.addCommand("which", "print path of a given named template", TemplateCLI.which)
    group.addCommand("cat", "print content of a given named template", TemplateCLI.cat)
    group.addCommand("doc", "open the documentation for templates on GitHub", TemplateCLI.doc)
  }

  group.group("run", "run individual parser commands, outside of a config file") { group in
    for cmd in ParserCLI.allCommands {
      group.addCommand(cmd.name, cmd.description, cmd.command())
    }
  }

  // Deprecated: Remove this in SwiftGen 7.0
  group.group("templates", "DEPRECATED - use `template` subcommand instead") { group in
    group.addDeprecatedCommand("list", replacement: "template list", TemplateCLI.list)
    group.addDeprecatedCommand("which", replacement: "template which", TemplateCLI.which)
    group.addDeprecatedCommand("cat", replacement: "template cat", TemplateCLI.cat)
    group.addDeprecatedCommand("doc", replacement: "template doc", TemplateCLI.doc)
  }

  for cmd in ParserCLI.allCommands {
    group.addDeprecatedCommand(cmd.name, replacement: "swiftgen run \(cmd.name)", cmd.command())
  }
  // Deprecation end
}

main.run(
  """
  SwiftGen v\(Version.swiftgen) (\
  Stencil v\(Version.stencil), \
  StencilSwiftKit v\(Version.stencilSwiftKit), \
  SwiftGenKit v\(Version.swiftGenKit))
  """
)

// Deprecated: Remove this in SwiftGen 7.0
extension Group {
  struct DeprecatedCommand: CommandType {
    let wrappedCommand: CommandType
    let replacement: String

    func run(_ parser: ArgumentParser) throws {
      logMessage(.warning, "This command is deprecated in favor of `\(replacement)`")
      try wrappedCommand.run(parser)
    }
  }
  func addDeprecatedCommand(_ name: String, replacement: String, _ command: CommandType) {
    let depCmd = DeprecatedCommand(wrappedCommand: command, replacement: replacement)
    addCommand(name, "DEPRECATED - use `\(replacement)` instead", depCmd)
  }
}
// Deprecation end
