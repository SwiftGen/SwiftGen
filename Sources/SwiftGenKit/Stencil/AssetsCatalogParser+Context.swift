//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/xcassets.md
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
    entries.map { $0.asDictionary }
  }

  private static func countTypes(catalogs: [AssetsCatalog.Catalog]) -> [String: Int] {
    var result: [String: Int] = [:]
    countTypes(entries: catalogs.flatMap { $0.entries }, into: &result)
    return result
  }

  private static func countTypes(entries: [AssetsCatalogEntry], into result: inout [String: Int]) {
    for entry in entries {
      if let entry = entry as? AssetsCatalog.Entry.Item {
        result[entry.item.typeName, default: 0] += 1
      } else if let group = entry as? AssetsCatalog.Entry.Group {
        AssetsCatalog.Parser.countTypes(entries: group.items, into: &result)
      }
    }
  }
}

extension AssetsCatalog.Entry.Group {
  var asDictionary: [String: Any] {
    [
      "type": "group",
      "isNamespaced": "\(isNamespaced)",
      "name": name,
      "items": AssetsCatalog.Parser.structure(entries: items)
    ]
  }
}

extension AssetsCatalog.Entry.Item {
  var asDictionary: [String: Any] {
    [
      "type": item.typeName,
      "name": name,
      "value": value
    ]
  }
}

extension Constants.Item {
  var typeName: String {
    switch self {
    case .arResourceGroup:
      return "arresourcegroup"
    case .colorSet:
      return "color"
    case .dataSet:
      return "data"
    case .imageSet:
      return "image"
    }
  }
}
