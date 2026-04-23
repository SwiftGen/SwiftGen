//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import XCTest
import SwiftGenKit
import PathKit

/**
 * Important: In order for the "*.storyboard" files in fixtures/ to be copied as-is in the test bundle
 * (as opposed to being compiled when the test bundle is compiled), a custom "Build Rule" has been added to the target.
 * See Project -> Target "UnitTests" -> Build Rules -> « Files "*.storyboard" using PBXCp »
 */

class IdentifiersiOSTests: XCTestCase {
  func testEmpty() {
    let parser = IdentifiersParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .identifiersiOS)
  }
  func testAll() {
    let parser = IdentifiersParser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .identifiersiOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all.plist", sub: .identifiersiOS)
  }
  func testStoryboards() {
    let parser = IdentifiersParser()
    do {
      let path = Fixtures.directory(sub: .identifiersiOS) + "Storyboards"
      try parser.parse(path: path)
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "storyboards.plist", sub: .identifiersiOS)
  }
  func testXibs() {
    let parser = IdentifiersParser()
    do {
      let path = Fixtures.directory(sub: .identifiersiOS) + "Xibs"
      try parser.parse(path: path)
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "xibs.plist", sub: .identifiersiOS)
  }
}
