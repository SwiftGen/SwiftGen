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
  func run(parserCommand: ParserCommand) throws {
    let parser = try parserCommand.parserType.init(options: [:], warningHandler: { (msg, _, _) in
      printError(string: msg)
    })
    try parser.parse(paths: self.sources)
    do {
      let templateRealPath = try findTemplate(subcommand: parserCommand.name,
                                              templateShortName: self.templateName,
                                              templateFullPath: self.templatePath)
      let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                              environment: stencilSwiftEnvironment())

      let context = parser.stencilContext()
      let enriched = try StencilContext.enrich(context: context, parameters: self.parameters)
      let rendered = try template.render(enriched)
      let output = OutputDestination.file(self.output)
      output.write(content: rendered, onlyIfChanged: true)
    } catch let error as TemplateError {
      printError(string: "error: \(error)")
    } catch let error {
      printError(string: "error: failed to render template: \(error)")
    }
  }
}

// MARK: Commands

let configLintCommand = command(
  Option<Path>("config", "swiftgen.yml", flag: "c",
                 description: "Path to the configuration file to use",
                 validator: checkPath(type: "config file") { $0.isFile })
) { file in
  // TODO: Implement this
  print("Linting \(file): not available yet")
}

let configRunCommand = command(
    Option<Path>("config", "swiftgen.yml", flag: "c",
                   description: "Path to the configuration file to use",
                   validator: checkPath(type: "config file") { $0.isFile })
) { file in
  let config = try Config(file: file)
  for (cmd, entries) in config.commands {
    for var entry in entries {
      if let outPrefix = config.outputDir {
        entry.output = outPrefix + entry.output
      }
      guard let parserCmd = allParserCommands.first(where: { $0.name == cmd }) else {
        throw ConfigError.missingEntry(key: cmd)
      }
      try entry.run(parserCommand: parserCmd)
    }
  }
}
