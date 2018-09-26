//
//  PlistTests.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import PathKit
@testable import SwiftGenKit
import XCTest

class PlistTests: XCTestCase {
  func testEmpty() {
    let parser = Plist.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .plist)
  }

  func testArray() throws {
    let parser = Plist.Parser()
    try parser.parse(path: Fixtures.path(for: "shopping-list.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "shopping-list", sub: .plist)
  }

  func testDictionary() throws {
    let parser = Plist.Parser()
    try parser.parse(path: Fixtures.path(for: "configuration.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "configuration", sub: .plist)
  }

  func testInfo() throws {
    let parser = Plist.Parser()
    try parser.parse(path: Fixtures.path(for: "Info.plist", sub: .plistGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "info", sub: .plist)
  }

  func testDirectoryInput() {
    do {
      let parser = Plist.Parser()
      try parser.parse(path: Fixtures.directory(sub: .plistGood))

      let result = parser.stencilContext()
      XCTDiffContexts(result, expected: "all", sub: .plist)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Plist.Parser().parse(path: Fixtures.path(for: "syntax.plist", sub: .plistBad))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Plist.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
