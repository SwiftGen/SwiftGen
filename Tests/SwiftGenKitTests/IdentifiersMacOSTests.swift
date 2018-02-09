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

class IdentifiersMacOSTests: XCTestCase {
  func testEmpty() {
    let parser = IdentifiersParser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty.plist", sub: .identifiersMacOS)
  }
  func testAll() {
    let parser = IdentifiersParser()
    do {
      try parser.parse(path: Fixtures.directory(sub: .identifiersMacOS))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "all.plist", sub: .identifiersMacOS)
  }
  func testStoryboards() {
    let parser = IdentifiersParser()
    do {
      let path = Fixtures.directory(sub: .identifiersMacOS) + "Storyboards"
      try parser.parse(path: path)
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "storyboards.plist", sub: .identifiersMacOS)
  }
  func testXibs() {
    let parser = IdentifiersParser()
    do {
      let path = Fixtures.directory(sub: .identifiersMacOS) + "Xibs"
      try parser.parse(path: path)
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "xibs.plist", sub: .identifiersMacOS)
  }
}
