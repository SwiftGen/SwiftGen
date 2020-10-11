//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Commander
import SwiftGenCLI

extension OutputDestination {
  static let cliOption = Option(
    "output",
    default: OutputDestination.console,
    flag: "o",
    description: "The path to the file to generate (Omit to generate to stdout)"
  )
}
