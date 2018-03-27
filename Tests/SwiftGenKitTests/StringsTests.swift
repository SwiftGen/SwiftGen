//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
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
  func testEmpty() {
    let parser = StringsParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .strings)
  }

  func testLocalizable() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "localizable.plist", sub: .strings)
  }

  func testMultiline() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiline.plist", sub: .strings)
  }

  func testUTF8File() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "LocUTF8.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "utf8.plist", sub: .strings)
  }

  func testStructuredOnly() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "LocStructuredOnly.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "structuredonly.plist", sub: .strings)
  }

  func testMultipleFiles() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.parse(path: Fixtures.path(for: "LocMultiline.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiple.plist", sub: .strings)
  }

  func testMultipleFilesDuplicate() throws {
    let parser = StringsParser()
    try parser.parse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    do {
      try parser.parse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
      XCTFail("Code did parse file successfully while it was expected to fail for duplicate file")
    } catch StringsParserError.duplicateTable {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
