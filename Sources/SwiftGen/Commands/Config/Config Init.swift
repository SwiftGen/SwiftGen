//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import AppKit
import ArgumentParser
import SwiftGenCLI

extension Commands.Config {
  struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Create an initial configuration file.")

    @OptionGroup
    var config: ConfigOptions

    @Flag(inversion: .prefixedNo, help: "Open the configuration file for editing immediately after its creation")
    var open: Bool = true

    func validate() throws {
      guard !config.file.exists else {
        throw ValidationError("The configuration file `\(config)` already exists")
      }
    }

    func run() throws {
      let content = Config.example(versionForDocLink: Version.swiftgen, commentAllLines: true)
      try config.file.writeFix(content)
      logMessage(.info, "Example configuration file created: \(config.file)")
      if open {
        NSWorkspace.shared.open(config.file.url)
      }
    }
  }
}
