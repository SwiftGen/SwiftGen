//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension Bool {
  init?(from string: String) {
    switch string {
    case "YES":
      self = true
    case "NO":
      self = false
    default:
      guard let value = Bool(string) else {
        return nil
      }
      self = value
    }
  }
}
