//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
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

  let sourcePath: Path
}

extension Config {
  init(
    file: Path,
    env: [String: String] = ProcessInfo.processInfo.environment,
    logger: (LogLevel, String) -> Void = logMessage
  ) throws {
    if !file.exists {
      throw Config.Error.pathNotFound(path: file)
    }

    let anyConfig = try YAML.read(path: file, env: env)
    try self.init(yaml: anyConfig, sourcePath: file.parent(), logger: logger)
  }

  init(
    content: String,
    env: [String: String],
    sourcePath: Path,
    logger: (LogLevel, String) -> Void
  ) throws {
    let anyConfig = try YAML.decode(string: content, env: env)
    try self.init(yaml: anyConfig, sourcePath: sourcePath, logger: logger)
  }

  private init(
    yaml: Any?,
    sourcePath: Path,
    logger: (LogLevel, String) -> Void
  ) throws {
    self.sourcePath = sourcePath

    guard let config = yaml as? [String: Any] else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: yaml))
    }
    self.inputDir = (config[Keys.inputDir] as? String).map { Path($0) }
    self.outputDir = (config[Keys.outputDir] as? String).map { Path($0) }
    var cmds: [String: [ConfigEntry]] = [:]
    for parserCmd in ParserCLI.allCommands {
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
  enum Message {
    static func absolutePath(_ path: CustomStringConvertible) -> String {
      """
        \(path) is an absolute path. Prefer relative paths for portability when sharing your \
        project (unless you are using environment variables).
        """
    }

    static func deprecatedAction(_ action: String, for replacement: String) -> String {
      "`\(action)` action has been deprecated, please use `\(replacement)` instead."
    }

    static func doesntExist(_ path: CustomStringConvertible) -> String {
      "\(path) does not exist."
    }

    static func doesntExistIntermediatesNeeded(_ path: CustomStringConvertible) -> String {
      """
        \(path) does not exist. Intermediate folders up to the output file must already exist to avoid \
        misconfigurations, and won't be created for you.
        """
      }
  }

  // Deprecated
  private static let deprecatedCommands = [
    "storyboards": "ib"
  ]

  func lint(logger: (LogLevel, String) -> Void = logMessage) {
    logger(.info, "> Common parent directory used for all input paths:  \(inputDir ?? "<none>")")
    if let inputDir = inputDir, !inputDir.exists {
      logger(.error, "input_dir: Input directory \(Message.doesntExist(inputDir))")
    }

    logger(.info, "> Common parent directory used for all output paths: \(self.outputDir ?? "<none>")")
    if let outputDir = outputDir, !outputDir.exists {
      logger(.error, "output_dir: Output directory \(Message.doesntExist(outputDir))")
    }

    for (cmd, entries) in commands {
      if let replacement = Config.deprecatedCommands[cmd] {
        logger(.warning, Message.deprecatedAction(cmd, for: replacement))
      }

      if let parserCmd = ParserCLI.command(named: cmd) {
        let entriesCount = "\(entries.count) " + (entries.count > 1 ? "entries" : "entry")
        logger(.info, "> \(entriesCount) for command \(cmd):")
        for entry in entries {
          lint(cmd: parserCmd, entry: entry, logger: logger)
        }
      } else {
        logger(.error, "Action `\(cmd)` does not exist.")
      }
    }
  }

  private func lint(cmd: ParserCLI, entry: ConfigEntry, logger: (LogLevel, String) -> Void) {
    var entry = entry
    entry.makingRelativeTo(inputDir: inputDir, outputDir: outputDir)

    for inputPath in entry.inputs {
      let finalPath: Path

      if inputPath.isAbsolute {
        logger(.warning, "\(cmd.name).inputs: \(Message.absolutePath(inputPath))")
        finalPath = inputPath
      } else {
        finalPath = sourcePath + inputPath
      }

      if !finalPath.exists {
        logger(.error, "\(cmd.name).inputs: \(Message.doesntExist(inputPath))")
      }
    }

    if let regex = entry.filter, (try? Filter(pattern: regex)) == nil {
      logger(.error, "\(cmd.name).filter: \(regex) is not a valid regular expression.")
    }

    for issue in cmd.parserType.allOptions.lint(options: entry.options) {
      logger(.error, "\(cmd.name).options: \(issue)")
    }

    for entryOutput in entry.outputs {
      lint(cmd: cmd, output: entryOutput, logger: logger)
    }

    for item in entry.commandLine(forCommand: cmd.name) {
      logMessage(.info, " $ \(item)")
    }
  }

  private func lint(cmd: ParserCLI, output entryOutput: ConfigEntryOutput, logger: (LogLevel, String) -> Void) {
    do {
      let actualCmd = Config.deprecatedCommands[cmd.name].flatMap(ParserCLI.command(named:)) ?? cmd
      _ = try entryOutput.template.resolvePath(forParser: actualCmd)
    } catch let error {
      logger(.error, "\(cmd.name).outputs: \(error)")
    }
    if case TemplateRef.path(let templateRef) = entryOutput.template, templateRef.isAbsolute {
      logger(.warning, "\(cmd.name).outputs.templatePath: \(Message.absolutePath(templateRef))")
    }

    let outputParent = entryOutput.output.parent()
    if !(sourcePath + outputParent).exists {
      logger(.error, "\(cmd.name).outputs.output: \(Message.doesntExistIntermediatesNeeded(outputParent))")
    }
    if entryOutput.output.isAbsolute {
      logger(.warning, "\(cmd.name).outputs.output: \(Message.absolutePath(entryOutput.output))")
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
