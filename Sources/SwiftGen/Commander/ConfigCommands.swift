//
//  ConfigCommands.swift
//  swiftgen
//
//  Created by Olivier Halligon on 01/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

extension ConfigEntry {
  func checkPaths() throws {
    for inputPath in self.paths {
      guard inputPath.exists else {
        throw Config.Error.pathNotFound(path: inputPath)
      }
    }
    guard self.output.parent().exists else {
      throw Config.Error.pathNotFound(path: self.output.parent())
    }
  }

  func run(parserCommand: ParserCLI) throws {
    let parser = try parserCommand.parserType.init(options: [:]) { msg, _, _ in
      logMessage(.warning, msg)
    }
    try parser.parse(paths: self.paths)
    let templateRealPath = try self.template.resolvePath(forSubcommand: parserCommand.name)
    let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                            environment: stencilSwiftEnvironment())

    let context = parser.stencilContext()
    let enriched = try StencilContext.enrich(context: context, parameters: self.parameters)
    let rendered = try template.render(enriched)
    let output = OutputDestination.file(self.output)
    try output.write(content: rendered, onlyIfChanged: true)
  }
}

// MARK: - Commands

// MARK: Lint

let configLintCommand = command(
  Option<Path>("config",
               default: "swiftgen.yml",
               flag: "c",
               description: "Path to the configuration file to use",
               validator: checkPath(type: "config file") { $0.isFile })
) { file in
  try ErrorPrettifier.execute {
    logMessage(.info, "Linting \(file)")
    let config = try Config(file: file)
    config.lint { level, msg in logMessage(level, msg) }
  }
}

// MARK: Run

let configRunCommand = command(
  Option<Path>("config",
               default: "swiftgen.yml",
               flag: "c",
               description: "Path to the configuration file to use",
               validator: checkPath(type: "config file") { $0.isFile }),
  Flag("verbose",
       default: false,
       flag: "v",
       description: "Print each command being executed")
) { file, verbose in
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
          entry.makeRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
          if verbose {
            logMessage(.info, " $ " + entry.commandLine(forCommand: cmd))
          }
          try entry.checkPaths()
          try entry.run(parserCommand: parserCmd)
        }
      }
    }
  }
}
