//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

public struct ParserOptionList {
  enum Error: Swift.Error {
    case unknownOption(key: String, value: Any)
  }

  let knownKeys: Set<String>
  let options: [AnyParserOption]

  init(options: [AnyParserOption] = []) {
    self.options = options
    self.knownKeys = Set(options.map { $0.key })
  }

  init(lists: [ParserOptionList]) {
    self.init(options: lists.flatMap { $0.options })
  }

  /// Check if the given dictionary of key values are all supported options.
  ///
  /// - Parameter options: a dictionary of options
  func check(options: [String: Any]) throws {
    if let badOption = options.first(where: { !knownKeys.contains($0.key) }) {
      throw Error.unknownOption(key: badOption.key, value: badOption.value)
    }
  }

  /// Check if the given key is a known option
  ///
  /// - Parameter option: an option name
  func has(option: AnyParserOption) -> Bool {
    return knownKeys.contains(option.key)
  }

  /// Verify the given dictionary and generate a list of messages for any issues.
  ///
  /// - Parameter dict: the dictionary to verify
  /// - Returns: a list of messages if there are any issues
  public func lint(options dict: [String: Any]) -> [String] {
    let unknownKeys = Set(dict.keys).subtracting(knownKeys).map {
      "\($0) is not a valid option."
    }
    let invalidValues = options.filter { !$0.check(dict: dict) }.map {
      "Invalid value for option \($0)."
    }

    return unknownKeys + invalidValues
  }
}

extension ParserOptionList: CustomStringConvertible {
  public var description: String {
    if options.isEmpty {
      return "This parser currently doesn't accept any options."
    } else {
      return "Supported options:\n" +
        options.map { "       - \($0)" }.joined(separator: "\n")
    }
  }
}

extension ParserOptionList: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: AnyParserOption...) {
    self.init(options: elements)
  }
}
