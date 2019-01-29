//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

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
    let parser = try parserCommand.parserType.init(options: [:]) { msg, _, _ in
      logMessage(.warning, msg)
    }
    let filter = try Filter(pattern: self.filter ?? parserCommand.parserType.defaultFilter)
    try parser.searchAndParse(paths: inputs, filter: filter)
    let context = parser.stencilContext()

    for entryOutput in outputs {
      let templateRealPath = try entryOutput.template.resolvePath(forSubcommand: parserCommand.name)
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

private let configOption = Option<Path>(
  "config",
  default: "swiftgen.yml",
  flag: "c",
  description: "Path to the configuration file to use",
  validator: checkPath(type: "config file") { $0.isFile }
)

// MARK: Lint

let configLintCommand = command(
  configOption
) { file in
  try ErrorPrettifier.execute {
    logMessage(.info, "Linting \(file)")
    let config = try Config(file: file)
    config.lint()
  }
}

// MARK: Run

let configRunCommand = command(
  configOption,
  Flag("verbose", default: false, flag: "v", description: "Print each command being executed")
) { file, verbose in
  do {
    try ErrorPrettifier.execute {
      let config = try Config(file: file)

      if verbose {
        logMessage(.info, "Executing configuration file \(file)")
      }
      try file.parent().chdir {
        for (cmd, entries) in config.commands {
          for var entry in entries {
            guard let parserCmd = allParserCommands.first(where: { $0.name == cmd }) else {
              throw Config.Error.missingEntry(key: cmd)
            }
            entry.makingRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
            if verbose {
              for item in entry.commandLine(forCommand: cmd) {
                logMessage(.info, " $ \(item)")
              }
            }
            try entry.checkPaths()
            try entry.run(parserCommand: parserCmd)
          }
        }
      }
    }
  } catch let error as Config.Error {
    logMessage(.error, error)
  }
}
