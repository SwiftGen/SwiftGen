//
//  TestsHelper.swift
//  SwiftGen
//
//  Created by Olivier Halligon on 01/08/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation
import XCTest

func diff(lhs: String, _ rhs: String) -> String {
    var firstDiff : Int? = nil
    for (idx, pair) in zip(lhs.characters, rhs.characters).enumerate() {
        if pair.0 != pair.1 {
            firstDiff = idx
            break;
        }
    }
    if let idx = firstDiff {
        let slice = { (str: String, start: Int, len: Int) -> String in
            let low = advance(str.characters.startIndex, max(0,start), str.characters.endIndex)
            let high = advance(low, len, str.characters.endIndex)
            return String(str.characters[low..<high])
        }
        return "Character mismatch at index \(idx): <\(slice(lhs, idx-10, 21))> != <\(slice(rhs, idx-5, 10))>"
    }
    return ""
}

func XCTDiffStrings(lhs: String, _ rhs: String) {
    XCTAssertEqual(lhs, rhs, diff(lhs, rhs))
}

extension XCTestCase {
    var fixturesDir : String {
        return NSBundle(forClass: self.dynamicType).resourcePath!
    }
    
    func fixturePath(name: String) -> String {
        return NSBundle(forClass: self.dynamicType).pathForResource(name, ofType: "")!
    }

    func fixtureString(name: String, encoding: UInt = NSUTF8StringEncoding) -> String {
        return try! NSString(contentsOfFile: fixturePath(name), encoding: encoding) as String
    }
}