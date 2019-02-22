//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
import SwiftGenKit
import XCTest

class AssetCatalogTests: XCTestCase {
  func testEmpty() {
    let parser = AssetsCatalog.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .xcassets)
  }

  func testImages() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Images.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "images", sub: .xcassets)
  }

  func testData() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Data.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "data", sub: .xcassets)
  }

  func testColors() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Colors.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "colors", sub: .xcassets)
  }

  func testAll() throws {
    let parser = AssetsCatalog.Parser()
    let paths = ["Images.xcassets", "Colors.xcassets", "Data.xcassets"]
    try parser.searchAndParse(paths: paths.map { Fixtures.path(for: $0, sub: .xcassets) })

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .xcassets)
  }
}
