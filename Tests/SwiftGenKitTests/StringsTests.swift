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
    var receivedWarnings = [String]()
    parser.warningHandler = { message, _, _ -> Void in
      receivedWarnings.append(message)
    }
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

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

    XCTAssertEqual(receivedWarnings, [expectedMessage])
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

// Commented out since nested format strings in plurals are not supported yet.
//
//  func testNestedPlurals() throws {
//    let parser = try Strings.Parser()
//    try parser.searchAndParse(path: Fixtures.path(for: "LocPluralNested.stringsdict", sub: .strings))
//
//    let result = parser.stencilContext()
//    XCTDiffContexts(result, expected: "plurals-nested", sub: .strings)
//  }

  func testSameTableWithPluralsParsingStringsFirst() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-same-table", sub: .strings)
  }

  func testSameTableWithPluralsParsingPluralsFirst() throws {
    let parser = try Strings.Parser()
    var receivedWarnings = [String]()
    parser.warningHandler = { message, _, _ -> Void in
      receivedWarnings.append(message)
    }
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let expectedMessage = #"""
    Table "Localizable" already loaded by other parser, the parser for [.strings] files cannot modify existing keys:
    apples.count
    """#

    XCTAssertEqual(receivedWarnings, [expectedMessage])

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-same-table", sub: .strings)
  }

  func testInconsistentPluralDefinitionWhenInvalidFormatKey() throws {
    let parser = try Strings.Parser()

    XCTAssertThrowsError(
      try parser.searchAndParse(path: Fixtures.path(for: "LocPluralBroken.stringsdict", sub: .strings)),
      "Expected an error to be thrown"
    ) { error in
      guard let parserError = error as? Strings.ParserError else {
        XCTFail("Expected a Strings.ParserError")
        return
      }

      guard case .invalidPluralFormat(let missingVariableKey, let pluralKey) = parserError else {
        XCTFail("Expected an invalidPluralFormat error")
        return
      }

      XCTAssertEqual(missingVariableKey, "hat_bewertung")
      XCTAssertEqual(pluralKey, "plural.missing-variable")
    }
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
