//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import XCTest

// MARK: - Compare strings

public func XCTDiffStrings(_ received: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
  guard let error = diff(received, expected) else { return }
  XCTFail(error, file: file, line: line)
}

private func diff(_ result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  let lhsLines = result.components(separatedBy: .newlines)
  let rhsLines = expected.components(separatedBy: .newlines)

  // try to find different line (or last if different size)
  var firstDiff = zip(0..., zip(lhsLines, rhsLines)).first { $1.0 != $1.1 }?.0
  if firstDiff == nil && lhsLines.count != rhsLines.count {
    firstDiff = min(lhsLines.count, rhsLines.count)
  }

  // generate output
  guard let line = firstDiff else { return nil }
  let lhsNum = addLineNumbers(slice(lhsLines, around: line))
  let rhsNum = addLineNumbers(slice(rhsLines, around: line))
  return """
    Mismatch at line \(line + 1)
    >>>>>> received
    \(lhsNum)
    ======
    \(rhsNum)
    <<<<<< expected
    """
}

private func slice(_ lines: [String], around index: Int, context: Int = 4) -> ArraySlice<String> {
  let start = max(0, index - context)
  let end = min(index + context, lines.count - 1)
  return lines[start...end]
}

private func addLineNumbers(_ slice: ArraySlice<String>) -> String {
  let middle = slice.startIndex + (slice.endIndex - slice.startIndex) / 2

  return zip(slice.startIndex..., slice)
    .map { index, line in
      let number = "\(index + 1)".padding(toLength: 3, withPad: " ", startingAt: 0)
      let separator = (index == middle) ? ">" : "|"
      return "\(number)\(separator)\(line)"
    }
    .joined(separator: "\n")
}
