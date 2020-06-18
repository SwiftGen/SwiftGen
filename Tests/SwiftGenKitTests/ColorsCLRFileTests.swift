//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class ColorsCLRFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = try Colors.Parser()
    let clrParser = Colors.CLRFileParser(options: try ParserOptionValues(options: [:], available: []))
    parser.palettes = [try clrParser.parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadFile() {
    do {
      let clrParser = Colors.CLRFileParser(options: try ParserOptionValues(options: [:], available: []))
      _ = try clrParser.parseFile(at: Fixtures.path(for: "bad.clr", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
