//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
@testable import GenumKit

class StringFiltersrTests: XCTestCase {
  
  func testLowerFirstWord1() {
    
  }
  
  func testSnakeToCamelCase() {
    let expectations = [
      "string": "string",
      "string_with_words": "stringWithWords",
      "": "",
      "x": "x",
      "a__b__c": "aBC",
      "__y_z": "YZ"
    ]
    
    for (input, expected) in expectations {
      let result = StringFilters.snakeToCamelCase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
