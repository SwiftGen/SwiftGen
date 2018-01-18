//
//  YamlContext.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

/*
 - `root_scalar`: `Any` - if the root value is a scalar, it will be under this key
 - `root_sequence`: `Array` - if the root value is an array, it will be under this key
 - ... - Any mapping at the root level will be exposed at the root level
 */
extension Yaml.Parser {
  public func stencilContext() -> [String: Any] {
    return yamlMapping
  }
}
