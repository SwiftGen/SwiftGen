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

  private let options: [AnyParserOption]

  init(options: [AnyParserOption] = []) {
    self.options = options
  }

  init(lists: [ParserOptionList]) {
    self.options = lists.flatMap { $0.options }
  }

  /// Check if the given dictionary of key values are all supported options.
  ///
  /// - Parameter options: a dictionary of options
  public func check(options: [String: Any]) throws {
    let known = Set(self.options.map { $0.key })
    for option in options where !known.contains(option.key) {
      throw Error.unknownOption(key: option.key, value: option.value)
    }
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
