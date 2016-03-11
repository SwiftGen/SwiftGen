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
        parser.addVariation("Helvetica", variation:"Regular")
        parser.addVariation("Helvetica", variation:"Bold")
        parser.addVariation("Helvetica", variation:"Thin")
        parser.addVariation("Helvetica", variation:"Medium")

        parser.addVariation("HelveticaNeue", variation:"Regular")
        parser.addVariation("HelveticaNeue", variation:"Bold")
        parser.addVariation("HelveticaNeue", variation:"Thin")
        parser.addVariation("HelveticaNeue", variation:"Medium")

        let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
        let result = try! template.render(parser.stencilContext())
        let expected = fixtureString("Fonts-File-Default.swift.out")
        XCTDiffStrings(result, expected)

    }

    func testCustomName() {
        let parser = FontsFileParser()
        parser.addVariation("Helvetica", variation:"Regular")
        parser.addVariation("Helvetica", variation:"Bold")
        parser.addVariation("Helvetica", variation:"Thin")
        parser.addVariation("Helvetica", variation:"Medium")

        parser.addVariation("HelveticaNeue", variation:"Regular")
        parser.addVariation("HelveticaNeue", variation:"Bold")
        parser.addVariation("HelveticaNeue", variation:"Thin")
        parser.addVariation("HelveticaNeue", variation:"Medium")

        let template = GenumTemplate(templateString: fixtureString("fonts-default.stencil"))
        let result = try! template.render(parser.stencilContext(enumName: "AnotherFamily"))
        let expected = fixtureString("Fonts-File-CustomName.swift.out")
        XCTDiffStrings(result, expected)
    }
}
