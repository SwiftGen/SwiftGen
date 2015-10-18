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
    
    let template = GenumTemplate(templateString: fixtureString("storyboards.stencil"))
    let result = try! template.render(enumBuilder.stencilContext())
    
    let expected = self.fixtureString("Storyboards-Message.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testAllWithDefaults() {
    let enumBuilder = StoryboardEnumBuilder()
    enumBuilder.parseDirectory(self.fixturesDir)
    
    let template = GenumTemplate(templateString: fixtureString("storyboards.stencil"))
    let ctx = enumBuilder.stencilContext()
    let result = try! template.render(ctx)
    
    let expected = self.fixtureString("Storyboards-All.swift.out")
    XCTDiffStrings(result, expected)
  }

}
