// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
internal enum CustomJSON {
  internal enum Documents {
    internal enum Document1 {
      internal static let items: [String] = ["Mark McGwire", "Sammy Sosa", "Ken Griffey"]
    }
    internal enum Document2 {
      internal static let items: [String] = ["Chicago Cubs", "St Louis Cardinals"]
    }
  }
  internal enum GroceryList {
    internal static let items: [String] = ["value1", "value2"]
  }
  internal enum Json {
    internal static let key2: String = "2"
    internal static let key3: [String: Any] = ["nestedKey3": ["1", "2", "3"]]
    internal static let key1: String = "value1"
  }
  internal enum Mapping {
    internal static let key2: [String: Any] = ["nestedKey2": "nestedValue2"]
    internal static let key1: String = "value1"
  }
  internal enum Scalar {
    internal static let value: String = "value1"
  }
}
// swiftlint:enable identifier_name line_length number_separator type_body_length
