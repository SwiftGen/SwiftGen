//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import AppKit
import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

// MARK: - Commands

enum ConfigCLI {
  private enum CLIOption {
    static func configFile(checkExists: Bool = true) -> Option<Path> {
      Option<Path>(
        "config",
        default: "swiftgen.yml",
        flag: "c",
        description: "Path to the configuration file to use",
        validator: checkExists ? checkPath(type: "config file") { $0.isFile } : nil
      )
    }
  }

  // MARK: Lint

  static let lint = command(
    CLIOption.configFile()
  ) { file in
    try ErrorPrettifier.execute {
      logMessage(.info, "Linting \(file)")
      let config = try Config(file: file)
      config.lint()
    }
  }

  // MARK: Run

  static let run = command(
    CLIOption.configFile(),
    Flag("verbose", default: false, flag: "v", description: "Print each command being executed")
  ) { file, verbose in
    do {
      try ErrorPrettifier.execute {
        let config = try Config(file: file)

        if verbose {
          logMessage(.info, "Executing configuration file \(file)")
        }
        try file.parent().chdir {
          try config.runCommands(verbose: verbose)
        }
      }
    } catch let error as Config.Error {
      logMessage(.error, error)
      logMessage(.error, configRunErrorMessageWithSuggestions)
    }
  }

  // MARK: Init/Create

  static let create = command(
    CLIOption.configFile(checkExists: false),
    Flag("open", default: true, description: "Open the configuration file for editing immediately after its creation")
  ) { file, shouldOpen in
    guard !file.exists else {
      logMessage(.error, "The configuration file \(file) already exists")
      return
    }
    try ErrorPrettifier.execute {
      let content = Config.example(versionForDocLink: Version.swiftgen, commentAllLines: true)
      try file.write(content)
      logMessage(.info, "Example configuration file created: \(file)")
      if shouldOpen {
        NSWorkspace.shared.open(file.url)
      }
    }
  }

  // MARK: Doc

  static let doc = command {
    let docURL = gitHubDocURL(version: Version.swiftgen, path: "ConfigFile.md")
    logMessage(.info, "Open documentation at: \(docURL)")
    NSWorkspace.shared.open(docURL)
  }

  // MARK: Generate XCFileLists

  static let generateXCFileLists = command(
    CLIOption.configFile(),
    Option<Path?>("inputs", default: nil, flag: "i", description: "Path to write the xcfilelist for the input files"),
    Option<Path?>("outputs", default: nil, flag: "o", description: "Path to write the xcfilelist for the output files")
  ) { configPath, inputPath, outputPath in
    try ErrorPrettifier.execute {
      let config = try Config(file: configPath)

      if let inputPath = inputPath {
        let content = try config.inputXCFileList()
        try inputPath.write(content)
      }

      if let outputPath = outputPath {
        let content = try config.outputXCFileList()
        try outputPath.write(content)
      }

      if inputPath == nil, outputPath == nil {
        logMessage(.error, "You must provide the path of an input or output xcfilelist (or both).")
      }
    }
  }
}

// MARK: - Private

private let configRunErrorMessageWithSuggestions =
  """
  It seems like there was an error running SwiftGen.

  - Verify that your configuration file exists at the correct path, or create a new one using:
  > swiftgen config init

  - Verify that your configuration file is valid by running:
  > swiftgen config lint

  - If you have any other questions or issues, we have extensive documentation and an issue tracker on GitHub:
  > https://github.com/SwiftGen/SwiftGen
  """
