//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class ColorsXMLFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try Colors.Parser()
    let xmlParser = Colors.XMLFileParser(options: try ParserOptionValues(options: [:], available: []))
    parser.palettes = [try xmlParser.parseFile(at: Fixtures.path(for: "colors.xml", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadSyntax() {
    do {
      let xmlParser = Colors.XMLFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try xmlParser.parseFile(at: Fixtures.path(for: "bad-syntax.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadValue() {
    do {
      let xmlParser = Colors.XMLFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try xmlParser.parseFile(at: Fixtures.path(for: "bad-value.xml", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad value")
    } catch Colors.ParserError.invalidHexColor(path: _, string: "this isn't a color", key: "ArticleTitle"?) {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
