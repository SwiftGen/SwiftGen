//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import XCTest

private let colorCode: String -> String = NSProcessInfo().environment["XcodeColors"] == "YES" ?  { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (num: colorCode("fg127,127,127"), code: colorCode(""))
private let koCode = (num: colorCode("fg127,127,127") + colorCode("bg127,0,0"), code: colorCode("bg127,0,0"))

func diff(result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  var firstDiff: Int? = nil
  let nl = NSCharacterSet.newlineCharacterSet()
  let lhsLines = result.componentsSeparatedByCharactersInSet(nl)
  let rhsLines = expected.componentsSeparatedByCharactersInSet(nl)

  for (idx, pair) in zip(lhsLines, rhsLines).enumerate() {
    if pair.0 != pair.1 {
      firstDiff = idx
      break
    }
  }
  if let badLineIdx = firstDiff {
    let numLines = { (num: Int, line: String) -> String in
      let lineNum = "\(num)".stringByPaddingToLength(3, withString: " ", startingAtIndex: 0) + "|"
      let clr = num == badLineIdx ? koCode : okCode
      return "\(clr.num)\(lineNum)\(reset)\(clr.code)\(line)\(reset)"
    }
    let lhsNum = lhsLines.enumerate().map(numLines).joinWithSeparator("\n")
    let rhsNum = rhsLines.enumerate().map(numLines).joinWithSeparator("\n")
    return "\(msgColor)Mismatch at line \(badLineIdx)\(reset)\n>>>>>> result\n\(lhsNum)\n======\n\(rhsNum)\n<<<<<< expected"
  }
  return nil
}

func XCTDiffStrings(result: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
  guard let error = diff(result, expected) else { return }
  XCTFail(error, file: file, line: line)
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

  func directoryPath() -> String  {
    guard let path = NSBundle(forClass: self.dynamicType).resourcePath else {
      fatalError("Unable to get test bundle resource path")
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
