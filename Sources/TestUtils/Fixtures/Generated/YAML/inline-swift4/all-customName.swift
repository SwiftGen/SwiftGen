// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - YAML Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
enum CustomYAML {
  enum Documents {
    enum Document1 {
      static let items: [String] = ["Mark McGwire", "Sammy Sosa", "Ken Griffey"]
    }
    enum Document2 {
      static let items: [String] = ["Chicago Cubs", "St Louis Cardinals"]
    }
  }
  enum GroceryList {
    static let items: [String] = ["Eggs", "Bread", "Milk"]
  }
  enum Mapping {
    static let car: Any? = nil
    static let doors: Int = 5
    static let flags: [Bool] = [true, false, true]
    static let foo: [String: Any] = ["bar": "banana", "baz": "orange"]
    static let hello: String = "world"
    static let mixed: [Any] = ["one", 2, true]
    static let mixed2: [Any] = [0.1, 2, true]
    static let names: [String] = ["John", "Peter", "Nick"]
    static let newLayout: Bool = true
    static let one: Int = 1
    static let primes: [Int] = [2, 3, 5, 7]
    static let quickSearch: Bool = false
    static let weight: Double = 33.3
    static let zero: Int = 0
  }
  enum Version {
    static let value: String = "1.2.3.beta.4"
  }
}
// swiftlint:enable identifier_name line_length number_separator type_body_length
