//
//  String.swift
//  SwiftGenKit
//
//  Created by David Jennes on 29/04/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

extension String {
  func uppercasedFirst() -> String {
    guard let first = self.first else {
      return self
    }
    return String(first).uppercased() + String(self.dropFirst())
  }
}
