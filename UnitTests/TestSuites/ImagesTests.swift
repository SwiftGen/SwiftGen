//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

/**
 * Important: In order for the "*.xcassets" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.xccassets" using PBXCp »
 */

class ImagesTests: XCTestCase {

  func testEmpty() {
    let parser = AssetsCatalogParser()

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithSwift3() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-File-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithAllValuesTemplate() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-allvalues.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-File-AllValues.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext(enumName: "XCTImages"))

    let expected = Fixtures.string(for: "Images-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntax() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-dot-syntax.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-File-Dot-Syntax.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntaxSwift3() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: Fixtures.path(for: "Images.xcassets"))

    let template = GenumTemplate(templateString: Fixtures.string(for: "images-dot-syntax-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Images-File-Dot-Syntax-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}
