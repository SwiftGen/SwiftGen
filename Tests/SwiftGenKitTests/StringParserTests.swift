//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

class StringParserTests: XCTestCase {
  func testParseStringPlaceholder() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseFloatPlaceholder() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.float])
  }

  func testParseDoublePlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.float, .float])
  }

  func testParseFloatWithPrecisionPlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.float, .float, .float, .float])
  }

  func testParseIntPlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.int, .int, .int, .int, .int])
  }

  func testParseCCharAndStringPlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.char, .cString])
  }

  func testParsePositionalPlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.char, .int, .object, .float])
  }

  func testParseComplexFormatPlaceholders() throws {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: format)
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.unknown, .int, .object, .float, .char])
  }

  func testParseDuplicateFormatPlaceholders() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "Text: %1$@; %1$@.")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseErrorOnTypeMismatch() throws {
    do {
      _ = try StringsParser.PlaceholderType.placeholders(fromFormat: "Text: %1$@; %1$ld.")
      XCTFail("Code did parse string successfully while it was expected to fail for bad syntax")
    } catch StringsParserError.invalidPlaceholder {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testParseEvenEscapePercentSign() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%%foo")
    // Must NOT map to [.float]
    XCTAssertEqual(placeholders, [])
  }

  func testParseOddEscapePercentSign() throws {
    let placeholders = try StringsParser.PlaceholderType.placeholders(fromFormat: "%%%foo")
    // Should map to [.float]
    XCTAssertEqual(placeholders, [.float])
  }
}
