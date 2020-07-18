//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

final class StringPlaceholderTypeTests: XCTestCase {
  func testParseStringPlaceholder() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%@")
    XCTAssertEqual(placeholders, [.object])
  }

  func testParseFloatPlaceholder() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%f")
    XCTAssertEqual(placeholders, [.float])
  }

  func testParseDoublePlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%g-%e")
    XCTAssertEqual(placeholders, [.float, .float])
  }

  func testParseFloatWithPrecisionPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%1.2f : %.3f : %+3f : %-6.2f")
    XCTAssertEqual(placeholders, [.float, .float, .float, .float])
  }

  func testParseIntPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%d-%i-%o-%u-%x")
    XCTAssertEqual(placeholders, [.int, .int, .int, .int, .int])
  }

  func testParseCCharAndStringPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%c-%s")
    XCTAssertEqual(placeholders, [.char, .cString])
  }

  func testParsePositionalPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%2$d-%4$f-%3$@-%c")
    XCTAssertEqual(placeholders, [.char, .int, .object, .float])
  }

  func testParseComplexFormatPlaceholders() throws {
    let format = "%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%"
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: format)
    // positions 2, 4, 3, 5 set to .int, .float, .object, .char ; position 1 not matched
    XCTAssertEqual(placeholders, [.int, .object, .float, .char])
  }

  func testParseManyPlaceholders() throws {
    let format = "%@ - %d - %f - %5$d - %04$f - %6$d - %007$@ - %8$3.2f - %11$1.2f - %9$@ - %10$d"
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: format)
    XCTAssertEqual(
      placeholders,
      [.object, .int, .float, .float, .int, .int, .object, .float, .object, .int, .float]
    )
  }

  func testParseManyPlaceholdersWithZeroPos() throws {
    // %0$@ is interpreted by Foundation not as a placeholder (because invalid 0 position)
    // but instead rendered as a "0@" literal.
    let format = "%@ - %d - %0$@ - %f - %5$d - %04$f - %6$d - %007$@ - %8$3.2f - %11$1.2f - %9$@ - %10$d"
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: format)
    XCTAssertEqual(
      placeholders,
      [.object, .int, .float, .float, .int, .int, .object, .float, .object, .int, .float]
    )
  }

  func testParseInterleavedPositionalAndNonPositionalPlaceholders() throws {
    let format = "%@ %7$d %@ %@ %8$d %@ %@"
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: format)
    XCTAssertEqual(placeholders, [.object, .object, .object, .object, .object, /* ?, */ .int, .int])
  }

  func testParseFlags() throws {
    let formats = ["%-9d", "%+9d", "% 9d", "%#9d", "%09d"]
    for format in formats {
      let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: format)
      XCTAssertEqual(placeholders, [.int], "Failed to parse format \"\(format)\"")
    }

    let invalidFormat = "%_9d %_9f %_9@ %!9@"
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: invalidFormat)
    XCTAssertEqual(placeholders, [])
  }

  func testParseDuplicateFormatPlaceholders() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "Text: %1$@; %1$@.")
    XCTAssertEqual(placeholders, [.object])
  }

  private func pluralVariable(
    _ name: String,
    type: String,
    one: String,
    other: String
  ) -> StringsDict.PluralEntry.Variable {
    .init(name: name, rule: .init(
      specTypeKey: "NSStringPluralRuleType",
      valueTypeKey: type,
      zero: nil,
      one: one,
      two: nil,
      few: nil,
      many: nil,
      other: other
      )
    )
  }

  func testStringsDictPlaceholdersConversion() throws {
    let entry = StringsDict.PluralEntry(
      formatKey:
      """
      %@ - %#@d2@ - %0$#@zero@ - %#@f3@ - %5$#@d5@ - %04$#@f4@ - %6$#@d6@ - %007$@
      - %8$#@f8@ - %11$#@f11@ - %9$@ - %10$#@d10@
      """,
      variables: [
        pluralVariable("zero", type: "d", one: "unused", other: "unused"),
        pluralVariable("d2", type: "d", one: "%d two", other: "%d twos"),
        pluralVariable("f3", type: "f", one: "%f three", other: "%f threes"),
        pluralVariable("f4", type: "f", one: "%f four", other: "%f fours"),
        pluralVariable("d5", type: "d", one: "%d five", other: "%d fives"),
        pluralVariable("d6", type: "d", one: "%d six", other: "%d sixes"),
        pluralVariable("f8", type: "f", one: "%f eight", other: "%f eights"),
        pluralVariable("d10", type: "d", one: "%d ten", other: "%d tens"),
        pluralVariable("f11", type: "f", one: "%f eleven", other: "%f elevens")
      ]
    )

    let converted = entry.formatKeyWithVariableValueTypes
    XCTAssertEqual(
      converted,
      "%@ - %d - %0$d - %f - %5$d - %4$f - %6$d - %007$@\n- %8$f - %11$f - %9$@ - %10$d"
    )

    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: converted)
    XCTAssertEqual(
      placeholders,
      [.object, .int, .float, .float, .int, .int, .object, .float, .object, .int, .float]
    )
  }

  // MARK: - Testing Errors

  func testParseErrorOnTypeMismatch() throws {
    XCTAssertThrowsError(
      try Strings.PlaceholderType.placeholderTypes(fromFormat: "Text: %1$@; %1$ld."),
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
        try Strings.PlaceholderType.placeholderTypes(fromFormat: formatString),
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

  // MARK: - Testing Percent Escapes

  func testParseEvenEscapePercentSign() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%%foo")
    // Must NOT map to [.float]
    XCTAssertEqual(placeholders, [])
  }

  func testParseOddEscapePercentSign() throws {
    let placeholders = try Strings.PlaceholderType.placeholderTypes(fromFormat: "%%%foo")
    // Should map to [.float]
    XCTAssertEqual(placeholders, [.float])
  }
}
