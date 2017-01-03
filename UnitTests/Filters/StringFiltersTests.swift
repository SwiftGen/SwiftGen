//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import SwiftGenKit

class StringFiltersTests: XCTestCase {

  func testLowerFirstWord() {
    let expectations = [
      "string": "string",
      "String": "string",
      "strIng": "strIng",
      "strING": "strING",
      "X": "x",
      "x": "x",
      "SomeCapString": "someCapString",
      "someCapString": "someCapString",
      "string_with_words": "string_with_words",
      "String_with_words": "string_with_words",
      "String_With_Words": "string_With_Words",
      "STRing_with_words": "stRing_with_words",
      "string_wiTH_WOrds": "string_wiTH_WOrds",
      "": "",
      "URLChooser": "urlChooser",
      "a__b__c": "a__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "please_STOP_SCREAMING",
      "PLEASE_STOP_SCREAMING!": "please_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.lowerFirstWord(input) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testTitlecase() {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "String_with_words",
      "String_with_words": "String_with_words",
      "String_With_Words": "String_With_Words",
      "STRing_with_words": "STRing_with_words",
      "string_wiTH_WOrds": "String_wiTH_WOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "A__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "PLEASESTOPSCREAMING",
      "PLEASESTOPSCREAMING!": "PLEASESTOPSCREAMING!",
      "PLEASE_STOP_SCREAMING": "PLEASE_STOP_SCREAMING",
      "PLEASE_STOP_SCREAMING!": "PLEASE_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.titlecase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSnakeToCamelCase() {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "StringWithWords",
      "String_with_words": "StringWithWords",
      "String_With_Words": "StringWithWords",
      "STRing_with_words": "STRingWithWords",
      "string_wiTH_WOrds": "StringWiTHWOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "ABC",
      "__y_z!": "__YZ!",
      "PLEASESTOPSCREAMING": "Pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "Pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "PleaseStopScreaming",
      "PLEASE_STOP_SCREAMING!": "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.snakeToCamelCase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSnakeToCamelCaseNoPrefix() {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "StringWithWords",
      "String_with_words": "StringWithWords",
      "String_With_Words": "StringWithWords",
      "STRing_with_words": "STRingWithWords",
      "string_wiTH_WOrds": "StringWiTHWOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "ABC",
      "__y_z!": "YZ!",
      "PLEASESTOPSCREAMING": "Pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "Pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "PleaseStopScreaming",
      "PLEASE_STOP_SCREAMING!": "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.snakeToCamelCaseNoPrefix(input) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testEscapeReservedKeywords() {
    let expectations = [
      "self": "`self`",
      "foo": "foo",
      "Type": "`Type`",
      "": "",
      "x": "x",
      "Bar": "Bar",
      "#imageLiteral": "`#imageLiteral`"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.escapeReservedKeywords(value: input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
