//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit
@testable import SwiftGenKit

class ColorsCLRFileTests: XCTestCase {
  func testFileWithDefaults() throws {
    let parser = ColorsParser()
    parser.palettes = [try ColorsCLRFileParser().parseFile(at: Fixtures.path(for: "colors.clr", sub: .colors))]

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .colors)
  }

  func testFileWithBadFile() {
    do {
      _ = try ColorsCLRFileParser().parseFile(at: Fixtures.path(for: "bad.clr", sub: .colors))
      XCTFail("Code did parse file successfully while it was expected to fail for bad file")
    } catch ColorsParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
