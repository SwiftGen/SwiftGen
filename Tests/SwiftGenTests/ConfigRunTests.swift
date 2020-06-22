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
    fixture: String
  ) throws {
    guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }

    let configFile = Path(path)
    let config = try Config(file: configFile)

    try configFile.parent().chdir {
      try config.runActions(verbose: true)
    }
  }

  func testMultipleErrors() {
    do {
      try _testRun(fixture: "config-invalid-parsers")
    } catch let error as Config.Error {
      XCTAssertEqual(
        error.description,
        """
        Parser `bar` does not exist.
        Parser `foo` does not exist.
        """
      )
    } catch let error {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
