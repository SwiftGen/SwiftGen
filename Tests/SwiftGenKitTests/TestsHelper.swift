//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import SwiftGenKit
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

private func diff(_ result: [String: Any], _ expected: [String: Any], path: String = "") -> String? {
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

private func compare(_ lhs: Any, _ rhs: Any, key: String, path: String) -> String? {
  let keyPath = (path.isEmpty) ? key : "\(path).\(key)"

  if let lhs = convertToNumber(lhs), let rhs = convertToNumber(rhs) {
    return compare(lhs, rhs, keyPath: keyPath)
  } else if let lhs = convertToString(lhs), let rhs = convertToString(rhs) {
    return compare(lhs, rhs, keyPath: keyPath)
  } else if let lhs = lhs as? Data, let rhs = rhs as? Data {
    return compare(lhs, rhs, keyPath: keyPath)
  } else if let lhs = lhs as? Date, let rhs = rhs as? Date {
    return compare(lhs, rhs, keyPath: keyPath)
  } else if let lhs = lhs as? [Any], let rhs = rhs as? [Any], lhs.count == rhs.count {
    for (lhs, rhs) in zip(lhs, rhs) {
      if let error = compare(lhs, rhs, key: key, path: path) {
        return error
      }
    }
  } else if let lhs = convertToDictionary(lhs), let rhs = convertToDictionary(rhs) {
    return diff(lhs, rhs, path: "\(keyPath)")
  } else if let lhs = lhs as? String, lhs == "\(rhs)" {
    return nil
  } else {
    return compare(String(describing: lhs), String(describing: rhs), keyPath: keyPath)
  }

  return nil
}

private func compare<T: Equatable>(_ lhs: T, _ rhs: T, keyPath: String) -> String? {
  if lhs == rhs {
    return nil
  } else {
    return """
    \(msgColor)Values do not match for '\(keyPath)':\(reset)
    >>>>>> result
    \(lhs)
    ======
    \(rhs)
    <<<<<< expected
    """
  }
}

// MARK: Converting structures to YAML/Plist-compatible values

private func convertToNumber(_ value: Any) -> NSNumber? {
  switch value {
  case let value as Bool:
    return value as NSNumber
  case let value as Int:
    return value as NSNumber
  case let value as Double:
    return value as NSNumber
  default:
    return nil
  }
}

private func convertToString(_ value: Any) -> String? {
  switch value {
  case let value as String:
    return value
  case is NSNull:
    return ""
  default:
    return nil
  }
}

private func convertToDictionary(_ value: Any) -> [String: Any]? {
  switch value {
  case let value as [String: Any]:
    return value
  case let value as NSObject & ContextConvertible:
    return value.convertToDictionary()
  default:
    return nil
  }
}

extension ContextConvertible where Self: NSObject {
  func convertToDictionary() -> [String: Any] {
    var result: [(String, Any)] = []
    var mirror: Mirror? = Mirror(reflecting: self)

    repeat {
      // At runtime when mirroring, labels for lazy vars get the "$__lazy_storage_$_" prefix
      // so we need to delete the prefix to handle those lazy var cases.
      // We use `object.value(forKey:) to force load lazy variables because `someMirrorChild.value`
      // evaluates to `nil` for lazy variables and doesn't trigger the lazy var evaluation.
      result += mirror?.children
        .compactMap { $0.label?.deletingPrefix("$__lazy_storage_$_") }
        .map { ($0, self.value(forKey: $0) as Any) } ?? []
      mirror = mirror?.superclassMirror
    } while mirror != nil

    return Dictionary(uniqueKeysWithValues: result)
  }
}

private extension String {
  func deletingPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

private extension Dictionary where Key == String {
  func convertedToContext() -> [String: Any] {
    self.mapValues(convertToContext)
  }
}

private extension Array {
  func convertedToContext() -> [Any] {
    self.map(convertToContext)
  }
}

/// Recursive dig into the object to convert any `ContextConvertible`
/// into a context-compatible structure (Dict, Array, …)
private func convertToContext(_ object: Any) -> Any {
  switch object {
  case let array as [Any]:
    return array.convertedToContext()
  case let dict as [String: Any]:
    return dict.convertedToContext()
  case let convertible as NSObject & ContextConvertible:
    return convertible.convertToDictionary()
  default:
    return object
  }
}

// MARK: Compare contexts

func XCTDiffContexts(
  _ result: [String: Any],
  expected name: String,
  sub directory: Fixtures.Directory,
  file: StaticString = #file,
  line: UInt = #line
) {
  let fileName = "\(name).yaml"

  if ProcessInfo().environment["GENERATE_CONTEXTS"] == "YES" {
    let target = Path(#file).parent().parent() + "Fixtures/StencilContexts" + directory.rawValue + fileName
    do {
      try YAML.write(object: result.convertedToContext(), to: target)
    } catch let error {
      fatalError("Unable to write context file \(target): \(error)")
    }
  } else {
    let expected = Fixtures.context(for: fileName, sub: directory)
    guard let error = diff(result, expected) else { return }
    XCTFail(error, file: file, line: line)
  }
}

// MARK: Safe access to fixtures

class Fixtures {
  enum Directory: String {
    case colors = "Colors"
    case coreData = "CoreData"
    case fonts = "Fonts"
    case interfaceBuilder = "IB"
    case interfaceBuilderiOS = "IB-iOS"
    case interfaceBuilderMacOS = "IB-macOS"
    case json = "JSON"
    case plist = "Plist"
    case plistBad = "Plist/bad"
    case plistGood = "Plist/good"
    case strings = "Strings"
    case xcassets = "XCAssets"
    case yaml = "YAML"
    case yamlBad = "YAML/bad"
    case yamlGood = "YAML/good"
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

  static func context(for name: String, sub: Directory) -> [String: Any] {
    let path = self.path(for: name, subDirectory: "StencilContexts/\(sub.rawValue)")

    guard let yaml = try? YAML.read(path: path),
      let result = yaml as? [String: Any] else {
        fatalError("Unable to load fixture content")
    }

    return result
  }
}

extension SwiftGenKit.Parser {
  func searchAndParse(path: Path) throws {
    let filter = try Filter(pattern: Self.defaultFilter)
    try searchAndParse(path: path, filter: filter)
  }

  func searchAndParse(paths: [Path]) throws {
    for path in paths {
      try searchAndParse(path: path)
    }
  }
}
