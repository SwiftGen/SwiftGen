//
//  OutputDestination.swift
//  swiftgen
//
//  Created by Olivier HALLIGON on 11/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit
import Commander

enum OutputDestination: ArgumentConvertible {
  case console
  case file(Path)

  init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = .file(Path(path))
  }

  var description: String {
    switch self {
    case .console: return "(stdout)"
    case .file(let path): return path.description
    }
  }

  func write(content: String, onlyIfChanged: Bool = false) {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      do {
        if try onlyIfChanged && path.exists && path.read(.utf8) == content {
          logMessage(.info, "Not writing the file as content is unchanged")
          return
        }
        try path.write(content)
        logMessage(.info, "File written: \(path)")
      } catch let e as NSError {
        logMessage(.error, e)
      }
    }
  }
}
