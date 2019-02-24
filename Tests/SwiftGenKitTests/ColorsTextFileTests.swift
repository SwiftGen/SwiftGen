//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class ColorsTextFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try Colors.Parser()
    let txtParser = Colors.TextFileParser(options: try ParserOptionValues(options: [:], available: []))
    parser.palettes = [try txtParser.parseFile(at: Fixtures.path(for: "extra.txt", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "extra", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      let txtParser = Colors.TextFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try txtParser.parseFile(at: Fixtures.path(for: "bad-syntax.txt", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      let txtParser = Colors.TextFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try txtParser.parseFile(at: Fixtures.path(for: "bad-value.txt", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch Colors.ParserError.invalidHexColor(path: _, string: "thisIsn'tAColor", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
