//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import PathKit
import SwiftGenKit
import XCTest

class AssetCatalogTests: XCTestCase {
  func testEmpty() {
    let parser = AssetsCatalog.Parser()

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "empty", sub: .xcassets)
  }

  func testImages() throws {
    let parser = AssetsCatalog.Parser()
    try parser.parse(path: Fixtures.path(for: "Images.xcassets", sub: .xcassets))

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "images", sub: .xcassets)
  }

  func testColors() throws {
    let parser = AssetsCatalog.Parser()
    try parser.parse(path: Fixtures.path(for: "Colors.xcassets", sub: .xcassets))

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "colors", sub: .xcassets)
  }

  func testAll() throws {
    let parser = AssetsCatalog.Parser()
    try parser.parse(paths: [
      Fixtures.path(for: "Images.xcassets", sub: .xcassets),
      Fixtures.path(for: "Colors.xcassets", sub: .xcassets)
    ])

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "all", sub: .xcassets)
  }
}
