//
// SwiftGen UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import XCTest

private let colorCode: (String) -> String =
  ProcessInfo().environment["XcodeColors"] == "YES" ? { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (
  num: colorCode("fg127,127,127"),
  code: colorCode("")
)
private let koCode = (
  num: colorCode("fg127,127,127") + colorCode("bg127,0,0"),
  code: colorCode("fg250,250,250") + colorCode("bg127,0,0")
)

private func diff(_ result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  var firstDiff: Int?
  let newLines = CharacterSet.newlines
  let lhsLines = result.components(separatedBy: newLines)
  let rhsLines = expected.components(separatedBy: newLines)

  for (idx, pair) in zip(lhsLines, rhsLines).enumerated() where pair.0 != pair.1 {
    firstDiff = idx
    break
  }
  if firstDiff == nil && lhsLines.count != rhsLines.count {
    firstDiff = min(lhsLines.count, rhsLines.count)
  }
  if let badLineIdx = firstDiff {
    let slice = { (lines: [String], context: Int) -> ArraySlice<String> in
      let start = max(0, badLineIdx - context)
      let end = min(badLineIdx + context, lines.count - 1)
      return lines[start...end]
    }
    let addLineNumbers = { (slice: ArraySlice) -> [String] in
      slice.enumerated().map { (idx: Int, line: String) in
        let num = idx + slice.startIndex
        let lineNum = "\(num + 1)".padding(toLength: 3, withPad: " ", startingAt: 0) + "|"
        let clr = num == badLineIdx ? koCode : okCode
        return "\(clr.num)\(lineNum)\(reset)\(clr.code)\(line)\(reset)"
      }
    }
    let lhsNum = addLineNumbers(slice(lhsLines, 4)).joined(separator: "\n")
    let rhsNum = addLineNumbers(slice(rhsLines, 4)).joined(separator: "\n")
    return [
      "\(msgColor)Mismatch at line \(badLineIdx)\(reset)",
      ">>>>>> result",
      "\(lhsNum)",
      "======",
      "\(rhsNum)",
      "<<<<<< expected"
    ].joined(separator: "\n")
  }
  return nil
}

func XCTDiffStrings(_ result: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
  guard let error = diff(result, expected) else { return }
  XCTFail(error, file: file, line: line)
}

func XCTAssertEqualDict(
  _ result: [String: Any],
  _ expected: [String: Any],
  file: StaticString = #file,
  line: UInt = #line
) {
  XCTAssertTrue(
    NSDictionary(dictionary: result).isEqual(to: expected),
    "expected \(expected), got \(result)",
    file: file,
    line: line
  )
}

class Fixtures {
  enum Directory: String {
    case colors = "Colors"
    case fonts = "Fonts"
    case interfaceBuilder = "IB"
    case interfaceBuilderiOS = "IB-iOS"
    case interfaceBuilderMacOS = "IB-macOS"
    case strings = "Strings"
    case xcassets = "XCAssets"
  }

  private static let testBundle = Bundle(for: Fixtures.self)
  private init() {}

  static func directory(sub: Directory? = nil) -> Path {
    guard let rsrcURL = testBundle.resourceURL else {
      fatalError("Unable to find resource directory URL")
    }
    let rsrc = Path(rsrcURL.path) + "Resources"

    guard let dir = sub else { return rsrc }
    return rsrc + dir.rawValue
  }

  static func path(for name: String, sub: Directory) -> Path {
    path(for: name, subDirectory: "Resources/\(sub.rawValue)")
  }

  private static func path(for name: String, subDirectory: String? = nil) -> Path {
    guard let path = testBundle.path(forResource: name, ofType: "", inDirectory: subDirectory) else {
      fatalError("Unable to find fixture \"\(name)\"")
    }
    return Path(path)
  }

  static func template(for name: String, sub: Directory) -> String {
    string(for: name, subDirectory: "templates/\(sub.rawValue.lowercased())")
  }

  static func output(for name: String, sub: Directory) -> String {
    string(for: name, subDirectory: "Generated/\(sub.rawValue)")
  }

  private static func string(for name: String, subDirectory: String) -> String {
    do {
      return try path(for: name, subDirectory: subDirectory).read()
    } catch let error {
      fatalError("Unable to load fixture content: \(error)")
    }
  }
}

extension Config {
  var commandNames: Set<String> {
    Set(commands.map { $0.command.name })
  }

  func entries(for cmd: String) -> [ConfigEntry] {
    commands.filter { $0.command.name == cmd }.map { $0.entry }
  }
}

final class TestLogger {
  private let queue = DispatchQueue(label: "swiftgen.log.queue")
  private let unwantedLevels: Set<LogLevel>
  private let file: StaticString
  private let line: UInt
  private var missingLogs: [(LogLevel, String)]

  init(
    expectedLogs: [(LogLevel, String)],
    unwantedLevels: Set<LogLevel> = [],
    file: StaticString,
    line: UInt
  ) {
    self.missingLogs = expectedLogs
    self.unwantedLevels = unwantedLevels
    self.file = file
    self.line = line
  }

  func log(level: LogLevel, msg: String) {
    queue.async {
      if let idx = self.missingLogs.firstIndex(where: { $0 == level && $1 == msg }) {
        self.missingLogs.remove(at: idx)
      } else if self.unwantedLevels.contains(level) {
        XCTFail("Unexpected log: \(msg)", file: self.file, line: self.line)
      }
    }
  }

  func handleError(_ error: Error) {
    if let idx = missingLogs.firstIndex(where: { $0 == .error && $1 == String(describing: error) }) {
      missingLogs.remove(at: idx)
    } else {
      XCTFail("Unexpected error: \(error)", file: file, line: line)
    }
  }

  func waitAndAssert(message: String) {
    queue.sync(flags: .barrier) {}

    XCTAssertTrue(
      missingLogs.isEmpty,
      """
      \(message)
      The following logs were expected but never received:
      \(missingLogs.map { "\($0) - \($1)" }.joined(separator: "\n"))
      """,
      file: file,
      line: line
    )
  }
}
