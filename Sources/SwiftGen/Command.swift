//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser

@main
struct SwiftGen: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "swiftgen",
    abstract: "A utility for generating code.",
    version: version,
    subcommands: [
      Commands.Config.self,
      Commands.Template.self,
      Commands.Run.self,

      // deprecated
      DeprecatedCommands.Templates.self
    ] + Commands.Run.configuration.subcommands,
    defaultSubcommand: Commands.Config.self
  )

  private static let version = """
    SwiftGen v\(Version.swiftgen) (\
    Stencil v\(Version.stencil), \
    StencilSwiftKit v\(Version.stencilSwiftKit), \
    SwiftGenKit v\(Version.swiftGenKit))
    """
}

/// namespace for command related things
enum Commands {
}
