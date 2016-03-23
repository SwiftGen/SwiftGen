//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit


class NibssTests: XCTestCase {
  
  func testFileWithDefaults() {
    let parser = XibParser()
    parser.parseDirectory(fixturesDir)
    
    let template = GenumTemplate(templateString: fixtureString("nibs-default.stencil"))
    let result = try! template.render(parser.stencilContext())
    
    let expected = self.fixtureString("Nibs.swift.out")
    XCTDiffStrings(result, expected)
  }
  
}
