//
//  PlistContext.swift
//  SwiftGenKit
//
//  Created by Toshihiro Suzuki on 4/12/17.
//  Copyright © 2017 SwiftGen. All rights reserved.
//

import Foundation
extension PlistParser {
  public func stencilContext() -> [String: Any] {
    guard !isEmpty else {
      return [:]
    }
    var result = [String: Any]()
    if !stringKeys.isEmpty {
      result["stringKeys"] = stringKeys.map { $0.stencilContext() }
    }
    if !intKeys.isEmpty {
      result["intKeys"] = intKeys.map { $0.stencilContext() }
    }
    if !boolKeys.isEmpty {
      result["boolKeys"] = boolKeys.map { $0.stencilContext() }
    }
    if !dataKeys.isEmpty {
      result["dataKeys"] = dataKeys.map { $0.stencilContext() }
    }
    if !dateKeys.isEmpty {
      result["dateKeys"] = dateKeys.map { $0.stencilContext() }
    }
    if !dictKeys.isEmpty {
      result["dictKeys"] = dictKeys.map { $0.stencilContext() }
    }
    if !arrayKeys.isEmpty {
      result["arrayKeys"] = arrayKeys.map { $0.stencilContext() }
    }
    if !unknownKeys.isEmpty {
      result["unknownKeys"] = unknownKeys.map { $0.stencilContext() }
    }
    return result
  }
}

extension PlistParser.Meta {
  public func stencilContext() -> Any {
    return key
  }
}
