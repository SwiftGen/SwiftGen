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

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Message-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-lowercase.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Message-Lowercase.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Anonymous-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-default.stencil"), environment: genumEnvironment())
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = Fixtures.string(for: "Storyboards-All-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-default.stencil"), environment: genumEnvironment())
    let ctx = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene", segueEnumName: "XCTStoryboardsSegue")
    let result = try! template.render(ctx)

    let expected = Fixtures.string(for: "Storyboards-All-CustomName.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Anonymous-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testWizardsStoryboardsWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Wizard.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-Wizard-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAdditionalImport() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport.storyboard", subDirectory: StoryboardsDir.iOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    // additional import statements
    let extraImports = [
      "LocationPicker",
      "SlackTextViewController"
    ]

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-swift3.stencil"), environment: genumEnvironment())
    let context = parser.stencilContext(sceneEnumName: "StoryboardScene", segueEnumName: "StoryboardSegue", extraImports: extraImports)
    let result = try! template.render(context)

    let expected = Fixtures.string(for: "Storyboards-AdditionalImport-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}

// MARK: OS X StoryboardTests

class StoryboardsOSXTests: XCTestCase {

  func testOSXEmpty() {
    let parser = StoryboardParser()

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-osx-Empty.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-osx-Message-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-lowercase.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-osx-Message-Lowercase.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testOSXMessageStoryboardWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    
    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-swift3.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())
    
    let expected = Fixtures.string(for: "Storyboards-osx-Message-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-default.stencil"), environment: genumEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.string(for: "Storyboards-osx-Anonymous-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testOSXAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-default.stencil"), environment: genumEnvironment())
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = Fixtures.string(for: "Storyboards-osx-All-Default.swift.out")
    XCTDiffStrings(result, expected)
  }

  func testAdditionalImportWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    // additional import statements
    let extraImports = [
      "DBPrefsWindowController"
    ]

    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-default.stencil"), environment: genumEnvironment())
    let context = parser.stencilContext(sceneEnumName: "StoryboardScene", segueEnumName: "StoryboardSegue", extraImports: extraImports)
    let result = try! template.render(context)

    let expected = Fixtures.string(for: "Storyboards-osx-AdditionalImport-Default.swift.out")
    XCTDiffStrings(result, expected)
  }
  
  func testAdditionalImportWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport-osx.storyboard", subDirectory: StoryboardsDir.macOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    
    // additional import statements
    let extraImports = [
      "DBPrefsWindowController"
    ]
    
    let template = GenumTemplate(templateString: Fixtures.string(for: "storyboards-osx-swift3.stencil"), environment: genumEnvironment())
    let context = parser.stencilContext(sceneEnumName: "StoryboardScene", segueEnumName: "StoryboardSegue", extraImports: extraImports)
    let result = try! template.render(context)
    
    let expected = Fixtures.string(for: "Storyboards-osx-AdditionalImport-Swift3.swift.out")
    XCTDiffStrings(result, expected)
  }
}
