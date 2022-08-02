//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Difference
import Foundation
import PathKit
import Stencil
import SwiftGenKit
import XCTest

public func XCTAssertEqualDict(
  _ received: [String: Any],
  _ expected: [String: Any],
  file: StaticString = #file,
  line: UInt = #line
) {
  for difference in diff(expected, received) where !difference.isEmpty {
    XCTFail(difference, file: file, line: line)
  }
}

// MARK: - Compare contexts

public func XCTDiffContexts(
  _ received: [String: Any],
  expected name: String,
  sub directory: Fixtures.Directory,
  file: StaticString = #file,
  line: UInt = #line
) {
  let fileName = "\(name).yaml"

  if ProcessInfo().environment["GENERATE_CONTEXTS"] == "YES" {
    store(context: received, directory: directory, fileName: fileName)
  } else {
    do {
      let normalized = try yamlNormalize(received)
      let expected = Fixtures.context(for: fileName, sub: directory)

      for difference in diff(normalized, expected) where !difference.isEmpty {
        XCTFail(difference, file: file, line: line)
      }
    } catch let error {
      fatalError("Unable to compare contexts: \(error)")
    }
  }
}

/// Recursive dig into the object to convert any "lazy" values into a context-compatible structure (Dict, Array, …)
private func normalize(_ object: Any) throws -> Any {
  switch object {
  case let array as [Any]:
    return try array.compactMap(normalize)
  case let dict as [String: Any]:
    return try dict.compactMapValues(normalize)
  case let value as LazyValueWrapper:
    return try normalize(try value.resolve(.init()) ?? value)
  default:
    return object
  }
}

/// Do a roundtrip to YAML, to avoid boolean/int differences
private func yamlNormalize(_ object: Any) throws -> Any {
  try YAML.decode(string: YAML.encode(object: normalize(object))) ?? object
}

/// Write the given data to a context file
private func store(context: Any, directory: Fixtures.Directory, fileName: String) {
  let path = Path(#filePath).parent() + "Fixtures/StencilContexts" + directory.rawValue + fileName

  do {
    try YAML.write(object: normalize(context), to: path)
  } catch let error {
    fatalError("Unable to write context file \(path): \(error)")
  }
}
