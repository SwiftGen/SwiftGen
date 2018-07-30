//
// SwiftGen
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import Foundation
import PathKit
import XCTest
import Yams

private let colorCode: (String) -> String =
  ProcessInfo().environment["XcodeColors"] == "YES" ? { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (num: colorCode("fg127,127,127"),
                      code: colorCode(""))
private let koCode = (num: colorCode("fg127,127,127") + colorCode("bg127,0,0"),
                      code: colorCode("fg250,250,250") + colorCode("bg127,0,0"))

private func diff(_ result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  var firstDiff: Int? = nil
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

func diff(_ result: [String: Any], _ expected: [String: Any], path: String = "") -> String? {

  // check keys
  if Set(result.keys) != Set(expected.keys) {
    let lhs = result.keys.map { " - \($0): \(result[$0] ?? "")" }.joined(separator: "\n")
    let rhs = expected.keys.map { " - \($0): \(expected[$0] ?? "")" }.joined(separator: "\n")
    let path = (!path.isEmpty) ? " at '\(path)'" : ""
    return """
      \(msgColor)Keys do not match\(path):\(reset)
      >>>>>> result
      \(lhs)
      ======
      \(rhs)
      <<<<<< expected
      """
  }

  // check values
  for (key, lhs) in result {
    guard let rhs = expected[key] else { continue }

    if let error = compare(lhs, rhs, key: key, path: path) {
      return error
    }
  }

  return nil
}

func compare(_ lhs: Any, _ rhs: Any, key: String, path: String) -> String? {
  let keyPath = (path.isEmpty) ? key : "\(path).\(key)"

  if let lhs = lhs as? Bool, let rhs = rhs as? Bool, lhs == rhs {
    return nil
  } else if let lhs = lhs as? Int, let rhs = rhs as? Int, lhs == rhs {
    return nil
  } else if let lhs = lhs as? Float, let rhs = rhs as? Float, lhs == rhs {
    return nil
  } else if let lhs = lhs as? String, let rhs = rhs as? String, lhs == rhs {
    return nil
  } else if let lhs = lhs as? [Any], let rhs = rhs as? [Any], lhs.count == rhs.count {
    for (lhs, rhs) in zip(lhs, rhs) {
      if let error = compare(lhs, rhs, key: key, path: path) {
        return error
      }
    }
  } else if let lhs = lhs as? [String: Any], let rhs = rhs as? [String: Any] {
    return diff(lhs, rhs, path: "\(keyPath)")
  } else {
    return [
      "\(msgColor)Values do not match for '\(keyPath)':\(reset)",
      ">>>>>> result",
      "\(lhs)",
      "======",
      "\(rhs)",
      "<<<<<< expected"
    ].joined(separator: "\n")
  }

  return nil
}

func XCTDiffContexts(_ result: [String: Any],
                     expected name: String,
                     sub directory: Fixtures.Directory,
                     file: StaticString = #file,
                     line: UInt = #line) {
  let fileName = "\(name).yaml"

  if ProcessInfo().environment["GENERATE_CONTEXTS"] == "YES" {
    let target = Path(#file).parent().parent() + "Fixtures/StencilContexts" + directory.rawValue + fileName
    do {
      let data = try Yams.serialize(node: YamsFix.represent(result))
      try target.write(data)
    } catch let error {
      fatalError("Unable to write context file \(target): \(error)")
    }
  } else {
    let expected = Fixtures.context(for: fileName, sub: directory)
    guard let error = diff(result, expected) else { return }
    XCTFail(error, file: file, line: line)
  }
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
    return path(for: name, subDirectory: "Resources/\(sub.rawValue)")
  }

  private static func path(for name: String, subDirectory: String? = nil) -> Path {
    guard let path = testBundle.path(forResource: name, ofType: "", inDirectory: subDirectory) else {
      fatalError("Unable to find fixture \"\(name)\"")
    }
    return Path(path)
  }

  static func context(for name: String, sub: Directory) -> [String: Any] {
    let path = self.path(for: name, subDirectory: "StencilContexts/\(sub.rawValue)")

    guard let data: String = try? path.read(),
      let yaml = try? Yams.load(yaml: data),
      let result = yaml as? [String: Any] else {
        fatalError("Unable to load fixture content")
    }

    return result
  }
}

// MARK: - Temporary fix until Yams fixes string dumping

enum YamsFix {
  static func represent(_ any: Any) throws -> Node {
    switch any {
    case let string as String:
      return Node(string, .implicit, .doubleQuoted)
    case let array as [Any]:
      return Node(try array.map(represent), Tag(.seq))
    case let dictionary as [String: Any]:
      let pairs = try dictionary.map { (Node($0.key), try represent($0.value)) }
      return Node(pairs.sorted { $0.0 < $1.0 }, Tag(.map))
    case let representable as NodeRepresentable:
      return try representable.represented()
    default:
      throw YamlError.representer(problem: "Failed to represent \(any) as a Yams.Node")
    }
  }
}
