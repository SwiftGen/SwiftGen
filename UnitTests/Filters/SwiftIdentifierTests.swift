//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import GenumKit

class SwiftIdentifierTests: XCTestCase {

  func testBasicString() {
    XCTAssertEqual(swiftIdentifier(fromString: "Hello"), "Hello")
  }

  func testBasicStringWithForbiddenChars() {
    XCTAssertEqual(swiftIdentifier(fromString: "Hello", forbiddenChars: "l"), "HeO")
  }

  func testBasicStringWithForbiddenCharsAndUnderscores() {
    XCTAssertEqual(swiftIdentifier(fromString: "Hello", forbiddenChars: "l", replaceWithUnderscores: true), "He__O")
  }

  func testSpecialChars() {
    XCTAssertEqual(swiftIdentifier(fromString: "This-is-42$hello@world"), "ThisIs42HelloWorld")
  }

  func testKeepUppercaseAcronyms() {
    XCTAssertEqual(swiftIdentifier(fromString: "some$URLDecoder"), "SomeURLDecoder")
  }

  func testEmojis() {
    XCTAssertEqual(swiftIdentifier(fromString: "some😎🎉emoji"), "Some😎🎉emoji")
  }

  func testEmojis2() {
    XCTAssertEqual(swiftIdentifier(fromString: "😎🎉"), "😎🎉")
  }

  func testNumbersFirst() {
    XCTAssertEqual(swiftIdentifier(fromString: "42hello"), "_42hello")
  }

  func testForbiddenChars() {
    XCTAssertEqual(swiftIdentifier(fromString: "hello$world^this*contains%a=lot@of<forbidden>chars!does#it/still:work.anyway?"),
      "HelloWorldThisContainsALotOfForbiddenCharsDoesItStillWorkAnyway")
  }
}
