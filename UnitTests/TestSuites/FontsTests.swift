//
//  FontsTests.swift
//  SwiftGen
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import XCTest
import StencilSwiftKit
import SwiftGenKit
import AppKit.NSFont

class FontsTests: XCTestCase {
  func testEmpty() {
    let parser = FontsFileParser()
    let template = SwiftTemplate(templateString: Fixtures.template(for: "fonts-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.output(for: "Dir-Empty.swift.out", sub: .fonts)
    XCTDiffStrings(result, expected)
  }

  func testDefaults() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "fonts-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.output(for: "Dir-Default.swift.out", sub: .fonts)
    XCTDiffStrings(result, expected)
  }

  func testDefaultsWithSwift3() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory(sub: .fonts))

    let template = SwiftTemplate(templateString: Fixtures.template(for: "fonts-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    let expected = Fixtures.output(for: "Dir-Default-Swift3.swift.out", sub: .fonts)
    XCTDiffStrings(result, expected)
  }

  func testCustomName() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = SwiftTemplate(templateString: Fixtures.template(for: "fonts-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
    let expected = Fixtures.output(for: "Dir-CustomName.swift.out", sub: .fonts)
    XCTDiffStrings(result, expected)
  }

  func testCustomNameWithSwift3() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let template = SwiftTemplate(templateString: Fixtures.template(for: "fonts-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
    let expected = Fixtures.output(for: "Dir-CustomName-Swift3.swift.out", sub: .fonts)
    XCTDiffStrings(result, expected)
  }
}
