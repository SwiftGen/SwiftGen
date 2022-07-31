//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands {
  struct OutputDestination: ParsableArguments {
    @Option(
      name: [.customLong("output"), .customShort("o")],
      help: .init("The path to the file to generate (Omit to generate to stdout)", valueName: "file")
    )
    var path: Path?

    var destination: SwiftGenCLI.OutputDestination {
      if let path = path {
        return .file(path)
      } else {
        return .console
      }
    }
  }
}
