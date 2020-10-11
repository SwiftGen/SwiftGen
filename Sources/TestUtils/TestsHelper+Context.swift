//
// SwiftGenKit UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import SwiftGenKit
import XCTest

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

public func XCTDiffContexts(
  _ result: [String: Any],
  expected name: String,
  sub directory: Fixtures.Directory,
  file: StaticString = #file,
  line: UInt = #line
) {
  let fileName = "\(name).yaml"

  if ProcessInfo().environment["GENERATE_CONTEXTS"] == "YES" {
    let target = Path(#filePath).parent() + "Fixtures/StencilContexts" + directory.rawValue + fileName
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
