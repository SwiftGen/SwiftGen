//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import Foundation

let outputOption = Option(
  "output",
  default: OutputDestination.console,
  flag: "o",
  description: "The path to the file to generate (Omit to generate to stdout)"
)
