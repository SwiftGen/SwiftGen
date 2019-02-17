//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

final class TestFileParser1: ColorsFileTypeParser {
  init(options: ParserOptionValues) {}
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> Colors.Palette {
    return Colors.Palette(name: "test1", colors: [:])
  }
}

final class TestFileParser2: ColorsFileTypeParser {
  init(options: ParserOptionValues) {}
  static let extensions = ["test2"]
  func parseFile(at path: Path) throws -> Colors.Palette {
    return Colors.Palette(name: "test2", colors: [:])
  }
}

final class TestFileParser3: ColorsFileTypeParser {
  init(options: ParserOptionValues) {}
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> Colors.Palette {
    return Colors.Palette(name: "test3", colors: [:])
  }
}

class ColorParserTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Colors.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .colors)
  }

  // MARK: - Dispatch

  func testDispatchKnowExtension() throws {
    let parser = try Colors.Parser()
    parser.register(parser: TestFileParser1.self)
    parser.register(parser: TestFileParser2.self)

    let filter = try Filter(pattern: ".*\\.(test1|test2)$")
    try parser.searchAndParse(path: "someFile.test1", filter: filter)
    XCTAssertEqual(parser.palettes.first?.name, "test1")
  }

  func testDispatchUnknownExtension() throws {
    let parser = try Colors.Parser()
    parser.register(parser: TestFileParser1.self)
    parser.register(parser: TestFileParser2.self)

    do {
      let filter = try Filter(pattern: ".*\\.unknown$")
      try parser.searchAndParse(path: "someFile.unknown", filter: filter)
      XCTFail("Code did succeed while it was expected to fail for unknown extension")
    } catch Colors.ParserError.unsupportedFileType {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testDuplicateExtensionWarning() throws {
    var warned = false

    let parser = try Colors.Parser()
    parser.warningHandler = { message, file, line in
      warned = true
    }

    parser.register(parser: TestFileParser1.self)
    XCTAssert(!warned, "No warning should have been triggered")
    parser.register(parser: TestFileParser3.self)
    XCTAssert(warned, "Warning should have been triggered for duplicate extension")
  }

  // MARK: - Multiple palettes

  func testParseMultipleFiles() throws {
    let parser = try Colors.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "colors.clr", sub: .colors))
    try parser.searchAndParse(path: Fixtures.path(for: "extra.txt", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiple", sub: .colors)
  }

  // MARK: - String parsing

  func testStringNoPrefix() throws {
    let color = try Colors.parse(hex: "FFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithHash() throws {
    let color = try Colors.parse(hex: "#FFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWith0x() throws {
    let color = try Colors.parse(hex: "0xFFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithAlpha() throws {
    let color = try Colors.parse(hex: "FFFFFFCC", path: #file)
    XCTAssertEqual(color, 0xFFFFFFCC)
  }

  // MARK: - Hex Value

  func testHexValues() {
    let colors: [NSColor: UInt32] = [
      NSColor(red: 0, green: 0, blue: 0, alpha: 0): 0x00000000,
      NSColor(red: 1, green: 1, blue: 1, alpha: 1): 0xFFFFFFFF,
      NSColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1): 0xF8F8F8FF,
      NSColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1): 0xF7F7F7FF
    ]

    for (color, value) in colors {
      XCTAssertEqual(color.hexValue, value)
    }
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try Colors.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
