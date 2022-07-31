//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation

// MARK: Printing on stderr

public enum CommandLogLevel {
  case quiet, `default`, verbose
}

public var commandLogLevel: CommandLogLevel = .default

public enum LogLevel {
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
    "\u{001B}[\(self.rawValue)m"
  }

  func format(_ string: String) -> String {
    if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
      isatty(fileno(stdout)) != 0 {
      return "\(self)\(string)\(Self.reset)"
    } else {
      return string
    }
  }
}

// Based on https://github.com/realm/SwiftLint/blob/0.39.2/Source/SwiftLintFramework/Extensions/QueuedPrint.swift

public func logMessage(_ level: LogLevel, _ string: CustomStringConvertible) {
  kLogQueue.async {
    switch (level, commandLogLevel) {
    case (.info, .quiet):
      break
    case (.info, _):
      fputs(ANSIColor.green.format("\(string)\n"), stdout)
    case (.warning, .quiet):
      break
    case (.warning, _):
      fputs(ANSIColor.yellow.format("swiftgen: warning: \(string)\n"), stderr)
    case (.error, _):
      fputs(ANSIColor.red.format("swiftgen: error: \(string)\n"), stderr)
    }
  }
}

private let kLogQueue: DispatchQueue = {
  let queue = DispatchQueue(
    label: "swiftgen.log.queue",
    qos: .userInteractive,
    target: .global(qos: .userInteractive)
  )

  // Make sure all the logs are printed before exiting the program
  #if !os(Linux)
  atexit_b {
    queue.sync(flags: .barrier) {}
  }
  #endif

  return queue
}()
