//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import GenumKit

class SwiftIdentifierTests: XCTestCase {

  func testBasicString() {
    XCTAssertEqual(swiftIdentifier(from: "Hello"), "Hello")
  }

  func testBasicStringWithForbiddenChars() {
    XCTAssertEqual(swiftIdentifier(from: "Hello", forbiddenChars: "l"), "HeO")
  }

  func testBasicStringWithForbiddenCharsAndUnderscores() {
    XCTAssertEqual(swiftIdentifier(from: "Hello", forbiddenChars: "l", replaceWithUnderscores: true), "He__O")
  }

  func testSpecialChars() {
    XCTAssertEqual(swiftIdentifier(from: "This-is-42$hello@world"), "ThisIs42HelloWorld")
  }

  func testKeepUppercaseAcronyms() {
    XCTAssertEqual(swiftIdentifier(from: "some$URLDecoder"), "SomeURLDecoder")
  }

  func testEmojis() {
    XCTAssertEqual(swiftIdentifier(from: "some😎🎉emoji"), "Some😎🎉emoji")
  }

  func testEmojis2() {
    XCTAssertEqual(swiftIdentifier(from: "😎🎉"), "😎🎉")
  }

  func testNumbersFirst() {
    XCTAssertEqual(swiftIdentifier(from: "42hello"), "_42hello")
  }

  func testForbiddenChars() {
    XCTAssertEqual(swiftIdentifier(from: "hello$world^this*contains%a=lot@of<forbidden>chars!does#it/still:work.anyway?"),
      "HelloWorldThisContainsALotOfForbiddenCharsDoesItStillWorkAnyway")
  }
}
