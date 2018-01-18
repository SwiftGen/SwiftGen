//
//  PlistContext.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Yams

/*
 These extensions are needed otherwise Yams can't serialize Plist files (which
 internally still use Objective-C types)
 */

extension NSDictionary: NodeRepresentable {
  public func represented() throws -> Node {
    guard let dictionary = self as? [AnyHashable: Any] else { fatalError("bla") }
    return try dictionary.represented()
  }
}

extension NSArray: NodeRepresentable {
  public func represented() throws -> Node {
    guard let array = self as? [Any] else { fatalError("bla") }
    return try array.represented()
  }
}

/*
 - `root_array`: `Array` - if the root value is an array, it will be under this key
 - ... - Any dictionary keys at the root level will be exposed at the root level
 */
extension Plist.Parser {
  public func stencilContext() -> [String: Any] {
    return plistContext
  }
}
