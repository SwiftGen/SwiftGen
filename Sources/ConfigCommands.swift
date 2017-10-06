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
    for src in self.sources {
      guard src.exists else {
        throw ArgumentError.invalidType(value: src.string, type: "existing path", argument: nil)

      }
    }
    guard self.output.parent().exists else {
      throw ArgumentError.invalidType(value: self.output.parent().string, type: "existing directory", argument: nil)
    }
  }

  func run(parserCommand: ParserCommand) throws {
    let parser = try parserCommand.parserType.init(options: [:], warningHandler: { (msg, _, _) in
      printError(string: msg)
    })
    try parser.parse(paths: self.sources)
    do {
      let templateRealPath = try findTemplate(subcommand: parserCommand.name,
                                              templateShortName: self.templateName ?? "",
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

extension ConfigEntry {
  var commandLine: String {
    let tplFlag: String
    if let name = self.templateName {
      tplFlag = "-t \(name)"
    } else if let path = self.templatePath {
      tplFlag = "-p \(path.string)"
    } else {
      tplFlag = ""
    }
    let params = listValues(in: self.parameters).joined(separator: " ")
    let sourcesList = self.sources.map({ $0.string }).joined(separator: " ")
    return "\(tplFlag) \(params) -o \(self.output) \(sourcesList)"
  }
}

// TODO: Move this to StencilSwiftKit.Parameters.listPairs() ?
private func listValues(in object: Any, keyPrefix: String = "") -> [String] {
  var values: [String] = []
  switch object {
  case is String, is Int, is Double:
    values.append("\(keyPrefix)=\(object)")
  case let dict as [String: Any]:
    for (key, value) in dict {
      let fullKey = keyPrefix.isEmpty ? key : "\(keyPrefix).\(key)"
      values += listValues(in: value, keyPrefix: fullKey)
    }
  case let array as [Any]:
    values += array.flatMap { listValues(in: $0, keyPrefix: keyPrefix) }
  default: break
  }
  return values
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
                   validator: checkPath(type: "config file") { $0.isFile }),
    Flag("verbose", flag: "v",
         description: "Print each command being executed",
         default: false)
) { file, verbose in
  let config = try Config(file: file)
  if verbose {
    print("Executing configuration file \(file)")
  }
  try file.parent().chdir {
    for (cmd, entries) in config.commands {
      for var entry in entries {
        guard let parserCmd = allParserCommands.first(where: { $0.name == cmd }) else {
          throw ConfigError.missingEntry(key: cmd)
        }
        entry.makeRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
        do {
          if verbose { print("> swiftgen \(cmd) \(entry.commandLine)") }
          try entry.checkPaths()
          try entry.run(parserCommand: parserCmd)
        } catch let e {
          printError(string: "\(e)")
        }
      }
    }
  }
}
