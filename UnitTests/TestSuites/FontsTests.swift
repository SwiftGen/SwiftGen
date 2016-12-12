//
//  FontsTests.swift
//  SwiftGen
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import XCTest
@testable import GenumKit
import AppKit.NSFont

class FontsTests: XCTestCase {
  func testEmpty() {
    let parser = FontsFileParser()
    let template = GenumTemplate(templateString: Fixtures.string(for: "fonts-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.string(for: "Fonts-Dir-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testDefaults() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = GenumTemplate(templateString: Fixtures.string(for: "fonts-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.string(for: "Fonts-Dir-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testDefaultsWithSwift3() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = GenumTemplate(templateString: Fixtures.string(for: "fonts-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.string(for: "Fonts-Dir-Default-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testCustomName() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = GenumTemplate(templateString: Fixtures.string(for: "fonts-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
    let expected = Fixtures.string(for: "Fonts-Dir-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testCustomNameWithSwift3() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = GenumTemplate(templateString: Fixtures.string(for: "fonts-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
    let expected = Fixtures.string(for: "Fonts-Dir-CustomName-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}
