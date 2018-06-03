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

class InterfaceBuilderiOSTests: XCTestCase {
  func testEmpty() {
    let parser = InterfaceBuilder.Parser()

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "empty", sub: .interfaceBuilderiOS)
  }

  func testMessageStoryboard() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.path(for: "Message.storyboard", sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "messages", sub: .interfaceBuilderiOS)
  }

  func testAnonymousStoryboard() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.path(for: "Anonymous.storyboard", sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "anonymous", sub: .interfaceBuilderiOS)
  }

  func testAllStoryboards() {
    let parser = InterfaceBuilder.Parser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .interfaceBuilderiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext(testEnvironment: true)
    XCTDiffContexts(result, expected: "all", sub: .interfaceBuilderiOS)
  }
}
