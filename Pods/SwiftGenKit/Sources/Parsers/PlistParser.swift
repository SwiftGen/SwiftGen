//
//  PlistParser.swift
//  SwiftGenKit
//
//  Created by Toshihiro Suzuki on 4/12/17.
//  Copyright © 2017 SwiftGen. All rights reserved.
//

import Foundation
import PathKit

public final class PlistParser {

  var keys: [String] = []

  public init() {}

  public func parse(at path: Path) {
    guard let keys = loadPlistKeys(at: path) else { return }
    self.keys = keys
  }

  fileprivate func loadPlistKeys(at path: Path) -> [String]? {
    guard let data = try? path.read() else {
      return nil
    }
    // try to parse plist
    guard let plist = try? PropertyListSerialization
      .propertyList(from: data, format: nil) as? [String: Any]
      else { return nil }
    var arr = [String]()
    for (k, _) in plist! {
      arr.append(k)
    }
    return arr
  }
}
