// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

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

// swiftlint:disable identifier_name line_length type_body_length
public enum JSONFiles {
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
  public enum Json {
    private static let _document = JSONDocument(path: "json.json")
    public static let key2: String = _document["key2"]
    public static let key3: [String: Any] = _document["key3"]
    public static let key1: String = _document["key1"]
  }
  public enum Mapping {
    private static let _document = JSONDocument(path: "mapping.yaml")
    public static let key2: [String: Any] = _document["key2"]
    public static let key1: String = _document["key1"]
  }
  public enum Scalar {
    public static let value: String = objectFromJSON(at: "scalar.yaml")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

private final class BundleToken {}
