//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  struct Entry {
    var comment: String?
    let key: String
    let translation: String
    let types: [PlaceholderType]
    let keyStructure: [String]

    init(key: String, translation: String, types: [PlaceholderType], keyStructureSeparator: String) {
      self.key = key
      self.translation = translation
      self.types = types
      self.keyStructure = Self.split(key: key, separator: keyStructureSeparator)
    }

    init(key: String, translation: String, keyStructureSeparator: String) throws {
      let types = try PlaceholderType.placeholderTypes(fromFormat: translation)
      self.init(key: key, translation: translation, types: types, keyStructureSeparator: keyStructureSeparator)
    }

    // MARK: - Structured keys

    private static func split(key: String, separator: String) -> [String] {
      key
        .components(separatedBy: separator)
        .filter { !$0.isEmpty }
    }
  }
}
