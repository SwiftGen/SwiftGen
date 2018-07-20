//
//  CoreDataContext.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/18/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

extension CoreData.Parser {
  public func stencilContext() -> [String: Any] {
    return [
      "models": models
    ]
  }
}
