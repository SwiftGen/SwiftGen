//
//  ColorsTests.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 01/08/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import XCTest
import GenumKit

class ColorsTests: XCTestCase {

    func testListWithDefaults() {
        let enumBuilder = ColorEnumBuilder()
        enumBuilder.addColorWithName("TextColor", value: "0x999999")
        enumBuilder.addColorWithName("ArticleTitle", value: "#996600")
        enumBuilder.addColorWithName("ArticleBackground", value: "#ffcc0099")
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Colors-List-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithDefaults() {
        let enumBuilder = ColorEnumBuilder()
        try! enumBuilder.parseTextFile(fixturePath("colors.txt"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Colors-File-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }

}
