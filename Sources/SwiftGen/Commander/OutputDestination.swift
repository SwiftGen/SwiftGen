//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Commander
import PathKit

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
    case .console:
      return "(stdout)"
    case .file(let path):
      return path.description
    }
  }
}

extension OutputDestination {
  func write(content: String, onlyIfChanged: Bool = false, logger: (LogLevel, String) -> Void = logMessage) throws {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      if try onlyIfChanged && path.exists && path.read(.utf8) == content {
        logMessage(.info, "Not writing the file as content is unchanged")
        return
      }
      try path.write(content)
      logMessage(.info, "File written: \(path)")
    }
  }
}

// MARK: Commander

extension OutputDestination {
  static let cliOption = Option(
    "output",
    default: OutputDestination.console,
    flag: "o",
    description: "The path to the file to generate (Omit to generate to stdout)"
  )
}
