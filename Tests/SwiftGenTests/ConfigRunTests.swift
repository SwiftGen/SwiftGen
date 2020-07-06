//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
import XCTest
import Yams

final class ConfigRunTests: XCTestCase {
  private lazy var bundle = Bundle(for: type(of: self))

  private func testRun(
    fixture: String,
    expected expectedLogs: [(LogLevel, String)],
    unwanted unwantedLevels: Set<LogLevel> = [],
    assertion assertionMessage: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let path = bundle.path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    let configFile = Path(path)
    let logger = TestLogger(expectedLogs: expectedLogs, unwantedLevels: unwantedLevels, file: file, line: line)

    do {
      let config = try Config(file: configFile, logger: logger.log)
      try configFile.parent().chdir {
        try config.runCommands(verbose: true, logger: logger.log)
      }
    } catch Config.Error.multipleErrors(let errors) {
      errors.forEach(logger.handleError)
    } catch let error {
      logger.handleError(error)
    }

    logger.waitAndAssert(message: assertionMessage)
  }

  func testMultipleErrors() {
    let logs: [(LogLevel, String)] = [
      (.error, "Parser `bar` does not exist."),
      (.error, "Parser `foo` does not exist.")
    ]

    testRun(fixture: "config-invalid-parsers", expected: logs, assertion: "Run should fail for non-existing parsers.")
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

    testRun(
      fixture: "config-with-multi-entries",
      expected: logs,
      assertion: "Expect multiple errors and run information"
    )
  }
}
