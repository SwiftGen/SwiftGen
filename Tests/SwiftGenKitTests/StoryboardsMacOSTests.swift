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

class StoryboardsMacOSTests: XCTestCase {
  func testEmpty() {
    let parser = StoryboardParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .storyboardsMacOS)
  }

  func testMessageStoryboard() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.path(for: "Message.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages", sub: .storyboardsMacOS)
  }

  func testAnonymousStoryboard() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous", sub: .storyboardsMacOS)
  }

  func testAllStoryboards() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .storyboardsMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all", sub: .storyboardsMacOS)
  }
}
