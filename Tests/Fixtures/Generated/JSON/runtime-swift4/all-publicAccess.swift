// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
public enum JSONFiles {
  public enum Array {
    public static let items: [String] = objectFromJSON(at: "array.json")
  }
  public enum Configuration {
    private static let _document = JSONDocument(path: "configuration.json")
    public static let apiVersion: String = _document["api-version"]
    public static let country: Any? = _document["country"]
    public static let doors: Int = _document["doors"]
    public static let environment: String = _document["environment"]
    public static let flags: [Bool] = _document["flags"]
    public static let mixed: [Any] = _document["mixed"]
    public static let mixed2: [Any] = _document["mixed2"]
    public static let newLayout: Bool = _document["new-layout"]
    public static let one: Int = _document["one"]
    public static let options: [String: Any] = _document["options"]
    public static let primes: [Int] = _document["primes"]
    public static let quickSearch: Bool = _document["quick-search"]
    public static let zero: Int = _document["zero"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func objectFromJSON<T>(at path: String) -> T {
  guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
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

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
