//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

/*
 This file implements extensions on common types we want to parse.
 */

extension String: DataConvertible {
  public static func parse(data: Any, error: (String) throws -> Void) rethrows -> String? {
    if let data = data as? String {
      return data
    } else {
      try error("Expected a String, but got \(type(of: data))")
      return nil
    }
  }

  public func dataRepresentation() -> Any {
    return self
  }
}

extension Int: DataConvertible {
  public static func parse(data: Any, error: (String) throws -> Void) rethrows -> Int? {
    if let data = data as? Int {
      return data
    } else {
      try error("Expected an Int, but got \(type(of: data))")
      return nil
    }
  }

  public func dataRepresentation() -> Any {
    return self
  }
}

extension Double: DataConvertible {
  public static func parse(data: Any, error: (String) throws -> Void) rethrows -> Double? {
    if let data = data as? Double {
      return data
    } else {
      try error("Expected an Double, but got \(type(of: data))")
      return nil
    }
  }

  public func dataRepresentation() -> Any {
    return self
  }
}
