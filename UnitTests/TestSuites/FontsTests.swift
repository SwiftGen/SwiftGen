//
//  FontsTests.swift
//  SwiftGen
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import XCTest
@testable import GenumKit
import AppKit.NSFont

class FontsTests: XCTestCase {
    func testEmpty() {
        let parser = FontsFileParser()
        let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
        let result = try! template.render(parser.stencilContext())
        let expected = fixtureString("Fonts-File-Empty.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testDefaults() {
        let parser = FontsFileParser()
        parser.parseFonts(directoryPath())

        let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
        let result = try! template.render(parser.stencilContext())
        let expected = fixtureString("Fonts-File-Default.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testCustomName() {
        let parser = FontsFileParser()
        parser.parseFonts(directoryPath())

        let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
        let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
        let expected = fixtureString("Fonts-File-CustomName.swift.out")
        XCTDiffStrings(result, expected)
    }
}

// MARK: OSX FontsTests

extension FontsTests {
    func testOSXEmpty() {
        let parser = FontsFileParser()
        let template = GenumTemplate(templateString: fixtureString("fonts-osx-default.stencil"))
        let result = try! template.render(parser.stencilContext())
        let expected = fixtureString("Fonts-osx-File-Empty.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testOSXDefaults() {
        let parser = FontsFileParser()
        parser.parseFonts(directoryPath())
        
        let template = GenumTemplate(templateString: fixtureString("fonts-osx-default.stencil"))
        let result = try! template.render(parser.stencilContext())
        let expected = fixtureString("Fonts-osx-File-Default.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testOSXCustomName() {
        let parser = FontsFileParser()
        parser.parseFonts(directoryPath())
        
        let template = GenumTemplate(templateString: fixtureString("fonts-osx-default.stencil"))
        let result = try! template.render(parser.stencilContext(enumName: "CustomFamily"))
        let expected = fixtureString("Fonts-osx-File-CustomName.swift.out")
        XCTDiffStrings(result, expected)
    }
}
