//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class YamlTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Yaml.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .yaml)
  }

  func testSequence() throws {
    let parser = try Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "grocery-list.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "grocery-list", sub: .yaml)
  }

  func testMapping() throws {
    let parser = try Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "mapping.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "mapping", sub: .yaml)
  }

  func testJSON() throws {
    let parser = try JSON.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "configuration.json", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "configuration", sub: .yaml)
  }

  func testScalar() throws {
    let parser = try Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "version.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "version", sub: .yaml)
  }

  func testMutlipleDocuments() throws {
    let parser = try Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "documents.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "documents", sub: .yaml)
  }

  func testDirectoryInput() {
    do {
      let parser = try Yaml.Parser()
      let filter = try Filter(pattern: "[^/]*\\.(json|ya?ml)$")
      try parser.searchAndParse(path: Fixtures.directory(sub: .yamlGood), filter: filter)

      let result = parser.stencilContext()
      XCTDiffContexts(result, expected: "all", sub: .yaml)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Yaml.Parser().searchAndParse(path: Fixtures.path(for: "syntax.yaml", sub: .yamlBad))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Yaml.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
