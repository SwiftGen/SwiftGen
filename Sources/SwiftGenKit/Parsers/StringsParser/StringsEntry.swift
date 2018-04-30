//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

struct StringsEntry {
  let key: String
  var keyStructure: [String] {
      return key.components(separatedBy: CharacterSet(charactersIn: "."))
  }
  let translation: String
  let types: [StringsParser.PlaceholderType]

  init(key: String, translation: String, types: [StringsParser.PlaceholderType]) {
    self.key = key
    self.translation = translation
    self.types = types
  }

  init(key: String, translation: String, types: StringsParser.PlaceholderType...) {
    self.init(key: key, translation: translation, types: types)
  }

  init(key: String, translation: String) throws {
    let types = try StringsParser.PlaceholderType.placeholders(fromFormat: translation)
    self.init(key: key, translation: translation, types: types)
  }
}
