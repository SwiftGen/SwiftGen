//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import TestUtils
import XCTest

final class FilesTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Files.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .files)
  }

  func testDefaults() throws {
    let parser = try Files.Parser()
    try parser.searchAndParse(path: Fixtures.resourceDirectory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .files)
  }

  func testMp4s() throws {
    let parser = try Files.Parser()
    try parser.searchAndParse(path: Fixtures.resourceDirectory(sub: .files), filter: try Filter(pattern: ".mp4"))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "mp4s", sub: .files)
  }

  // MARK: - Custom options

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
