//
//  Config.swift
//  swiftgen
//
//  Created by Olivier Halligon on 01/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit
import SwiftGenKit

// MARK: - Config

struct Config {
  enum Keys {
    static let inputDir = "input_dir"
    static let outputDir = "output_dir"
  }

  let inputDir: Path?
  let outputDir: Path?
  let commands: [String: [ConfigEntry]]
}

extension Config {
  init(file: Path, logger: (LogLevel, String) -> Void = logMessage) throws {
    if !file.exists {
      throw Config.Error.pathNotFound(path: file)
    }
    let anyConfig = try YAML.read(path: file)
    guard let config = anyConfig as? [String: Any] else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: anyConfig))
    }
    self.inputDir = (config[Keys.inputDir] as? String).map { Path($0) }
    self.outputDir = (config[Keys.outputDir] as? String).map { Path($0) }
    var cmds: [String: [ConfigEntry]] = [:]
    for parserCmd in allParserCommands {
      if let cmdEntry = config[parserCmd.name] {
        do {
          cmds[parserCmd.name] = try ConfigEntry.parseCommandEntry(
            yaml: cmdEntry,
            cmd: parserCmd.name,
            logger: logger
          )
        } catch let error as Config.Error {
          // Prefix the name of the command for a better error message
          throw error.withKeyPrefixed(by: parserCmd.name)
        }
      }
    }
    self.commands = cmds
  }
}

// MARK: - Linting

extension Config {
  // Deprecated
  private static let deprecatedCommands = [
    "storyboards": "ib"
  ]

  func lint(logger: (LogLevel, String) -> Void = logMessage) {
    logger(.info, "> Common parent directory used for all input paths:  \(inputDir ?? "<none>")")
    if let inputDir = inputDir, !inputDir.exists {
      logger(.error, "input_dir: Input directory \(inputDir) does not exist")
    }

    logger(.info, "> Common parent directory used for all output paths: \(self.outputDir ?? "<none>")")
    if let outputDir = outputDir, !outputDir.exists {
      logger(.error, "output_dir: Output directory \(outputDir) does not exist")
    }

    for (cmd, entries) in commands {
      if let replacement = Config.deprecatedCommands[cmd] {
        logger(.warning, "`\(cmd)` action has been deprecated, please use `\(replacement)` instead.")
      }

      let entriesCount = "\(entries.count) " + (entries.count > 1 ? "entries" : "entry")
      logger(.info, "> \(entriesCount) for command \(cmd):")
      for entry in entries {
        lint(cmd: cmd, entry: entry, logger: logger)
      }
    }
  }

  private func lint(cmd: String, entry: ConfigEntry, logger: (LogLevel, String) -> Void = logMessage) {
    var entry = entry
    entry.makeRelativeTo(inputDir: inputDir, outputDir: outputDir)

    for inputPath in entry.inputs {
      if !inputPath.exists {
        logger(.error, "\(cmd).inputs: \(inputPath) does not exist")
      }
      if inputPath.isAbsolute {
        logger(.warning, """
          \(cmd).inputs: \(inputPath) is an absolute path. Prefer relative paths for portability \
          when sharing your project.
          """)
      }
    }

    for entryOutput in entry.outputs {
      do {
        let actualCmd = Config.deprecatedCommands[cmd] ?? cmd
        _ = try entryOutput.template.resolvePath(forSubcommand: actualCmd)
      } catch let error {
        logger(.error, "\(cmd).outputs: \(error)")
      }
      if case TemplateRef.path(let templateRef) = entryOutput.template, templateRef.isAbsolute {
        logger(.warning, """
          \(cmd).outputs.templatePath: \(templateRef) is an absolute path. Prefer relative paths \
          for portability when sharing your project.
          """)
      }

      let outputParent = entryOutput.output.parent()
      if !outputParent.exists {
        logger(.error, """
          \(cmd).outputs.output: \(outputParent) does not exist. Intermediate folders up to the \
          output file must already exist to avoid misconfigurations, and won't be created for you.
          """)
      }
      if entryOutput.output.isAbsolute {
        logger(.warning, """
          \(cmd).outputs.output: \(entryOutput.output) is an absolute path. Prefer relative paths \
          for portability when sharing your project.
          """)
      }
    }

    for item in entry.commandLine(forCommand: cmd) {
      logMessage(.info, " $ \(item)")
    }
  }
}

// MARK: - Config.Error

extension Config {
  enum Error: Swift.Error, CustomStringConvertible {
    case missingEntry(key: String)
    case wrongType(key: String?, expected: String, got: Any.Type)
    case pathNotFound(path: Path)

    var description: String {
      switch self {
      case .missingEntry(let key):
        return "Missing entry for key \(key)."
      case .wrongType(let key, let expected, let got):
        return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)."
      case .pathNotFound(let path):
        return "File \(path) not found."
      }
    }

    func withKeyPrefixed(by prefix: String) -> Config.Error {
      switch self {
      case .missingEntry(let key):
        return Config.Error.missingEntry(key: "\(prefix).\(key)")
      case .wrongType(let key, let expected, let got):
        let fullKey = [prefix, key].compactMap({ $0 }).joined(separator: ".")
        return Config.Error.wrongType(key: fullKey, expected: expected, got: got)
      default:
        return self
      }
    }
  }
}
