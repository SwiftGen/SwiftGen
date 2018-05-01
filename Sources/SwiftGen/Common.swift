//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
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
