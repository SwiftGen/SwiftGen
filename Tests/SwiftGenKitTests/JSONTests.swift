//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class JSONTests: XCTestCase {
  func testEmpty() throws {
    let parser = try JSON.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .json)
  }

  func testDictionary() throws {
    let parser = try JSON.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "configuration.json", sub: .json))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "configuration", sub: .json)
  }

  func testArray() throws {
    let parser = try JSON.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "array.json", sub: .json))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "array", sub: .json)
  }

  func testDirectoryInput() {
    do {
      let parser = try JSON.Parser()
      let filter = try Filter(pattern: "[^/]*\\.json$")
      try parser.searchAndParse(path: Fixtures.directory(sub: .json), filter: filter)

      let result = parser.stencilContext()
      XCTDiffContexts(result, expected: "all", sub: .json)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try JSON.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
