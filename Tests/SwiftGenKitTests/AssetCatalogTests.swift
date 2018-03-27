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
    let parser = AssetsCatalogParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .xcassets)
  }

  func testImages() throws {
    let parser = AssetsCatalogParser()
    try parser.parse(path: Fixtures.path(for: "Images.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "images.plist", sub: .xcassets)
  }

  func testColors() throws {
    let parser = AssetsCatalogParser()
    try parser.parse(path: Fixtures.path(for: "Colors.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "colors.plist", sub: .xcassets)
  }

  func testAll() throws {
    let parser = AssetsCatalogParser()
    try parser.parse(paths: [
      Fixtures.path(for: "Images.xcassets", sub: .xcassets),
      Fixtures.path(for: "Colors.xcassets", sub: .xcassets)
    ])

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all.plist", sub: .xcassets)
  }
}
