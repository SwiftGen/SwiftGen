//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// Created by Derek Ostrander on 3/7/16.
// MIT License
//

import Foundation

extension Fonts {
  struct Font {
    let filePath: String
    let familyName: String
    let style: String
    let postScriptName: String

    init(filePath: String, familyName: String, style: String, postScriptName: String) {
      self.filePath = filePath
      self.familyName = familyName
      self.style = style
      self.postScriptName = postScriptName
    }
  }
}

// Right now the postScriptName is the value of the font we are looking up, so we do
// equatable comparisons on that. If we ever care about the familyName or style it can be added
extension Fonts.Font: Equatable { }
func == (lhs: Fonts.Font, rhs: Fonts.Font) -> Bool {
  return lhs.postScriptName == rhs.postScriptName
}

extension Fonts.Font: Hashable {
  var hashValue: Int { return postScriptName.hashValue }
}
