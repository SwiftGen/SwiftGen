//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

final class StringsTests: XCTestCase {
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
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.stringsdict", sub: .strings))
    try parser.searchAndParse(path: Fixtures.path(for: "Localizable.strings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-same-table", sub: .strings)
  }

  func testErrorWhenSameTableWithDifferentPath() throws {
    let parser = try Strings.Parser()
    let path1 = Fixtures.path(for: "Localizable.strings", sub: .strings)
    try parser.searchAndParse(path: path1)

    let path2 = Fixtures.path(for: "en.lproj/Localizable.strings", sub: .strings)
    XCTAssertThrowsError(
      try parser.searchAndParse(path: path2),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .duplicateTableFile(let path, let existing) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }

      XCTAssertEqual(path, path2)
      XCTAssertEqual(existing, path1)
    }
  }

  func testErrorWhenUnsupportedFileType() throws {
    let parser = try Strings.Parser()
    let filter = try Filter(pattern: Strings.Parser.filterRegex(forExtensions: ["clr"]))

    XCTAssertThrowsError(
      try parser.searchAndParse(path: Fixtures.path(for: "colors.clr", sub: .colors), filter: filter),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .unsupportedFileType(let path, let supported) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }

      XCTAssertEqual(path.lastComponent, "colors.clr")
      XCTAssertEqual(supported, ["stringsdict", "strings"])
    }
  }

  func testErrorWhenBothPluralAndVariableWidthKeys() throws {
    let parser = try Strings.Parser()

    XCTAssertThrowsError(
      try parser.searchAndParse(path: Fixtures.path(for: "LocPluralErrorBothTypeKeys.stringsdict", sub: .strings)),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .invalidFormat(let reason) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }

      XCTAssertEqual(
        reason,
        """
        Entry "competition.tab.favorite-players" expects either "NSStringLocalizedFormatKey" or \
        "NSStringVariableWidthRuleType" but got either neither or both
        """
      )
    }
  }

  func testErrorWhenMissingVariableInPluralDefinition() throws {
    let parser = try Strings.Parser()

    XCTAssertThrowsError(
      try parser.searchAndParse(path: Fixtures.path(for: "LocPluralErrorMissingVariable.stringsdict", sub: .strings)),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .invalidPluralFormat(let missingVariableKey, let pluralKey) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }

      XCTAssertEqual(missingVariableKey, "hat_bewertung")
      XCTAssertEqual(pluralKey, "plural.missing-variable")
    }
  }

  func testErrorWhenWrongPositionalValueInFormatKey() throws {
    let parser = try Strings.Parser()

    XCTAssertThrowsError(
      try parser.searchAndParse(path: Fixtures.path(for: "LocPluralErrorPlaceholders.stringsdict", sub: .strings)),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .invalidPlaceholder(previous: .object, new: .int) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }
    }
  }

  func testErrorWhenInvalidValueInVariable() throws {
    let parser = try Strings.Parser()

    XCTAssertThrowsError(
      // swiftlint:disable:next line_length
      try parser.searchAndParse(path: Fixtures.path(for: "LocPluralErrorInvalidVariableValue.stringsdict", sub: .strings)),
      "Expected an error to be thrown"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .invalidVariableRuleValueType(let variableName, let valueType) = parserError
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }

      XCTAssertEqual(variableName, "variable")
      XCTAssertEqual(valueType, "@")
    }
  }

  func testUnsupportedPluralDefinition() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "LocPluralUnsupported.stringsdict", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-unsupported", sub: .strings)
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
