//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class ColorsCLRFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = Colors.Parser()
    parser.palettes = [try Colors.CLRFileParser().parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))]

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "defaults", sub: .colors)
  }

  func testFileWithBadFile() {
    do {
      _ = try Colors.CLRFileParser().parseFile(at: Fixtures.path(for: "bad.clr", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch Colors.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
