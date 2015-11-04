//
// SwiftGen
// Copyright (c) 2015 Josep Rodriguez
// MIT Licence
//


import XCTest
import GenumKit

class FontsTests: XCTestCase {
	
	func testEmpty() {
		let parser = FontFileParser()
		
		let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
		let result = try! template.render(parser.stencilContext())
		
		let expected = self.fixtureString("Fonts-Empty.swift.out")
		XCTDiffStrings(result, expected)
	}
	
	func testListWithDefaults() {
		let parser = FontFileParser()
		parser.addFontWithName("Header1", value: (fontName:"Helvetica", fontSize:18))
		parser.addFontWithName("Header2", value: (fontName:"Helvetica", fontSize:16))
		parser.addFontWithName("Body", value: (fontName:"Helvetica", fontSize:12))
		
		let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
		let result = try! template.render(parser.stencilContext())
		
		let expected = self.fixtureString("Fonts-List.swift.out")
		XCTDiffStrings(result, expected)
	}
	
	func testFileWithDefaults() {
		let parser = FontFileParser()
		try! parser.parseTextFile(fixturePath("fonts.plist"))
		
		let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
		let result = try! template.render(parser.stencilContext())
		
		let expected = self.fixtureString("Fonts-List.swift.out")
		XCTDiffStrings(result, expected)
	}
}
