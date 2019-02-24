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
      "catalogs": catalogs,
      "resourceCount": AssetsCatalog.Parser.countTypes(catalogs: self.catalogs)
    ]
  }

  fileprivate static func structure(entries: [AssetsCatalogEntry]) -> [[String: Any]] {
    return entries.map { $0.asDictionary }
  }

  private static func countTypes(catalogs: [AssetsCatalog.Catalog]) -> [String: Int] {
    var result: [String: Int] = [:]
    countTypes(entries: catalogs.flatMap { $0.entries }, into: &result)
    return result
  }

  private static func countTypes(entries: [AssetsCatalogEntry], into result: inout [String: Int]) {
    for entry in entries {
      if let entry = entry as? AssetsCatalog.Entry.EntryWithValue {
        result[entry.type, default: 0] += 1
      } else if let group = entry as? AssetsCatalog.Entry.Group {
        AssetsCatalog.Parser.countTypes(entries: group.items, into: &result)
      }
    }
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
