//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import TestUtils
import XCTest

final class ColorsXMLFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try Colors.Parser()
    let options = try ParserOptionValues(options: [:], available: Colors.XMLFileParser.allOptions)
    let xmlParser = try Colors.XMLFileParser(options: options)
    parser.palettes = [try xmlParser.parseFile(at: Fixtures.resource(for: "colors.xml", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      let options = try ParserOptionValues(options: [:], available: Colors.XMLFileParser.allOptions)
      let xmlParser = try Colors.XMLFileParser(options: options)
      _ = try xmlParser.parseFile(at: Fixtures.resource(for: "bad-syntax.xml", sub: .colors))

      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      let options = try ParserOptionValues(options: [:], available: Colors.XMLFileParser.allOptions)
      let xmlParser = try Colors.XMLFileParser(options: options)
      _ = try xmlParser.parseFile(at: Fixtures.resource(for: "bad-value.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch Colors.ParserError.invalidHexColor(path: _, string: "this isn't a color", key: "ArticleTitle") {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithUnknownName() {
    do {
      let options = try ParserOptionValues(options: [:], available: Colors.XMLFileParser.allOptions)
      let xmlParser = try Colors.XMLFileParser(options: options)
      _ = try xmlParser.parseFile(at: Fixtures.resource(for: "bad-name.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for unknown name")
    } catch Colors.ParserError.colorNotFound(path: _, name: "@color/bar") {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  // MARK: - Custom options

  func testFileWithArgb() throws {
    let parser = try Colors.Parser()
    let options = try ParserOptionValues(options: ["colorFormat": "argb"], available: Colors.XMLFileParser.allOptions)
    let xmlParser = try Colors.XMLFileParser(options: options)
    parser.palettes = [try xmlParser.parseFile(at: Fixtures.resource(for: "colors-argb.xml", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "argb", sub: .colors)
  }

  func testFileWithUnsupportedColorFormat() {
    do {
      let options = try ParserOptionValues(options: ["colorFormat": "bad"], available: Colors.XMLFileParser.allOptions)
      let xmlParser = try Colors.XMLFileParser(options: options)
      _ = try xmlParser.parseFile(at: Fixtures.resource(for: "colors-argb.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for unsupported color format")
    } catch Colors.ParserError.unsupportedColorFormat {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
