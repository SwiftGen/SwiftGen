//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit

public enum OutputDestination {
  case console
  case file(Path)

  public var description: String {
    switch self {
    case .console:
      return "(stdout)"
    case .file(let path):
      return path.description
    }
  }
}

extension OutputDestination {
  public func write(
    content: String,
    onlyIfChanged: Bool = false,
    logger: (LogLevel, String) -> Void = logMessage
  ) throws {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      if try onlyIfChanged && path.exists && path.read(.utf8) == content {
        logMessage(.info, "Not writing the file as content is unchanged")
        return
      }
      try path.writeFix(content)
      logMessage(.info, "File written: \(path)")
    }
  }
}

import Foundation

extension Path {
    /// Workaround for a bug in SPM that prevents SwiftGen from writing files to DerivedData folder located on an external drive.
    /// https://github.com/apple/swift-package-manager/issues/6948#issuecomment-1747196926
    public func writeFix(_ string: String, encoding: String.Encoding = String.Encoding.utf8) throws {
      try string.write(toFile: normalize().string, atomically: false, encoding: encoding)
    }
}
