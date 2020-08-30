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

  func testMp4s() throws {
    let parser = try Files.Parser()
    let path = Fixtures.directory(sub: .files)
    let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
    let parentDir = path.absolute().parent()

    for path in dirChildren where path.matches(filter: try Filter(pattern: ".mp4")) {
      try parser.parse(path: path, relativeTo: parentDir)
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "mp4s", sub: .files)
  }

  // MARK: - Custom options

  func testRelativeTo() throws {
    let parser = try Files.Parser(options: ["relativeTo": Fixtures.directory(sub: .files).string])
    try parser.searchAndParse(path: Fixtures.directory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "relativeTo", sub: .files)
  }

  func testCompact() throws {
    let parser = try Files.Parser(options: ["compact": true])
    try parser.searchAndParse(path: Fixtures.directory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "compact", sub: .files)
  }

  func testRelativeCompactFilter() throws {
    let parser = try Files.Parser(options: ["relativeTo": Fixtures.directory().string, "compact": true])
    try parser.searchAndParse(path: Fixtures.directory(sub: .files), filter: try Filter(pattern: ".mp4"))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "relativeCompactFilter", sub: .files)
  }

  func testSpecificFile() throws {
    let parser = try Files.Parser(options: ["relativeTo": Fixtures.directory().string, "compact": true])
    try parser.searchAndParse(path: Fixtures.directory(sub: .files) + "subdir/subdir/graphic.svg")

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "specificFile", sub: .files)
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
