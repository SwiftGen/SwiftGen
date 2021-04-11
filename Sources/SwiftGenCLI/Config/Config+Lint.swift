//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import SwiftGenKit

extension Config {
  enum Message {
    static func absolutePath(_ path: CustomStringConvertible) -> String {
      """
        \(path) is an absolute path. Prefer relative paths for portability when sharing your \
        project (unless you are using environment variables).
        """
    }

    static func deprecatedParser(_ parser: String, for replacement: String) -> String {
      "`\(parser)` parser has been deprecated, please use `\(replacement)` instead."
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
}

extension Config {
  public func lint(logger: (LogLevel, String) -> Void = logMessage) {
    logger(.info, "> Common parent directory used for all input paths:  \(inputDir ?? "<none>")")
    if let inputDir = inputDir, !inputDir.exists {
      logger(.error, "input_dir: Input directory \(Message.doesntExist(inputDir))")
    }

    logger(.info, "> Common parent directory used for all output paths: \(self.outputDir ?? "<none>")")
    if let outputDir = outputDir, !outputDir.exists {
      logger(.error, "output_dir: Output directory \(Message.doesntExist(outputDir))")
    }

    let groupedCommands: [ParserCLI: [ConfigEntry]] = Dictionary(grouping: commands) { $0.command }
      .mapValues { $0.map { $0.entry } }

    for (cmd, entries) in groupedCommands {
      if let replacement = Config.deprecatedCommands[cmd.name] {
        logger(.warning, Message.deprecatedParser(cmd.name, for: replacement))
      }

      let entriesCount = "\(entries.count) " + (entries.count > 1 ? "entries" : "entry")
      logger(.info, "> \(entriesCount) for command \(cmd.name):")
      for entry in entries {
        lint(cmd: cmd, entry: entry, logger: logger)
      }
    }
  }

  private func lint(cmd: ParserCLI, entry: ConfigEntry, logger: (LogLevel, String) -> Void) {
    var entry = entry
    entry.makeRelativeTo(inputDir: inputDir, outputDir: outputDir)

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
      _ = try entryOutput.template.resolvePath(forParser: actualCmd, logger: logger)
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
