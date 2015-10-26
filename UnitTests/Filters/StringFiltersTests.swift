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
      let result = StringFilters.lowerFirstWord(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
  
  func testSnakeToCamelCase() {
    let expectations = [
      "string": "string",
      "string_with_words": "stringWithWords",
      "someCapString": "someCapString",
      "": "",
      "x": "x",
      "a__b__c": "aBC",
      "__y_z": "__YZ",
      "PLEASE_STOP_SCREAMING!": "PLEASESTOPSCREAMING!"
    ]
    
    for (input, expected) in expectations {
      let result = StringFilters.snakeToCamelCase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
