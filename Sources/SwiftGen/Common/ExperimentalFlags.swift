//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands {
  struct ExperimentalSpacing: ParsableArguments {
    @Option(
      name: [.customLong("experimental-modern-spacing")],
      help: "Enable modern spacing control, i.e. enables Stencil's `smart` trimming."
    )
    var modernSpacing: Bool = false
  }
}
