//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

enum XCFileListCLI {
  private enum CLIOption {
    static let config = Option<Path>(
      "config",
      default: "swiftgen.yml",
      flag: "c",
      description: "Path to the configuration file to use",
      validator: checkPath(type: "config file") { $0.isFile }
    )

    static let inputs = Option<Path>(
      "inputs",
      default: "./swiftgen-input.xcfilelist",
      flag: "i",
      description: "Path to write the xcfilelist for the input files"
    )

    static let outputs = Option<Path>(
      "outputs",
      default: "./swiftgen-output.xcfilelist",
      flag: "o",
      description: "Path to write the xcfilelist for the output files"
    )
  }

  static let generate = command(
    CLIOption.config,
    CLIOption.inputs,
    CLIOption.outputs
  ) { configPath, inputPath, outputPath in
    try ErrorPrettifier.execute {
      let config = try Config(file: configPath)

      try writeInputsXCFileList(for: config, to: inputPath)
      try writeOutputsXCFileList(for: config, to: outputPath)
    }
  }

  private static func writeInputsXCFileList(for config: Config, to path: Path) throws {
    let inputPaths = pathsByCommand(for: config) { entry -> [Path] in
      entry.inputs.map { (config.sourcePath + $0).absolute() }
    }

    let content = xcFileList(for: inputPaths)
    try path.write(content)
  }

  private static func writeOutputsXCFileList(for config: Config, to path: Path) throws {
    let outputPaths = pathsByCommand(for: config) { entry -> [Path] in
      entry.outputs.map { (config.sourcePath + $0.output).absolute() }
    }

    let content = xcFileList(for: outputPaths)
    try path.write(content)
  }

  private static func pathsByCommand(for config: Config, paths: (ConfigEntry) -> [Path]) -> [String: Set<Path>] {
    var pathsByCommand: [String: Set<Path>] = [:]

    for (command, var entry) in config.commands {
      entry.makeRelativeTo(inputDir: config.inputDir, outputDir: config.outputDir)
      pathsByCommand[command.name, default: []].formUnion(paths(entry))
    }

    return pathsByCommand
  }

  private static func xcFileList(for pathsByCommand: [String: Set<Path>]) -> String {
    pathsByCommand
      .sorted { $0.key < $1.key }
      .map { name, paths in
        let formattedPaths = paths.sorted()
          .map { $0.string.replacingOccurrences(of: Path.current.absolute().string, with: "$(SRCROOT)") }
          .joined(separator: "\n")

        return """
        # \(name)
        \(formattedPaths)
        """
      }
      .joined(separator: "\n")
  }
}
