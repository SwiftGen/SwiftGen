//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT License
//

import Foundation

struct Command {
  private static let Environment = "/usr/bin/env"
  private var arguments: [String]

  init(_ executable: String, arguments: String...) {
    self.arguments = [executable]
    self.arguments += arguments
  }

  func execute() -> Data {
    let task = Process()

    task.launchPath = Command.Environment
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return data
  }
}
