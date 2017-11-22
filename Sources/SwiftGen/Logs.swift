//
//  Logs.swift
//  swiftgen
//
//  Created by Olivier HALLIGON on 12/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Foundation

// MARK: Printing on stderr

enum LogLevel {
  case info, warning, error
}

enum ANSIColor: UInt8, CustomStringConvertible {
  case reset = 0

  case black = 30
  case red
  case green
  case yellow
  case blue
  case magenta
  case cyan
  case white
  case `default`

  var description: String {
    return "\u{001B}[\(self.rawValue)m"
  }

  func format(_ string: String) -> String {
    if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
      isatty(fileno(stdout)) != 0 {
      return "\(self)\(string)\(ANSIColor.reset)"
    } else {
      return string
    }
  }
}

func logMessage(_ level: LogLevel, _ string: CustomStringConvertible) {
  switch level {
  case .info:
    fputs(ANSIColor.green.format("\(string)\n"), stdout)
  case .warning:
    fputs(ANSIColor.yellow.format("Warning: \(string)\n"), stderr)
  case .error:
    fputs(ANSIColor.red.format("Error: \(string)\n"), stderr)
  }
}

struct ErrorPrettifier: Error, CustomStringConvertible {
  let nsError: NSError
  var description: String {
    return "\(nsError.localizedDescription) (\(nsError.domain) code \(nsError.code))"
  }

  static func execute(closure: () throws -> Void ) rethrows {
    do {
      try closure()
    } catch let e as NSError where e.domain == NSCocoaErrorDomain {
      throw ErrorPrettifier(nsError: e)
    }
  }
}
