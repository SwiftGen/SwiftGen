//
// SwiftGenKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import Foundation
import XCTest
import PathKit

private let colorCode: (String) -> String =
  ProcessInfo().environment["XcodeColors"] == "YES" ? { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (num: colorCode("fg127,127,127"),
                      code: colorCode(""))
private let koCode = (num: colorCode("fg127,127,127") + colorCode("bg127,0,0"),
                      code: colorCode("fg250,250,250") + colorCode("bg127,0,0"))

func diff(_ result: [String: Any], _ expected: [String: Any], path: String = "") -> String? {

  // check keys
  if Set(result.keys) != Set(expected.keys) {
    let lhs = result.keys.map { " - \($0): \(result[$0] ?? "")" }.joined(separator: "\n")
    let rhs = expected.keys.map { " - \($0): \(expected[$0] ?? "")" }.joined(separator: "\n")
    let path = (path != "") ? " at '\(path)'" : ""
    return "\(msgColor)Keys do not match\(path):\(reset)\n>>>>>> result\n\(lhs)\n======\n\(rhs)\n<<<<<< expected"
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
  let keyPath = (path == "") ? key : "\(path).\(key)"

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
  if ProcessInfo().environment["GENERATE_CONTEXTS"] == "YES" {
    let target = Path(#file).parent() + "Contexts" + directory.rawValue + name
    guard (result as NSDictionary).write(to: target.url, atomically: true) else {
      fatalError("Unable to write context file \(target)")
    }
  } else {
    let expected = Fixtures.context(for: name, sub: directory)
    guard let error = diff(result, expected) else { return }
    XCTFail(error, file: file, line: line)
  }
}

class Fixtures {
  enum Directory: String {
    case colors = "Colors"
    case fonts = "Fonts"
    case xcassets = "XCAssets"
    case storyboardsiOS = "Storyboards-iOS"
    case storyboardsMacOS = "Storyboards-macOS"
    case strings = "Strings"
  }

  private static let testBundle = Bundle(for: Fixtures.self)
  private init() {}

  static func directory(sub: Directory? = nil) -> Path {
    guard let rsrcURL = testBundle.resourceURL else {
      fatalError("Unable to find resource directory URL")
    }
    let rsrc = Path(rsrcURL.path) + "Fixtures"

    guard let dir = sub else { return rsrc }
    return rsrc + dir.rawValue
  }

  static func path(for name: String, sub: Directory) -> Path {
    return path(for: name, subDirectory: "Fixtures/\(sub.rawValue)")
  }

  private static func path(for name: String, subDirectory: String? = nil) -> Path {
    guard let path = testBundle.path(forResource: name, ofType: "", inDirectory: subDirectory) else {
      fatalError("Unable to find fixture \"\(name)\"")
    }
    return Path(path)
  }

  static func context(for name: String, sub: Directory) -> [String: Any] {
    let path = self.path(for: name, subDirectory: "Contexts/\(sub.rawValue)")

    guard let data = NSDictionary(contentsOf: path.url) as? [String: Any] else {
      fatalError("Unable to load fixture content")
    }

    return data
  }
}
