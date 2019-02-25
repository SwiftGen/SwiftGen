// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
internal enum JSONFiles {
  internal enum Configuration {
    private static let _document = JSONDocument(path: "configuration.json")
    internal static let apiVersion: String = _document["api-version"]
    internal static let country: Any? = _document["country"]
    internal static let environment: String = _document["environment"]
    internal static let options: [String: Any] = _document["options"]
  }
  internal enum Documents {
    internal enum Document1 {
      internal static let items: [String] = objectFromJSON(at: "documents.yaml")
    }
    internal enum Document2 {
      internal static let items: [String] = objectFromJSON(at: "documents.yaml")
    }
  }
  internal enum GroceryList {
    internal static let items: [String] = objectFromJSON(at: "grocery-list.yaml")
  }
  internal enum Mapping {
    private static let _document = JSONDocument(path: "mapping.yaml")
    internal static let car: Any? = _document["car"]
    internal static let foo: [String: Any] = _document["foo"]
    internal static let hello: String = _document["hello"]
    internal static let weight: Double = _document["weight"]
  }
  internal enum Version {
    internal static let value: String = objectFromJSON(at: "version.yaml")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func objectFromJSON<T>(at path: String) -> T {
  let bundle = Bundle(for: BundleToken.self)
  guard let url = bundle.url(forResource: path, withExtension: nil),
    let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []),
    let result = json as? T else {
    fatalError("Unable to load JSON at path: \(path)")
  }
  return result
}

private struct JSONDocument {
  let data: [String: Any]

  init(path: String) {
    self.data = objectFromJSON(at: path)
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

private final class BundleToken {}
