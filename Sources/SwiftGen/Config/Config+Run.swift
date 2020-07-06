//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import AppKit
import PathKit
import StencilSwiftKit
import SwiftGenKit

extension Config {
  func runCommands(verbose: Bool, logger: (LogLevel, String) -> Void = logMessage) throws {
    let errors = commands.parallelCompactMap { cmd, entry -> Swift.Error? in
      do {
        try run(parserCommand: cmd, entry: entry, verbose: verbose, logger: logger)
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

  private func run(
    parserCommand: ParserCLI,
    entry: ConfigEntry,
    verbose: Bool,
    logger: (LogLevel, String) -> Void
  ) throws {
    var entry = entry

    entry.makeRelativeTo(inputDir: inputDir, outputDir: outputDir)
    if verbose {
      for item in entry.commandLine(forCommand: parserCommand.name) {
        logger(.info, " $ \(item)")
      }
    }

    try entry.checkPaths()
    try entry.run(parserCommand: parserCommand, logger: logger)
  }
}

extension ConfigEntry {
  func run(parserCommand: ParserCLI, logger: (LogLevel, String) -> Void) throws {
    let context: [String: Any] = try withoutActuallyEscaping(logger) { logger in
      let parser = try parserCommand.parserType.init(options: options) { msg, _, _ in
        logger(.warning, msg)
      }

      let filter = try Filter(pattern: self.filter ?? parserCommand.parserType.defaultFilter)
      try parser.searchAndParse(paths: inputs, filter: filter)
      return parser.stencilContext()
    }

    for entryOutput in outputs {
      let templateRealPath = try entryOutput.template.resolvePath(forParser: parserCommand, logger: logger)
      let template = try StencilSwiftTemplate(
        templateString: templateRealPath.read(),
        environment: stencilSwiftEnvironment()
      )

      let enriched = try StencilContext.enrich(context: context, parameters: entryOutput.parameters)
      let rendered = try template.render(enriched)
      let output = OutputDestination.file(entryOutput.output)
      try output.write(content: rendered, onlyIfChanged: true, logger: logger)
    }
  }
}

// MARK: - Path checks

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
}

extension ConfigEntryOutput {
  func checkPaths() throws {
    guard self.output.parent().exists else {
      throw Config.Error.pathNotFound(path: self.output.parent())
    }
  }
}
