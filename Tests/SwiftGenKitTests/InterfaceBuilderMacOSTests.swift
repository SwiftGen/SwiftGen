//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import SwiftGenKit
import XCTest

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

class InterfaceBuilderMacOSTests: XCTestCase {
  func testEmpty() {
    let parser = InterfaceBuilder.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .interfaceBuilderMacOS)
  }

  func testMessageStoryboard() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.path(for: "Message.storyboard", sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages", sub: .interfaceBuilderMacOS)
  }

  func testAnonymousStoryboard() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.path(for: "Anonymous.storyboard", sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous", sub: .interfaceBuilderMacOS)
  }

  func testAllStoryboards() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .interfaceBuilderMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .interfaceBuilderMacOS)
  }
}
