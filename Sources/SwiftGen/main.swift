//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import Foundation
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

// MARK: - Main

let main = Group {
  $0.noCommand = { path, group, parser in
    if parser.hasOption("help") {
      logMessage(.info, "Note: If you invoke swiftgen with no subcommand, it will default to `swiftgen config run`\n")
      throw GroupError.noCommand(path, group)
    } else {
      try ConfigCLI.run.run(parser)
    }
  }
  $0.group("config", "manage and run configuration files") {
    $0.addCommand("lint", "Lint the configuration file", ConfigCLI.lint)
    $0.addCommand("run", "Run commands listed in the configuration file", ConfigCLI.run)
  }

  $0.group("templates", "manage custom templates") {
    $0.addCommand("list", "list bundled and custom templates", TemplatesCLI.list)
    $0.addCommand("which", "print path of a given named template", TemplatesCLI.which)
    $0.addCommand("cat", "print content of a given named template", TemplatesCLI.cat)
  }

  for cmd in ParserCLI.allCommands {
    $0.addCommand(cmd.name, cmd.description, cmd.command())
  }
}

main.run(
  """
  SwiftGen v\(Version.swiftgen) (\
  Stencil v\(Version.stencil), \
  StencilSwiftKit v\(Version.stencilSwiftKit), \
  SwiftGenKit v\(Version.swiftGenKit))
  """
)
