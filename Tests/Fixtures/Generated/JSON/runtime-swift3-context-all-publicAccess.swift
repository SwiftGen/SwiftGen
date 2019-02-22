// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
public enum JSONFiles {
  public enum Configuration {
    private static let _document = JSONDocument(path: "configuration.json")
    public static let apiVersion: String = _document["api-version"]
    public static let country: Any? = _document["country"]
    public static let environment: String = _document["environment"]
    public static let options: [String: Any] = _document["options"]
  }
  public enum Documents {
    public enum Document1 {
      public static let items: [String] = objectFromJSON(at: "documents.yaml")
    }
    public enum Document2 {
      public static let items: [String] = objectFromJSON(at: "documents.yaml")
    }
  }
  public enum GroceryList {
    public static let items: [String] = objectFromJSON(at: "grocery-list.yaml")
  }
  public enum Mapping {
    private static let _document = JSONDocument(path: "mapping.yaml")
    public static let car: Any? = _document["car"]
    public static let foo: [String: Any] = _document["foo"]
    public static let hello: String = _document["hello"]
    public static let weight: Double = _document["weight"]
  }
  public enum Version {
    public static let value: String = objectFromJSON(at: "version.yaml")
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
