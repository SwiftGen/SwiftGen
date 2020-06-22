//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
import XCTest
import Yams

class ConfigRunTests: XCTestCase {
  private func _testRun(
    fixture: String,
    expected expectedLogs: [(LogLevel, String)],
    unwanted unwantedLevels: Set<LogLevel> = [],
    assertion assertionMessage: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    var missingLogs = expectedLogs
    let configFile = Path(path)
    let logQueue = DispatchQueue(label: "swiftgen.log.queue")
    let logger = { (level: LogLevel, msg: String) -> Void in
      logQueue.async {
        if let idx = missingLogs.firstIndex(where: { $0 == level && $1 == msg }) {
          missingLogs.remove(at: idx)
        } else if unwantedLevels.contains(level) {
          XCTFail("Unexpected log: \(msg)")
        }
      }
    }
    let errorHandler = { (error: Error) -> Void in
      if let idx = missingLogs.firstIndex(where: { $0 == .error && $1 == String(describing: error) }) {
        missingLogs.remove(at: idx)
      } else {
        XCTFail("Unexpected error: \(error)", file: file, line: line)
      }
    }

    do {
      let config = try Config(file: configFile, logger: logger)

      try configFile.parent().chdir {
        try config.runActions(verbose: true, logger: logger)
      }
    } catch Config.Error.multipleErrors(let errors) {
      errors.forEach(errorHandler)
    } catch let error {
      errorHandler(error)
    }

    logQueue.sync(flags: .barrier) {}
    XCTAssertTrue(
      missingLogs.isEmpty,
      """
      \(assertionMessage)
      The following logs were expected but never received:
      \(missingLogs.map { "\($0) - \($1)" }.joined(separator: "\n"))
      """,
      file: file,
      line: line
    )
  }

  func testMultipleErrors() {
    let logs: [(LogLevel, String)] = [
      (.error, "Parser `bar` does not exist."),
      (.error, "Parser `foo` does not exist.")
    ]

    _testRun(fixture: "config-invalid-parsers", expected: logs, assertion: "Run should fail for non-existing parsers.")
  }

  func testMultipleEntries() {
    // swiftlint:disable line_length
    let logs: [(LogLevel, String)] = [
      (.info, " $ swiftgen xcassets --templateName swift5 --output Generated/assets-colors.swift Fixtures/XCAssets/Colors.xcassets"),
      (.info, " $ swiftgen xcassets --templateName custom-swift5 --param enumName=Pics --output Generated/assets-images.swift Fixtures/XCAssets/Images.xcassets"),
      (.info, " $ swiftgen strings --templatePath templates/custom-swift5 --param enumName=Loc --output Generated/strings.swift Fixtures/Strings/Localizable.strings"),
      (.info, " $ swiftgen xcassets --templateName swift5 --output Generated/assets-all.swift Fixtures/XCAssets/Colors.xcassets Fixtures/XCAssets/Images.xcassets"),
      (.error, "File Fixtures/Strings/Localizable.strings not found."),
      (.error, "File Fixtures/XCAssets/Colors.xcassets not found."),
      (.error, "File Fixtures/XCAssets/Images.xcassets not found."),
      (.error, "File Fixtures/XCAssets/Colors.xcassets not found.")
    ]
    // swiftlint:enable line_length

    _testRun(
      fixture: "config-with-multi-entries",
      expected: logs,
      assertion: "Expect multiple errors and run information"
    )
  }
}
