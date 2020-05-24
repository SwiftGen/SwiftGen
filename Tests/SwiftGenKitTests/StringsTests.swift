//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

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
    var receivedWarning: String?
    parser.warningHandler = { message, _, _ -> Void in
      receivedWarning = message
    }
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let errorMessage = try XCTUnwrap(receivedWarning)
    let expectedMessage = #"""
    Table "Localizable" already loaded by other parser, the parser for [.strings] files cannot modify existing keys:
    ObjectOwnership
    alert__message
    alert__title
    apples.count
    bananas.owner
    percent
    private
    settings.navigation-bar.self
    settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep
    settings.navigation-bar.title.even.deeper
    settings.user__profile_section.HEADER_TITLE
    settings.user__profile_section.footer_text
    types
    """#

    XCTAssertEqual(errorMessage, expectedMessage)
  }

  func testPlurals() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals", sub: .strings)
  }

  func testAdvancedPlurals() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "LocPluralAdvanced.stringsdict", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-advanced", sub: .strings)
  }

  func testSameTableWithPluralsParsingStringsFirst() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-same-table-strings-first", sub: .strings)
  }

  func testSameTableWithPluralsParsingPluralsFirst() throws {
    let parser = try Strings.Parser()
    var receivedWarning: String?
    parser.warningHandler = { message, _, _ -> Void in
      receivedWarning = message
    }
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let errorMessage = try XCTUnwrap(receivedWarning)
    let expectedMessage = #"""
    Table "Localizable" already loaded by other parser, the parser for [.strings] files cannot modify existing keys:
    apples.count
    """#

    XCTAssertEqual(errorMessage, expectedMessage)

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-same-table-plurals-first", sub: .strings)
  }

  // MARK: - Custom options

  func testCustomSeparator() throws {
    let parser = try Strings.Parser(options: ["separator": "__"])
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "custom-separator", sub: .strings)
  }

  func testUnknownOption() throws {
    do {
      _ = try Strings.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
