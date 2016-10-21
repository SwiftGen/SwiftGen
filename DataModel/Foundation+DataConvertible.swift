//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

extension String: DataConvertible {
  public static func parsed(data: Any) throws -> String {
    if let data = data as? String {
      return data
    }
    throw ParserError(message: "Expected a string, but got \(data)")
  }

  public func dataRepresentation() -> Any {
    return self
  }
}

extension Double: DataConvertible {
  public static func parsed(data: Any) throws -> Double {
    if let data = data as? Double {
      return data
    }
    throw ParserError(message: "Expected a double, but got \(data)")
  }

  public func dataRepresentation() -> Any {
    return self
  }
}

extension Int: DataConvertible {
  public static func parsed(data: Any) throws -> Int {
    if let data = data as? Int {
      return data
    }
    throw ParserError(message: "Expected an int, but got \(data)")
  }

  public func dataRepresentation() -> Any {
    return self
  }
}

