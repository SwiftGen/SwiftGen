//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

class InterfaceBuilderMacOSTests: XCTestCase {
  func testEmpty() throws {
    let parser = try InterfaceBuilder.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .interfaceBuilderMacOS)
  }

  func testMessageStoryboard() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.path(for: "Message.storyboard", sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages", sub: .interfaceBuilderMacOS)
  }

  func testAnonymousStoryboard() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.path(for: "Anonymous.storyboard", sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous", sub: .interfaceBuilderMacOS)
  }

  func testAllStoryboards() throws {
    let parser = try InterfaceBuilder.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.directory(sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .interfaceBuilderMacOS)
  }

  // ensure we still have a test case for checking support of module placeholders
  func testConsistencyOfModules() throws {
    let fakeModuleName = "NotCurrentModule"

    let parser = try InterfaceBuilder.Parser()
    try parser.searchAndParse(path: Fixtures.directory(sub: .interfaceBuilderMacOS))

    XCTAssert(
      parser.storyboards.contains {
        $0.scenes.contains { $0.moduleIsPlaceholder && $0.module == fakeModuleName } &&
        $0.segues.contains { $0.moduleIsPlaceholder && $0.module == fakeModuleName }
      }
    )
  }
}
