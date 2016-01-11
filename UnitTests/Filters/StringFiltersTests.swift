//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import GenumKit

class StringFiltersrTests: XCTestCase {

  func testLowerFirstWord() {
    let expectations = [
      "string": "string",
      "string_with_words": "string_with_words",
      "SomeCapString": "someCapString",
      "": "",
      "X": "x",
      "URLChooser": "urlChooser",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "pleasestopscreaming"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.lowerFirstWord(input) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSnakeToCamelCase() {
    let expectations = [
      "string": "String",
      "string_with_words": "StringWithWords",
      "someCapString": "SomeCapString",
      "": "",
      "x": "X",
      "a__b__c": "ABC",
      "__y_z": "__YZ",
      "PLEASE_STOP_SCREAMING!": "PLEASESTOPSCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try! StringFilters.snakeToCamelCase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
