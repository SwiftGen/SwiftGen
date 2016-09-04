//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit

/**
 * Important: In order for the "*.xcassets" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.xccassets" using PBXCp »
 */

class ImagesTests: XCTestCase {

  func testEmpty() {
    let parser = AssetsCatalogParser()

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Images-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testEntriesWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.addImageName("Green-Apple")
    parser.addImageName("Red apple")
    parser.addImageName("2-pears")

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Images-Entries-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithDefaults() {
    let parser = AssetsCatalogParser()
    parser.parseDirectory(fixturePath("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Images-File-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithSwift3() {
    let parser = AssetsCatalogParser()
    parser.parseDirectory(fixturePath("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Images-File-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithAllValuesTemplate() {
    let parser = AssetsCatalogParser()
    parser.parseDirectory(fixturePath("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-allvalues.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Images-File-AllValues.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testFileWithCustomName() {
    let parser = AssetsCatalogParser()
    parser.parseDirectory(fixturePath("Images.xcassets"))

    let template = GenumTemplate(templateString: fixtureString("images-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTImages"))

    let expected = self.fixtureString("Images-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}
