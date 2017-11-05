//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import PathKit
import XCTest
@testable import SwiftGenKit

final class TestFileParser1: ColorsFileTypeParser {
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> Palette {
    return Palette(name: "test1", colors: [:])
  }
}

final class TestFileParser2: ColorsFileTypeParser {
  static let extensions = ["test2"]
  func parseFile(at path: Path) throws -> Palette {
    return Palette(name: "test2", colors: [:])
  }
}

final class TestFileParser3: ColorsFileTypeParser {
  static let extensions = ["test1"]
  func parseFile(at path: Path) throws -> Palette {
    return Palette(name: "test3", colors: [:])
  }
}

class ColorParserTests: XCTestCase {
  func testEmpty() throws {
    let parser = ColorsParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .colors)
  }

  // MARK: - Dispatch

  func testDispatchKnowExtension() throws {
    let parser = ColorsParser()
    parser.register(parser: TestFileParser1.self)
    parser.register(parser: TestFileParser2.self)

    try parser.parse(path: "someFile.test1")
    XCTAssertEqual(parser.palettes.first?.name, "test1")
  }

  func testDispatchUnknownExtension() throws {
    let parser = ColorsParser()
    parser.register(parser: TestFileParser1.self)
    parser.register(parser: TestFileParser2.self)

    do {
      try parser.parse(path: "someFile.unknown")
      XCTFail("Code did succeed while it was expected to fail for unknown extension")
    } catch ColorsParserError.unsupportedFileType {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testDuplicateExtensionWarning() throws {
    var warned = false

    let parser = ColorsParser()
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
    let parser = ColorsParser()
    try parser.parse(path: Fixtures.path(for: "colors.clr", sub: .colors))
    try parser.parse(path: Fixtures.path(for: "extra.txt", sub: .colors))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiple.plist", sub: .colors)
  }

  // MARK: - String parsing

  func testStringNoPrefix() throws {
    let color = try parse(hex: "FFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithHash() throws {
    let color = try parse(hex: "#FFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWith0x() throws {
    let color = try parse(hex: "0xFFFFFF", path: #file)
    XCTAssertEqual(color, 0xFFFFFFFF)
  }

  func testStringWithAlpha() throws {
    let color = try parse(hex: "FFFFFFCC", path: #file)
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
}
