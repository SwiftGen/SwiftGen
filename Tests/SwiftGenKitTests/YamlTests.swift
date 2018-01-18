//
//  YamlTests.swift
//  SwiftGenKit UnitTests
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import PathKit
@testable import SwiftGenKit
import XCTest

class YamlTests: XCTestCase {
  func testEmpty() {
    let parser = Yaml.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .yaml)
  }

  func testSequence() throws {
    let parser = Yaml.Parser()
    try parser.parse(path: Fixtures.path(for: "sequence.yaml", sub: .yaml))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "sequence", sub: .yaml)
  }

  func testMapping() throws {
    let parser = Yaml.Parser()
    try parser.parse(path: Fixtures.path(for: "mapping.yaml", sub: .yaml))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "mapping", sub: .yaml)
  }

  func testJSON() throws {
    let parser = Yaml.Parser()
    try parser.parse(path: Fixtures.path(for: "json.json", sub: .yaml))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "json", sub: .yaml)
  }

  func testScalar() throws {
    let parser = Yaml.Parser()
    try parser.parse(path: Fixtures.path(for: "scalar.yaml", sub: .yaml))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "scalar", sub: .yaml)
  }

  func testDirectoryInput() {
    do {
      _ = try Yaml.Parser().parse(path: Fixtures.directory(sub: .yaml))
      XCTFail("Code did parse directory successfully while it was expected to fail requiring that the input be a file")
    } catch Yaml.ParserError.directory {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Yaml.Parser().parse(path: Fixtures.path(for: "bad-syntax.yaml", sub: .yaml))
      XCTFail("Code did parse file successfully while it was expected to fail for bad syntax")
    } catch Yaml.ParserError.invalidFile {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
