//
//  FontsTests.swift
//  SwiftGenKit
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import AppKit.NSFont
import PathKit
@testable import SwiftGenKit
import XCTest

class FontsTests: XCTestCase {
  func testEmpty() {
    let parser = FontsParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .fonts)
  }

  func testDefaults() {
    let parser = FontsParser()
    parser.parse(path: Fixtures.directory(sub: .fonts))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults.plist", sub: .fonts)
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
