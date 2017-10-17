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

extension Config.Entry {
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

  func run(parserCommand: ParserCommand) throws {
    let parser = try parserCommand.parserType.init(options: [:], warningHandler: { (msg, _, _) in
      printError(string: msg)
    })
    try parser.parse(paths: self.paths)
    do {
      let templateRealPath = try self.template.resolvePath(forSubcommand: parserCommand.name)
      let template = try StencilSwiftTemplate(templateString: templateRealPath.read(),
                                              environment: stencilSwiftEnvironment())

      let context = parser.stencilContext()
      let enriched = try StencilContext.enrich(context: context, parameters: self.parameters)
      let rendered = try template.render(enriched)
      let output = OutputDestination.file(self.output)
      output.write(content: rendered, onlyIfChanged: true)
    } catch let error as TemplateRef.Error {
      printError(string: "error: \(error)")
    } catch let error {
      printError(string: "error: failed to render template: \(error)")
    }
  }

  func commandLine(forCommand cmd: String) -> String {
    let tplFlag: String = {
      switch self.template {
      case .name(let name): return "-t \(name)"
      case .path(let path): return "-p \(path.string)"
      }
    }()
    let params =  Parameters.flatten(dictionary: self.parameters)
    let paramsList = params.isEmpty ? "" : (" " + params.map({ "--param \($0)" }).joined(separator: " "))
    let inputPaths = self.paths.map({ $0.string }).joined(separator: " ")
    return "swiftgen \(cmd) \(tplFlag)\(paramsList) -o \(self.output) \(inputPaths)"
  }
}

// MARK: Commands

let configLintCommand = command(
  Option<Path>("config", default: "swiftgen.yml", flag: "c",
               description: "Path to the configuration file to use",
               validator: checkPath(type: "config file") { $0.isFile })
) { file in
  print("Linting \(file)")
  let config = try Config(file: file)
  print("> Common parent directory used for all input paths:  \(config.inputDir ?? "<none>")")
  print("> Common parent directory used for all output paths: \(config.outputDir ?? "<none>")")
  for (cmd, entries) in config.commands {
    let entriesCount = "\(entries.count) " + (entries.count > 1 ? "entries" : "entry")
    print("> \(entriesCount) for command \(cmd):")
    for var entry in entries {
      entry.makeRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
      let absolutePathError = "Absolute paths should be avoided in configuration files if possible"
      for inputPath in entry.paths where inputPath.isAbsolute {
        printError(string: "\(cmd).paths \(inputPath) is absolute. \(absolutePathError)")
      }
      if case TemplateRef.path(let tp) = entry.template, tp.isAbsolute {
        printError(string: "\(cmd).templatePath \(tp) is absolute. \(absolutePathError)")
      }
      if entry.output.isAbsolute {
        printError(string: "\(cmd).output path \(entry.output) is absolute. \(absolutePathError)")
      }
      print("  $ " + entry.commandLine(forCommand: cmd))
    }
  }
}

let configRunCommand = command(
  Option<Path>("config", default: "swiftgen.yml", flag: "c",
               description: "Path to the configuration file to use",
               validator: checkPath(type: "config file") { $0.isFile }),
  Flag("verbose", default: false, flag: "v",
       description: "Print each command being executed")
) { file, verbose in
  let config = try Config(file: file)

  if verbose {
    print("Executing configuration file \(file)")
  }
  try file.parent().chdir {
    for (cmd, entries) in config.commands {
      for var entry in entries {
        guard let parserCmd = allParserCommands.first(where: { $0.name == cmd }) else {
          throw Config.Error.missingEntry(key: cmd)
        }
        entry.makeRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
        do {
          if verbose {
            print(entry.commandLine(forCommand: cmd))
          }
          try entry.checkPaths()
          try entry.run(parserCommand: parserCmd)
        } catch let e {
          printError(string: "\(e)")
        }
      }
    }
  }
}
