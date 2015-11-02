//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

class ColorsTests: XCTestCase {
  
  func testEmpty() {
    let parser = ColorsFileParser()
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testListWithDefaults() {
    let parser = ColorsFileParser()
    parser.addColorWithName("TextColor", value: "0x999999")
    parser.addColorWithName("ArticleTitle", value: "#996600")
    parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-List-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testListWithRawValueTemplate() {
    let parser = ColorsFileParser()
    parser.addColorWithName("TextColor", value: "0x999999")
    parser.addColorWithName("ArticleTitle", value: "#996600")
    parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors-rawValue.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-List-RawValue.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithDefaults() {
    let parser = ColorsFileParser()
    try! parser.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-File-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithCustomName() {
    let parser = ColorsFileParser()
    try! parser.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))
    
    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}
