//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit
import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

extension ConfigEntryOutput {
  func checkPaths() throws {
    guard self.output.parent().exists else {
      throw Config.Error.pathNotFound(path: self.output.parent())
    }
  }
}

extension ConfigEntry {
  func checkPaths() throws {
    for inputPath in self.inputs {
      guard inputPath.exists else {
        throw Config.Error.pathNotFound(path: inputPath)
      }
    }
    for output in outputs {
      try output.checkPaths()
    }
  }

  func run(parserCommand: ParserCLI) throws {
    let parser = try parserCommand.parserType.init(options: options) { msg, _, _ in
      logMessage(.warning, msg)
    }

    let filter = try Filter(pattern: self.filter ?? parserCommand.parserType.defaultFilter)
    try parser.searchAndParse(paths: inputs, filter: filter)
    let context = parser.stencilContext()

    for entryOutput in outputs {
      let templateRealPath = try entryOutput.template.resolvePath(forParser: parserCommand)
      let template = try StencilSwiftTemplate(
        templateString: templateRealPath.read(),
        environment: stencilSwiftEnvironment()
      )

      let enriched = try StencilContext.enrich(context: context, parameters: entryOutput.parameters)
      let rendered = try template.render(enriched)
      let output = OutputDestination.file(entryOutput.output)
      try output.write(content: rendered, onlyIfChanged: true)
    }
  }
}

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

  // MARK: - Init/Create

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

  static let doc = command {
    let docURL = gitHubDocURL(version: Version.swiftgen, path: "ConfigFile.md")
    logMessage(.info, "Open documentation at: \(docURL)")
    NSWorkspace.shared.open(docURL)
  }
}

// MARK: - Parallel commands

private extension Config {
  func runCommands(verbose: Bool) throws {
    let commandsAndEntries = try collectCommandsAndEntries()

    let errors = commandsAndEntries.parallelCompactMap { cmd, entry -> Swift.Error? in
      do {
        try run(cmd: cmd, entry: entry, verbose: verbose)
        return nil
      } catch {
        return error
      }
    }

    if errors.count == 1 {
      throw errors[0]
    } else if errors.count > 1 {
      throw Error.multipleErrors(errors)
    }
  }

  func run(cmd: ParserCLI, entry: ConfigEntry, verbose: Bool) throws {
    var entry = entry

    entry.makingRelativeTo(inputDir: inputDir, outputDir: outputDir)
    if verbose {
      for item in entry.commandLine(forCommand: cmd.name) {
        logMessage(.info, " $ \(item)")
      }
    }

    try entry.checkPaths()
    try entry.run(parserCommand: cmd)
  }

  /// Flatten all commands and their corresponding entries into 1 list
  func collectCommandsAndEntries() throws -> [(ParserCLI, ConfigEntry)] {
    try commands.keys.sorted()
      .compactMap { cmd in
        guard let parserCmd = ParserCLI.command(named: cmd) else {
          throw Config.Error.missingEntry(key: cmd)
        }
        return parserCmd
      }
      .flatMap { cmd in
        (commands[cmd.name] ?? []).map { (cmd, $0) }
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
