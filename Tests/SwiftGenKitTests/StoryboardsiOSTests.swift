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

class StoryboardsiOSTests: XCTestCase {

  func testEmpty() {
    let parser = StoryboardParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .storyboardsiOS)
  }

  func testMessageStoryboard() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.path(for: "Message.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "messages.plist", sub: .storyboardsiOS)
  }

  func testAnonymousStoryboard() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.path(for: "Anonymous.storyboard", sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "anonymous.plist", sub: .storyboardsiOS)
  }

  func testAllStoryboards() {
    let parser = StoryboardParser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .storyboardsiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all.plist", sub: .storyboardsiOS)
  }
}
