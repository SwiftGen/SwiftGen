//
// SwiftGen UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import SwiftGenCLI
import XCTest

public final class TestLogger {
  private let queue = DispatchQueue(label: "swiftgen.log.queue")
  private let unwantedLevels: Set<LogLevel>
  private let file: StaticString
  private let line: UInt
  private var missingLogs: [(LogLevel, String)]

  public init(
    expectedLogs: [(LogLevel, String)],
    unwantedLevels: Set<LogLevel> = [],
    file: StaticString,
    line: UInt
  ) {
    self.missingLogs = expectedLogs
    self.unwantedLevels = unwantedLevels
    self.file = file
    self.line = line
  }

  public func log(level: LogLevel, msg: String) {
    queue.async {
      if let idx = self.missingLogs.firstIndex(where: { $0 == level && $1 == msg }) {
        self.missingLogs.remove(at: idx)
      } else if self.unwantedLevels.contains(level) {
        XCTFail("Unexpected log: \(msg)", file: self.file, line: self.line)
      }
    }
  }

  public func handleError(_ error: Error) {
    if let idx = missingLogs.firstIndex(where: { $0 == .error && $1 == String(describing: error) }) {
      missingLogs.remove(at: idx)
    } else {
      XCTFail("Unexpected error: \(error)", file: file, line: line)
    }
  }

  public func waitAndAssert(message: String) {
    queue.sync(flags: .barrier) {}

    XCTAssertTrue(
      missingLogs.isEmpty,
      """
      \(message)
      The following logs were expected but never received:
      \(missingLogs.map { "\($0) - \($1)" }.joined(separator: "\n"))
      """,
      file: file,
      line: line
    )
  }
}
