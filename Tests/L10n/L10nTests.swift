//
//  StoryboardTests.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 01/08/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import XCTest

class L10nTests: XCTestCase {

    func testEntriesWithDefaults() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        enumBuilder.addEntry(SwiftGenL10nEnumBuilder.Entry(key: "Title"))
        enumBuilder.addEntry(SwiftGenL10nEnumBuilder.Entry(key: "Greetings", types: .String, .Int))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("EntriesWithDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithDefaults() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        try! enumBuilder.parseLocalizableStringsFile(fixturePath("Localizable.strings"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("FileWithDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }
}
