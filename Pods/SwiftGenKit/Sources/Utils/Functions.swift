//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT License
//

import Foundation

// Replace special characters with "_"
func format(_ string: String) -> String {
  guard let first = string.characters.first else {
    return ""
  }
  if ("0"..."9").contains(first) {
    return format(String(["_"] + string.characters.dropFirst()))
  }
  return string.characters.map { String($0) }.map { c in
    guard ("a"..."z").contains(c) || ("A"..."Z").contains(c) || ("0"..."9").contains(c) else {
      return "_"
    }
    return c
  }.joined()
}
