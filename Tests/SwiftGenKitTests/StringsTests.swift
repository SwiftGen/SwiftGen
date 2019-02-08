//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import SwiftGenKit
import XCTest

/**
 * Important: In order for the "*.strings" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.strings" using PBXCp »
 */

class StringsTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Strings.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .strings)
  }

  func testLocalizable() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "localizable", sub: .strings)
  }

  func testMultiline() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiline", sub: .strings)
  }

  func testUTF8File() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "LocUTF8.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "utf8", sub: .strings)
  }

  func testStructuredOnly() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "LocStructuredOnly.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "structuredonly", sub: .strings)
  }

  func testMultipleFiles() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiple", sub: .strings)
  }

  func testMultipleFilesDuplicate() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    do {
      try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
      XCTFail("Code did parse file successfully while it was expected to fail for duplicate file")
    } catch Strings.ParserError.duplicateTable {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testCustomSeparator() throws {
    let parser = try Strings.Parser(options: ["separator": "__"])
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "custom-separator", sub: .strings)
  }
}
