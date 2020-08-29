//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
@testable import SwiftGenKit
import XCTest

final class FilesTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Files.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .files)
  }

  func testDefaults() throws {
    let parser = try Files.Parser()
    try parser.searchAndParse(path: Fixtures.directory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .files)
  }

  // MARK: - Custom options

  func testStructuredDirs() throws {
    let parser = try Files.Parser(options: ["structured": true])
    try parser.searchAndParse(path: Fixtures.directory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "structured", sub: .files)
  }

  func testUnknownOption() throws {
    do {
      _ = try Files.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
