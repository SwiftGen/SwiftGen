// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - YAML Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
internal enum CustomYAML {
  internal enum Documents {
    internal enum Document1 {
      internal static let items: [String] = ["Mark McGwire", "Sammy Sosa", "Ken Griffey"]
    }
    internal enum Document2 {
      internal static let items: [String] = ["Chicago Cubs", "St Louis Cardinals"]
    }
  }
  internal enum GroceryList {
    internal static let items: [String] = ["Eggs", "Bread", "Milk"]
  }
  internal enum Mapping {
    internal static let car: Any? = nil
    internal static let doors: Int = 5
    internal static let flags: [Bool] = [true, false, true]
    internal static let foo: [String: Any] = ["bar": "banana", "baz": "orange"]
    internal static let hello: String = "world"
    internal static let mixed: [Any] = ["one", 2, true]
    internal static let mixed2: [Any] = [0.1, 2, true]
    internal static let names: [String] = ["John", "Peter", "Nick"]
    internal static let newLayout: Bool = true
    internal static let one: Int = 1
    internal static let primes: [Int] = [2, 3, 5, 7]
    internal static let quickSearch: Bool = false
    internal static let weight: Double = 33.3
    internal static let zero: Int = 0
  }
  internal enum Version {
    internal static let value: String = "1.2.3.beta.4"
  }
}
// swiftlint:enable identifier_name line_length number_separator type_body_length
