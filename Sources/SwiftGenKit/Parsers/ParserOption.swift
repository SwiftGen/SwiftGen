//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

/// A parser option, used to modify how it processes data.
public protocol AnyParserOption {
  var key: String { get }

  /// Check if the given dictionary contains a valid value for this option.
  func check(dict: [String: Any]) -> Bool
}

/// A parser option of a specific value type
struct ParserOption<T>: AnyParserOption {
  enum OptionError: Swift.Error {
    case invalidType(key: String, expected: Any.Type, got: Any.Type, value: Any)
  }

  let key: String
  let defaultValue: T
  let help: String

  func get(from dict: [String: Any]) throws -> T {
    let value = dict[key] ?? defaultValue
    guard let typed = value as? T else {
      throw OptionError.invalidType(key: key, expected: T.self, got: type(of: value), value: value)
    }
    return typed
  }

  func check(dict: [String: Any]) -> Bool {
    guard let value = dict[key] else { return true }
    return value is T
  }
}

extension ParserOption: CustomStringConvertible {
  public var description: String {
    return "\(key) (\(T.self)) [default: \(defaultValue)]: \(help)"
  }
}
