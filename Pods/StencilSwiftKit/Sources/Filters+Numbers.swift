//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

// For retro-compatibility. Remove in next major.
@available(*, deprecated, renamed: "Filters.Numbers", message: "Use the Filters.Numbers nested type instead")
typealias NumFilters = Filters.Numbers

extension Filters {
  enum Numbers {
    static func hexToInt(_ value: Any?) throws -> Any? {
      guard let value = value as? String else { throw Filters.Error.invalidInputType }
      return Int(value, radix:  16)
    }

    static func int255toFloat(_ value: Any?) throws -> Any? {
      guard let value = value as? Int else { throw Filters.Error.invalidInputType }
      return Float(value) / Float(255.0)
    }

    static func percent(_ value: Any?) throws -> Any? {
      guard let value = value as? Float else { throw Filters.Error.invalidInputType }

      let percent = Int(value * 100.0)
      return "\(percent)%"
    }
  }
}
