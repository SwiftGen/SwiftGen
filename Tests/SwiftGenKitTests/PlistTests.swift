//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class PlistTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Plist.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .plist)
  }

  func testArray() throws {
    let parser = try Plist.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "shopping-list.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "shopping-list", sub: .plist)
  }

  func testDictionary() throws {
    let parser = try Plist.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "configuration.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "configuration", sub: .plist)
  }

  func testInfo() throws {
    let parser = try Plist.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Info.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "info", sub: .plist)
  }

  func testDirectoryInput() {
    do {
      let parser = try Plist.Parser()
      try parser.searchAndParse(path: Fixtures.directory(sub: .plistGood))

      let result = parser.stencilContext()
      XCTDiffContexts(result, expected: "all", sub: .plist)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Plist.Parser().searchAndParse(path: Fixtures.path(for: "syntax.plist", sub: .plistBad))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Plist.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
