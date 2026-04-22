//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands.Config {
  struct GenerateXCFileLists: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "generate-xcfilelists",
      abstract: """
      Generates xcfilelists based on the configuration file,
      for use in an Xcode build step that executes `swiftgen config run`.
      """
    )

    @OptionGroup
    var config: ConfigOptions

    @Option(
      name: .shortAndLong,
      help: "Path to write the xcfilelist for the input files",
      completion: .file(extensions: ["xcfilelist"])
    )
    var inputs: Path?

    @Option(
      name: .shortAndLong,
      help: "Path to write the xcfilelist for the output files",
      completion: .file(extensions: ["xcfilelist"])
    )
    var outputs: Path?

    func validate() throws {
      try config.validateExists()

      guard inputs != nil || outputs != nil else {
        throw ValidationError("You must provide the path of an input or output xcfilelist (or both).")
      }
    }

    func run() throws {
      let configuration = try config.load()

      if let inputPath = inputs {
        let content = try configuration.inputXCFileList()
        try inputPath.writeFix(content)
      }

      if let outputPath = outputs {
        let content = try configuration.outputXCFileList()
        try outputPath.writeFix(content)
      }
    }
  }
}
