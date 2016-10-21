//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public protocol DataModel: DataConvertible {
  func data() -> [String: Any]
}

extension DataModel {
  public func dataRepresentation() -> Any {
    return data()
  }
}

public protocol DataConvertible {
  static func parsed(data: Any) throws -> Self
  func dataRepresentation() -> Any
}

