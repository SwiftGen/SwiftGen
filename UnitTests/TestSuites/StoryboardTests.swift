//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import GenumKit

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

class StoryboardTests: XCTestCase {
    
    func testMessageWithDefaults() {
        let enumBuilder = StoryboardEnumBuilder()
        enumBuilder.addStoryboardAtPath(self.fixturePath("Message.storyboard"))
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Storyboards-Message-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testAllWithDefaults() {
        let enumBuilder = StoryboardEnumBuilder()
        enumBuilder.parseDirectory(self.fixturesDir)
        let result = enumBuilder.build()
        
        let expected = self.fixtureString("Storyboards-All-Defaults.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testMessageWithCustomNames() {
        let enumBuilder = StoryboardEnumBuilder()
        enumBuilder.addStoryboardAtPath(self.fixturePath("Message.storyboard"))
        let result = enumBuilder.build(scenesStructName: "XCTAllScenes", seguesStructName: "XCTAllSegues")
        
        let expected = self.fixtureString("Storyboards-Message-CustomNames.swift.out")
        XCTDiffStrings(result, expected)
    }
    
    func testMessageWithCustomIndentation() {
        let enumBuilder = StoryboardEnumBuilder()
        enumBuilder.addStoryboardAtPath(self.fixturePath("Message.storyboard"))
        let result = enumBuilder.build(indentation: .Spaces(3))
        
        let expected = self.fixtureString("Storyboards-Message-CustomIndentation.swift.out")
        XCTDiffStrings(result, expected)
    }
}
