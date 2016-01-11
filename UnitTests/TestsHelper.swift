//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import XCTest

func diff(lhs: String, _ rhs: String) -> String {
  var firstDiff: Int? = nil
  let nl = NSCharacterSet.newlineCharacterSet()
  let lhsLines = lhs.componentsSeparatedByCharactersInSet(nl)
  let rhsLines = rhs.componentsSeparatedByCharactersInSet(nl)

  for (idx, pair) in zip(lhsLines, rhsLines).enumerate() {
    if pair.0 != pair.1 {
      firstDiff = idx
      break
    }
  }
  if let idx = firstDiff {
    let numLines = { (num: Int, line: String) -> String in "\(num)".stringByPaddingToLength(3, withString: " ", startingAtIndex: 0) + "|" + line }
    let lhsNum = lhsLines.enumerate().map(numLines).joinWithSeparator("\n")
    let rhsNum = rhsLines.enumerate().map(numLines).joinWithSeparator("\n")
    return "Mismatch at line \(idx)>\n>>>>>> lhs\n\(lhsNum)\n======\n\(rhsNum)\n<<<<<< rhs"
  }
  return ""
}

func XCTDiffStrings(lhs: String, _ rhs: String) {
  XCTAssertEqual(lhs, rhs, diff(lhs, rhs))
}

extension XCTestCase {
  var fixturesDir: String {
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
