//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import SwiftGenCLI

extension Commands.Config {
  struct Lint: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Lint the configuration file.")

    @OptionGroup
    var config: ConfigOptions

    func validate() throws {
      try config.validateExists()
    }

    func run() throws {
      logMessage(.info, "Linting \(config.file)")
      try config.load().lint()
    }
  }
}
