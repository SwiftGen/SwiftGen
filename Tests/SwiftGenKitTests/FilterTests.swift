//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

final class FilterTests: XCTestCase {
  func testBasicRegex() throws {
    let filter = try Filter(pattern: ".+\\.strings$")

    XCTAssertTrue(Path("foo.strings").matches(filter: filter))
    XCTAssertTrue(Path("Bar.strings").matches(filter: filter))
    XCTAssertTrue(Path("A/B/C/baz.strings").matches(filter: filter))

    XCTAssertFalse(Path("foo.Strings").matches(filter: filter))
    XCTAssertFalse(Path("foo.stringsdict").matches(filter: filter))
  }

  func testCaseSensitive() throws {
    let filter = try Filter(pattern: ".+\\.strings$")

    XCTAssertTrue(Path("foo.strings").matches(filter: filter))
    XCTAssertTrue(Path("Bar.strings").matches(filter: filter))
    XCTAssertFalse(Path("foo.Strings").matches(filter: filter))
    XCTAssertFalse(Path("Bar.STRINGS").matches(filter: filter))
  }

  func testCaseInsensitive() throws {
    let filter = try Filter(pattern: ".+\\.(?i:json)$")

    XCTAssertTrue(Path("foo.json").matches(filter: filter))
    XCTAssertTrue(Path("foo.Json").matches(filter: filter))
    XCTAssertTrue(Path("foo.JSON").matches(filter: filter))
  }

  func testComplex() throws {
    // match json files with the filename beginning with "SG"
    let filter = try Filter(pattern: "^(.+/)?SG[^/]*\\.json$")

    XCTAssertTrue(Path("foo/bar/SGBaz.json").matches(filter: filter))
    XCTAssertTrue(Path("SGQux.json").matches(filter: filter))
    XCTAssertFalse(Path("foo/bar/SG/qux.json").matches(filter: filter))
    XCTAssertFalse(Path("foo/bar/bazSGqux.json").matches(filter: filter))
  }
}
