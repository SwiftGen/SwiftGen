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

  func testColors() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Styles.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "styles", sub: .xcassets)
  }

  func testData() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Files.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "files", sub: .xcassets)
  }

  func testImages() throws {
    let parser = AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Food.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "food", sub: .xcassets)
  }

  func testAll() throws {
    let parser = AssetsCatalog.Parser()
    let paths = ["Files.xcassets", "Food.xcassets", "Styles.xcassets"]
    try parser.searchAndParse(paths: paths.map { Fixtures.path(for: $0, sub: .xcassets) })

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .xcassets)
  }
}
