//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

struct ParserOptionValues {
  private let options: [String: Any]
  private let available: ParserOptionList

  init(options: [String: Any], available: ParserOptionList) throws {
    try available.check(options: options)
    self.options = options
    self.available = available
  }

  subscript<T>(option: ParserOption<T>) -> T {
    guard available.has(option: option) else {
      fatalError("Trying to get unknown option \(option.key)")
    }
    return (try? option.get(from: options)) ?? option.defaultValue
  }
}
