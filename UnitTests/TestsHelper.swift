//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
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
            let low = str.characters.startIndex.advancedBy(max(0,start), limit: str.characters.endIndex)
            let high = low.advancedBy(len, limit: str.characters.endIndex)
            return String(str.characters[low..<high])
        }
        return ">>>> lhs\n\(lhs)\n====\n\(rhs)\n<<< rhs\n\n" + "Character mismatch at index \(idx): <\(slice(lhs, idx-10, 21))> != <\(slice(rhs, idx-5, 10))>"
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
        guard let path = NSBundle(forClass: self.dynamicType).pathForResource(name, ofType: "") else {
            fatalError("Unable to find fixture \"\(name)\"")
        }
        return path
    }

    func fixtureString(name: String, encoding: UInt = NSUTF8StringEncoding) -> String {
        do {
            return try NSString(contentsOfFile: fixturePath(name), encoding: encoding) as String
        } catch let e {
            fatalError("Unable to load fixture content: \(e)")
        }
    }
}