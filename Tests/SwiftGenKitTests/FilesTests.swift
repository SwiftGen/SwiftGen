//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
@testable import SwiftGenKit
import XCTest

final class FilesTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Files.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .files)
  }

  func testDefaults() throws {
    let parser = try Files.Parser()
    try parser.searchAndParse(path: Fixtures.directory(sub: .files))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .files)
  }
}
