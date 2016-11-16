//
//  SwiftGen
//  Created by David Jennes on 2016/11/13.
//  Copyright (c) 2016 Olivier Halligon
//  MIT License
//

import Foundation

struct Command {
  private static let Environment = "/usr/bin/env"
  private var arguments: [String]

  init(_ executable: String, arguments: String...) {
    self.arguments = [executable]
    self.arguments += arguments
  }

  func execute() -> NSData {
    let task = NSTask()

    task.launchPath = Command.Environment
    task.arguments = arguments

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    return data
  }
}
