//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

class ColorsTests: XCTestCase {
  
  func testListWithDefaults() {
    let enumBuilder = ColorEnumBuilder()
    enumBuilder.addColorWithName("TextColor", value: "0x999999")
    enumBuilder.addColorWithName("ArticleTitle", value: "#996600")
    enumBuilder.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors.stencil"))
    let result = try! template.render(enumBuilder.stencilContext())
    
    let expected = self.fixtureString("Colors-List-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithDefaults() {
    let enumBuilder = ColorEnumBuilder()
    try! enumBuilder.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors.stencil"))
    let result = try! template.render(enumBuilder.stencilContext())
    
    let expected = self.fixtureString("Colors-File-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithCustomName() {
    let enumBuilder = ColorEnumBuilder()
    try! enumBuilder.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors.stencil"))
    let result = try! template.render(enumBuilder.stencilContext(enumName: "XCTColors"))
    
    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}
