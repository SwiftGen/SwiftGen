//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands {
  struct Config: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Manage and run configuration files.",
      subcommands: [
        Lint.self,
        Run.self,
        Init.self,
        Doc.self,
        GenerateXCFileLists.self
      ],
      defaultSubcommand: Run.self
    )
  }
}

// MARK: - Helpers

extension Commands.Config {
  struct ConfigOptions: ParsableArguments {
    @Option(
      name: [.customLong("config"), .customShort("c")],
      help: "Path to the configuration file to use",
      completion: .file(extensions: ["yml"])
    )
    var file: Path = "swiftgen.yml"

    func validateExists() throws {
      if !file.isFile {
        throw ValidationError("`\(file)` is not a config file")
      }
    }

    func load() throws -> Config {
      try .init(file: file)
    }
  }
}
