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
        enumBuilder.addEntry(SwiftGenL10nEnumBuilder.Entry(key: "Greetings", types: .Object, .Int))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("EntriesWithDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testLinesWithDefaults() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        if let e = SwiftGenL10nEnumBuilder.Entry(line: "\"AppTitle\"    =   \"My awesome title\"  ; // Yeah") {
            enumBuilder.addEntry(e)
        }
        if let e = SwiftGenL10nEnumBuilder.Entry(line: "\"GreetingsAndAge\"=\"My name is %@, I am %d\";/* hello */") {
            enumBuilder.addEntry(e)
        }
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("LinesWithDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testFileWithDefaults() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        try! enumBuilder.parseLocalizableStringsFile(fixturePath("Localizable.strings"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("FileWithDefaults.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithCustomName() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        try! enumBuilder.parseLocalizableStringsFile(fixturePath("Localizable.strings"))
        let result = enumBuilder.build(enumName: "XCTLoc")
        
        let expected = self.fixtureString("FileWithCustomName.swift.out")
        XCTDiffStrings(result, expected)
    }

    func testFileWithCustomIndentation() {
        let enumBuilder = SwiftGenL10nEnumBuilder()
        try! enumBuilder.parseLocalizableStringsFile(fixturePath("Localizable.strings"))
        let result = enumBuilder.build(indentation: .Spaces(3))
        
        let expected = self.fixtureString("FileWithCustomIndentation.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    
    
    
    func testParseStringPlaceholder() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%@")
        XCTAssertEqual(placeholders, [.Object])
    }
    
    func testParseFloatPlaceholder() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%f")
        XCTAssertEqual(placeholders, [.Float])
    }
    
    func testParseDoublePlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%g-%e")
        XCTAssertEqual(placeholders, [.Float, .Float])
    }
    
    func testParseFloatWithPrecisionPlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%1.2f : %.3f : %+3f : %-6.2f")
        XCTAssertEqual(placeholders, [.Float, .Float, .Float, .Float])
    }

    func testParseIntPlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%d-%i-%o-%u-%x")
        XCTAssertEqual(placeholders, [.Int, .Int, .Int, .Int, .Int])
    }

    func testParseCCharAndStringPlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%c-%s")
        XCTAssertEqual(placeholders, [.Char, .CString])
    }

    func testParsePositionalPlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%2$d-%4$f-%3$@-%c")
        XCTAssertEqual(placeholders, [.Char, .Int, .Object, .Float])
    }

    func testParseComplexFormatPlaceholders() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%2$1.3d - %4$-.7f - %3$@ - %% - %5$+3c - %%")
        // positions 2, 4, 3, 5 set to Int, Float, Object, Char, and position 1 not matched, defaulting to Unknown
        XCTAssertEqual(placeholders, [.Unknown, .Int, .Object, .Float, .Char])
    }

    func testParseEscapePercentSign() {
        let placeholders = SwiftGenL10nEnumBuilder.PlaceholderType.fromFormatString("%%foo")
        // Must NOT map to [.Float]
        XCTAssertEqual(placeholders, [])
    }

}
