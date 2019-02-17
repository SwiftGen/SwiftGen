//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit.NSFont
import PathKit
@testable import SwiftGenKit
import XCTest

class FontsTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Fonts.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .fonts)
  }

  func testDefaults() throws {
    let parser = try Fonts.Parser()
    try parser.searchAndParse(path: Fixtures.directory())

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .fonts)
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try Fonts.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }

  // MARK: - Path relative(to:)

  func testPathRelativeTo_UnrelatedIsNil() throws {
    let parent = Path("/a/b/c")
    let file = Path("/d/e/f")

    XCTAssertNil(file.relative(to: parent))
  }

  func testPathRelativeTo_RelatedIsNotNil() throws {
    let parent = Path("/a/b/c")
    let file = Path("/a/b/c/d/e")

    XCTAssertNotNil(file.relative(to: parent))
  }

  func testPathRelativeTo_ResultIsNotFullPath() throws {
    let parent = Path("a/b/c")
    let absoluteParent = parent.absolute()
    let file = Path("a/b/c/d/e")
    let absoluteFile = file.absolute()

    XCTAssertEqual(file.relative(to: parent), "d/e")
    XCTAssertEqual(file.relative(to: absoluteParent), "d/e")
    XCTAssertEqual(absoluteFile.relative(to: parent), "d/e")
    XCTAssertEqual(absoluteFile.relative(to: absoluteParent), "d/e")
  }
}
