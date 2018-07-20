//
//  Bool.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/19/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
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
