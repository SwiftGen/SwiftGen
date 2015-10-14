//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest

class SwiftIdentifierTests: XCTestCase {

    func testBasicString() {
        XCTAssertEqual("Hello".asSwiftIdentifier(), "Hello")
    }

    func testBasicStringWithForbiddenChars() {
        XCTAssertEqual("Hello".asSwiftIdentifier(forbiddenChars: "l"), "HeO")
    }

    func testBasicStringWithForbiddenCharsAndUnderscores() {
        XCTAssertEqual("Hello".asSwiftIdentifier(forbiddenChars: "l", replaceWithUnderscores: true), "He__O")
    }
    
    func testSpecialChars() {
        XCTAssertEqual("This-is-42$hello@world".asSwiftIdentifier(), "ThisIs42HelloWorld")
    }

    func testKeepUppercaseAcronyms() {
        XCTAssertEqual("some$URLDecoder".asSwiftIdentifier(), "SomeURLDecoder")
    }
    
    func testEmojis() {
        XCTAssertEqual("some😎🎉emoji".asSwiftIdentifier(), "Some😎🎉emoji")
    }

    func testEmojis2() {
        XCTAssertEqual("😎🎉".asSwiftIdentifier(), "😎🎉")
    }
    
    func testNumbersFirst() {
        XCTAssertEqual("42hello".asSwiftIdentifier(), "_42hello")
    }
    
    func testForbiddenChars() {
        XCTAssertEqual("hello$world^this*contains%a=lot@of<forbidden>chars!does#it/still:work.anyway?".asSwiftIdentifier(),
            "HelloWorldThisContainsALotOfForbiddenCharsDoesItStillWorkAnyway")
    }
}
