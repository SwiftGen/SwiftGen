//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

class ColorsTests: XCTestCase {
  
  func testList() {
    let enumBuilder = ColorEnumBuilder()
    enumBuilder.addColorWithName("TextColor", value: "0x999999")
    enumBuilder.addColorWithName("ArticleTitle", value: "#996600")
    enumBuilder.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors.stencil"))
    let result = try! template.render(enumBuilder.stencilContext())
    
    let expected = self.fixtureString("Colors-List.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFile() {
    let enumBuilder = ColorEnumBuilder()
    try! enumBuilder.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors.stencil"))
    let result = try! template.render(enumBuilder.stencilContext())
    
    let expected = self.fixtureString("Colors-File.swift.out")
    XCTDiffStrings(result, expected)
  }
  
}
