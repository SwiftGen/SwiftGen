//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

final class AssetCatalogTests: XCTestCase {
  func testEmpty() throws {
    let parser = try AssetsCatalog.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .xcassets)
  }

  func testARResourceGroups() throws {
    let parser = try AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Targets.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "targets", sub: .xcassets)
  }

  func testColors() throws {
    let parser = try AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Styles.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "styles", sub: .xcassets)
  }

  func testData() throws {
    let parser = try AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Files.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "files", sub: .xcassets)
  }

  func testImages() throws {
    let parser = try AssetsCatalog.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "Food.xcassets", sub: .xcassets))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "food", sub: .xcassets)
  }

  func testAll() throws {
    let parser = try AssetsCatalog.Parser()
    let paths = ["Files.xcassets", "Food.xcassets", "Styles.xcassets", "Targets.xcassets", "Other.xcassets"]
    try parser.searchAndParse(paths: paths.map { Fixtures.path(for: $0, sub: .xcassets) })

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .xcassets)
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try AssetsCatalog.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
