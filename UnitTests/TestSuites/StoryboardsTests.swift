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

enum StoryboardsDir {
  static let iOS = "Storyboards-iOS"
  static let macOS = "Storyboards-OSX"
}

// MARK: iOS StoryboardTests

class StoryboardsiOSTests: XCTestCase {

  func testEmpty() {
    let parser = StoryboardParser()

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message.storyboard", subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Message-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message.storyboard", subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-lowercase.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Message-Lowercase.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Anonymous.storyboard", subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Anonymous-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    parser.parseDirectory(self.fixturesDir(subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = self.fixtureString("Storyboards-All-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    parser.parseDirectory(self.fixturesDir(subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-default.stencil"))
    let ctx = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene", segueEnumName: "XCTStoryboardsSegue")
    let result = try! template.render(ctx)

    let expected = self.fixtureString("Storyboards-All-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithSwift3() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Anonymous.storyboard", subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Anonymous-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testWizardsStoryboardsWithSwift3() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Wizard.storyboard", subDirectory: StoryboardsDir.iOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-swift3.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-Wizard-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}

// MARK: OS X StoryboardTests

class StoryboardsOSXTests: XCTestCase {

  func testOSXEmpty() {
    let parser = StoryboardParser()

    let template = GenumTemplate(templateString: fixtureString("storyboards-osx-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-osx-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-osx-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-osx-Message-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-osx-lowercase.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-osx-Message-Lowercase.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    parser.addStoryboardAtPath(self.fixturePath("Anonymous-osx.storyboard", subDirectory: StoryboardsDir.macOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-osx-default.stencil"))
    let result = try! template.render(parser.stencilContext())

    let expected = self.fixtureString("Storyboards-osx-Anonymous-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    parser.parseDirectory(self.fixturesDir(subDirectory: StoryboardsDir.macOS))

    let template = GenumTemplate(templateString: fixtureString("storyboards-osx-default.stencil"))
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = self.fixtureString("Storyboards-osx-All-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

}
