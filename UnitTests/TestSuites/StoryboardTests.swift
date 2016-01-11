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

  func testEmpty() {
    let parser = StoryboardParser()

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message.storyboard"))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Message-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message.storyboard"))

    let template = GenumTemplate(templateString: fixtureString("storyboards-lowercase.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Message-Lowercase.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Anonymous.storyboard"))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Anonymous-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    parser.parseDirectory(self.fixturesDir)

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = self.fixtureString("Storyboards-All-Defaults.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    parser.parseDirectory(self.fixturesDir)

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let ctx = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene", segueEnumName: "XCTStoryboardsSegue")
    let result = try! template.render(ctx)

    let expected = self.fixtureString("Storyboards-All-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }
}
