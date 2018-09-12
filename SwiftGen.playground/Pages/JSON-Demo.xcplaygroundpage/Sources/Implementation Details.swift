import Foundation

// Extra for playgrounds
public var bundle: Bundle!

// MARK: - Implementation Details

public func objectFromJSON<T>(at path: String) -> T {
  guard let url = bundle.url(forResource: path, withExtension: nil),
    let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []),
    let result = json as? T else {
    fatalError("Unable to load JSON at path: \(path)")
  }
  return result
}

public struct JSONDocument {
  let data: [String: Any]

  public init(path: String) {
    self.data = objectFromJSON(at: path)
  }

  public subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}
