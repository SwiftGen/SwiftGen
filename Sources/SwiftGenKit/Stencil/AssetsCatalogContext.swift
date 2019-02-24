//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/Assets.md
//

extension AssetsCatalog.Parser {
  public func stencilContext() -> [String: Any] {
    let catalogs = self.catalogs
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map { catalog -> [String: Any] in
        [
          "name": catalog.name,
          "assets": AssetsCatalog.Parser.structure(entries: catalog.entries)
        ]
      }

    return [
      "catalogs": catalogs
    ]
  }

  fileprivate static func structure(entries: [AssetsCatalogEntry]) -> [[String: Any]] {
    return entries.map { $0.asDictionary }
  }
}

extension AssetsCatalog.Entry.EntryWithValue {
  var asDictionary: [String: Any] {
    return [
      "type": type,
      "name": name,
      "value": value
    ]
  }
}

extension AssetsCatalog.Entry.Group {
  var asDictionary: [String: Any] {
    return [
      "type": "group",
      "isNamespaced": "\(isNamespaced)",
      "name": name,
      "items": AssetsCatalog.Parser.structure(entries: items)
    ]
  }
}
