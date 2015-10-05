//
//  StoryboardTests.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 01/08/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import XCTest

class ColorsTests: XCTestCase {

    func testListWithDefaults() {
        let enumBuilder = SwiftGenColorEnumBuilder()
        enumBuilder.addColorWithName("TextColor", value: "0x999999")
        enumBuilder.addColorWithName("ArticleTitle", value: "#996600")
        enumBuilder.addColorWithName("ArticleBackground", value: "#ffcc0099")
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("ListDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithDefaults() {
        let enumBuilder = SwiftGenColorEnumBuilder()
        try! enumBuilder.parseTextFile(fixturePath("colors.txt"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("FileDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }

}
