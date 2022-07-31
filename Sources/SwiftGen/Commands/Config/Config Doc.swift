//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import AppKit
import ArgumentParser
import SwiftGenCLI

extension Commands.Config {
  struct Doc: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Open the documentation for the configuration file on GitHub."
    )

    func run() throws {
      let docURL = gitHubDocURL(version: Version.swiftgen, path: "ConfigFile.md")
      logMessage(.info, "Open documentation at: \(docURL)")
      NSWorkspace.shared.open(docURL)
    }
  }
}
