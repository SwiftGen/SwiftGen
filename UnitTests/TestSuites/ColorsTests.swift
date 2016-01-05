//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit
import PathKit

class ColorsTextFileTests: XCTestCase {
  
  func testEmpty() {
    let parser = ColorsTextFileParser()
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testListWithDefaults() {
    let parser = ColorsTextFileParser()
    parser.addColorWithName("Text&Body Color", value: "0x999999")
    parser.addColorWithName("ArticleTitle", value: "#996600")
    parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-List-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testListWithRawValueTemplate() {
    let parser = ColorsTextFileParser()
    parser.addColorWithName("Text&Body Color", value: "0x999999")
    parser.addColorWithName("ArticleTitle", value: "#996600")
    parser.addColorWithName("ArticleBackground", value: "#ffcc0099")
    
    let template = GenumTemplate(templateString: fixtureString("colors-rawValue.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-List-RawValue.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithDefaults() {
    let parser = ColorsTextFileParser()
    try! parser.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-File-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithCustomName() {
    let parser = ColorsTextFileParser()
    try! parser.parseTextFile(fixturePath("colors.txt"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))
    
    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}

class ColorsCLRFileTests: XCTestCase {
  
  func testEmpty() {
    let parser = CLRFileParser()
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithDefaults() {
    let parser = CLRFileParser()
    parser.parseFile(fixturePath("colors.clr"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Colors-File-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testFileWithCustomName() {
    let parser = CLRFileParser()
    parser.parseFile(fixturePath("colors.clr"))
    
    let template = GenumTemplate(templateString: fixtureString("colors-default.stencil"))
    let result = try! template.render(parser.stencilContext(enumName: "XCTColors"))
    
    let expected = self.fixtureString("Colors-File-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}

