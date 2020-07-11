//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

final class StringPlaceholderTypeTests: XCTestCase {
  func testParseStringPlaceholder() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseFloatPlaceholder() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.float])
  }

  func testParseDoublePlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.float, .float])
  }

  func testParseFloatWithPrecisionPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.float, .float, .float, .float])
  }

  func testParseIntPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.int, .int, .int, .int, .int])
  }

  func testParseCCharAndStringPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.char, .cString])
  }

  func testParsePositionalPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.char, .int, .object, .float])
  }

  func testParseComplexFormatPlaceholders() throws {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: format)
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
    XCTAssertEqual(placeholders, [.unknown, .int, .object, .float, .char])
  }

  func testParseInterleavedPositionalAndNonPositionalPlaceholders() throws {
    let format = "%@ %7$d %@ %@ %8$d %@ %@"
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: format)
    XCTAssertEqual(placeholders, [.object, .object, .object, .object, .object, .unknown, .int, .int])
  }

  func testParseFlags() throws {
    let formats = ["%-9d", "%+9d", "% 9d", "%#9d", "%09d"]
    for format in formats {
      let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: format)
      XCTAssertEqual(placeholders, [.int], "Failed to parse format \"\(format)\"")
    }

    let invalidFormat = "%_9d %_9f %_9@ %!9@"
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: invalidFormat)
    XCTAssertEqual(placeholders, [])
  }

  func testParseDuplicateFormatPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "Text: %1$@; %1$@.")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseErrorOnTypeMismatch() throws {
    XCTAssertThrowsError(
      try Strings.PlaceholderType.placeholders(fromFormat: "Text: %1$@; %1$ld."),
      "Code did parse string successfully while it was expected to fail for bad syntax"
    ) { error in
      guard
        let parserError = error as? Strings.ParserError,
        case .invalidPlaceholder = parserError // That's the expected exception we want to happen
      else {
        XCTFail("Unexpected error occured while parsing: \(error)")
        return
      }
    }
  }

  func testParseErrorOnPositionalValueBeingOverwritten() throws {
    let formatStrings: [String: (Strings.PlaceholderType, Strings.PlaceholderType)] = [
      "%@ %1$d": (.object, .int), // `.int` would overwrite existing `.object`
      "%1$d %@": (.int, .object), // `.object` would overwrite existing `.int`
      "%@ %2$d %@": (.int, .object), // `.object` would overwrite existing `.int`
      "%@ %2$d %@ %@ %5$d %@ %@": (.int, .object), // `.object` would overwrite existing `.int`
      "%@ %@ %2$d %@ %5$d %@ %@": (.object, .int) // `.int` would overwrite existing `.object`
    ]
    for (formatString, expectedFormats) in formatStrings {
      XCTAssertThrowsError(
        try Strings.PlaceholderType.placeholders(fromFormat: formatString),
        "Code did parse string successfully while it was expected to fail for bad syntax"
      ) { error in
        guard
          let parserError = error as? Strings.ParserError,
          case .invalidPlaceholder(previous: expectedFormats.0, new: expectedFormats.1) = parserError
        else {
          XCTFail("Unexpected error occured while parsing: \(error)")
          return
        }
      }
    }
  }

  func testParseEvenEscapePercentSign() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%%foo")
    // Must NOT map to [.float]
    XCTAssertEqual(placeholders, [])
  }

  func testParseOddEscapePercentSign() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: "%%%foo")
    // Should map to [.float]
    XCTAssertEqual(placeholders, [.float])
  }

  // MARK: - Normalizing Positionals

  func testParsePositionalPlaceholdersNormalized() throws {
    let placeholders = try Strings.PlaceholderType.placeholders(
      fromFormat: "%2$d-%4$f-%3$@-%c",
      normalizePositionals: true
    )
    XCTAssertEqual(placeholders, [.char, .int, .object, .float])
  }

  func testParseComplexFormatPlaceholdersNormalized() throws {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: format, normalizePositionals: true)
    // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched
    XCTAssertEqual(placeholders, [.int, .object, .float, .char])
  }

  func testParseInterleavedPositionalAndNonPositionalPlaceholdersNormalized() throws {
    let format = "%@ %7$d %@ %@ %8$d %@ %@"
    let placeholders = try Strings.PlaceholderType.placeholders(fromFormat: format, normalizePositionals: true)
    XCTAssertEqual(placeholders, [.object, .object, .object, .object, .object, .int, .int])
  }
}
