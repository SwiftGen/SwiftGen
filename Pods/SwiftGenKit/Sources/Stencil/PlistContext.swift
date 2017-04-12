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
    return ["plistKeys": keys]
  }
}
