//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public func ==<T>(lhs: [T]?, rhs: [T]?) -> Bool {
  switch (lhs, rhs) {
  case (nil, nil):
    return true
  case (.Some(let rhs), .Some(let lhs)):
    return lhs == rhs
  default:
    return false
  }
}

