//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class ColorsJSONFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = Colors.Parser()
    parser.palettes = [try Colors.JSONFileParser().parseFile(at: Fixtures.path(for: "colors.json", sub: .colors))]

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Colors.JSONFileParser().parseFile(at: Fixtures.path(for: "bad-syntax.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      _ = try Colors.JSONFileParser().parseFile(at: Fixtures.path(for: "bad-value.json", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch Colors.ParserError.invalidHexColor(path: _, string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
