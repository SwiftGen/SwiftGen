//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import TestUtils
import XCTest

final class ColorsJSONFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try Colors.Parser()
    let jsonParser = try Colors.JSONFileParser(options: try ParserOptionValues(options: [:], available: []))
    parser.palettes = [try jsonParser.parseFile(at: Fixtures.resource(for: "colors.json", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      let jsonParser = try Colors.JSONFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try jsonParser.parseFile(at: Fixtures.resource(for: "bad-syntax.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      let jsonParser = try Colors.JSONFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try jsonParser.parseFile(at: Fixtures.resource(for: "bad-value.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch Colors.ParserError.invalidHexColor(path: _, string: "this isn't a color", key: "ArticleTitle") {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
