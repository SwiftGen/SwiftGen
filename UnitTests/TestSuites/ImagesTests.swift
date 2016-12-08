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

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testEntriesWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.addImage(named: "Green-Apple")
    parser.addImage(named: "Red apple")
    parser.addImage(named: "2-pears")

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-Entries-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithSwift3() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-File-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithAllValuesTemplate() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-allvalues.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-File-AllValues.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context(enumName: "XCTImages"))

    let expected = fixtureString("Images-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntax() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-dot-syntax.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-File-Dot-Syntax.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDotSyntaxSwift3() {
    let parser = AssetsCatalogParser()
    parser.parseCatalog(at: fixture("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-dot-syntax-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.context())

    let expected = fixtureString("Images-File-Dot-Syntax-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}
