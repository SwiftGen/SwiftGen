//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

/// Use this marker protocol to allow Unit Tests to introspect this object as Dictionary with Mirror and KVC
public protocol ContextConvertible {}

// MARK: - Lazy evaluation

// We need to use a `NSObject` subclass + `@objc` to make Stencil use KVC to access this property,
// and thus allow that `lazy var` not to be resolved by Stencil too early or before it's accessed in the template
final class StencilContextLazyDocument: NSObject, ContextConvertible {
  @objc let data: Any
  @objc private(set) lazy var metadata: [String: Any] = Metadata.generate(for: data)

  init(data: Any) {
    self.data = data
    super.init()
  }
}
