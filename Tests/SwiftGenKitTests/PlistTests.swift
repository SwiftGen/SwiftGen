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
    try parser.parse(path: Fixtures.path(for: "array.plist", sub: .plist))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "array", sub: .plist)
  }

  func testDictionary() throws {
    let parser = Plist.Parser()
    try parser.parse(path: Fixtures.path(for: "dictionary.plist", sub: .plist))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "dictionary", sub: .plist)
  }

  func testDirectoryInput() {
    do {
      _ = try Plist.Parser().parse(path: Fixtures.directory(sub: .plist))
      XCTFail("Code did parse directory successfully while it was expected to fail requiring that the input be a file")
    } catch Plist.ParserError.directory {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Plist.Parser().parse(path: Fixtures.path(for: "bad-syntax.plist", sub: .plist))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Plist.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
