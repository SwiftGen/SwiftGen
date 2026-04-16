//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import TestUtils
import XCTest
import Yams

class StringsCatalogTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Strings.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .strings)
  }

  func testLocalizable() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "Localizable.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "localizable", sub: .stringsCatalog)
  }

  func testMultiline() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "LocMultiline.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiline", sub: .stringsCatalog)
  }

  func testUTF8File() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "LocUTF8.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "utf8", sub: .stringsCatalog)
  }

  func testStructuredOnly() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "LocStructuredOnly.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "structuredonly", sub: .stringsCatalog)
  }

  func testMultipleFiles() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "Localizable.xcstrings", sub: .strings))
    try parser.searchAndParse(path: Fixtures.resource(for: "LocMultiline.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "multiple", sub: .stringsCatalog)
  }

  func testPlurals() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "LocalizableDict.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals", sub: .stringsCatalog)
  }

  func testAdvancedPlurals() throws {
    let parser = try Strings.Parser()
    try parser.searchAndParse(path: Fixtures.resource(for: "LocPluralAdvanced.xcstrings", sub: .strings))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "plurals-advanced", sub: .stringsCatalog)
  }
}
