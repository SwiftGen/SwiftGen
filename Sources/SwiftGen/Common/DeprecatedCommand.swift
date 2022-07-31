//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import SwiftGenKit

protocol DeprecatedCommand: ParsableCommand {
  associatedtype Base: ParsableCommand

  var command: Base { get set }
}

extension DeprecatedCommand {
  static var configuration: CommandConfiguration {
    .init(
      abstract: "DEPRECATED - use `\(Base.configuration.commandName ?? "")` subcommand instead.",
      shouldDisplay: false,
      subcommands: Base.configuration.subcommands
    )
  }

  mutating func run() throws {
    try command.run()
  }
}

// MARK: - Deprecated commands

enum DeprecatedCommands {
  struct Templates: DeprecatedCommand {
    @OptionGroup
    var command: Commands.Template
  }

  struct Storyboards: DeprecatedCommand {
    @OptionGroup
    var command: Commands.Run.ParserCommand<InterfaceBuilder.Parser>
  }
}
