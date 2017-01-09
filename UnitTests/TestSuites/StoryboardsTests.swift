//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import StencilSwiftKit
import SwiftGenKit

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

enum StoryboardsDir {
  static let iOS = "fixtures/Storyboards-iOS"
  static let macOS = "fixtures/Storyboards-OSX"
}

// MARK: iOS StoryboardTests

class StoryboardsiOSTests: XCTestCase {

  func testEmpty() {
    let parser = StoryboardParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Message-Default.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-lowercase.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Message-Lowercase.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Anonymous-Default.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-default.stencil"), environment: stencilSwiftEnvironment())
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = Fixtures.output(for: "All-Default.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testAllStoryboardsWithCustomName() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-default.stencil"), environment: stencilSwiftEnvironment())
    let ctx = parser.stencilContext(sceneEnumName: "XCTStoryboardsScene", segueEnumName: "XCTStoryboardsSegue")
    let result = try! template.render(ctx)

    let expected = Fixtures.output(for: "All-CustomName.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testAnonymousStoryboardWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Anonymous-Swift3.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testWizardsStoryboardsWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Wizard.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Wizard-Swift3.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }

  func testAdditionalImport() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "AdditionalImport-Swift3.swift.out", sub: .storyboardsiOS)
    XCTDiffStrings(result, expected)
  }
}

// MARK: OS X StoryboardTests

class StoryboardsOSXTests: XCTestCase {

  func testOSXEmpty() {
    let parser = StoryboardParser()

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Empty.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Message-Default.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }

  func testOSXMessageStoryboardWithLowercaseTemplate() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-lowercase.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Message-Lowercase.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }
  
  func testOSXMessageStoryboardWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Message.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    
    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    
    let expected = Fixtures.output(for: "Message-Swift3.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }

  func testOSXAnonymousStoryboardWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "Anonymous-Default.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }

  func testOSXAllStoryboardsWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.parseDirectory(at: Fixtures.directory(sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-default.stencil"), environment: stencilSwiftEnvironment())
    let ctx = parser.stencilContext()
    let result = try! template.render(ctx)

    let expected = Fixtures.output(for: "All-Default.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }

  func testAdditionalImportWithDefaults() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-default.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())

    let expected = Fixtures.output(for: "AdditionalImport-Default.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }
  
  func testAdditionalImportWithSwift3() {
    let parser = StoryboardParser()
    do {
      try parser.addStoryboard(at: Fixtures.path(for: "AdditionalImport.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let template = SwiftTemplate(templateString: Fixtures.template(for: "storyboards-osx-swift3.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(parser.stencilContext())
    
    let expected = Fixtures.output(for: "AdditionalImport-Swift3.swift.out", sub: .storyboardsMacOS)
    XCTDiffStrings(result, expected)
  }
}
