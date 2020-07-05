//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
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
extension Fonts.Font: Equatable {
  static func == (lhs: Fonts.Font, rhs: Fonts.Font) -> Bool {
    lhs.postScriptName == rhs.postScriptName
  }
}

extension Fonts.Font: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(postScriptName)
  }
}
