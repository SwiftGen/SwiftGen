//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents a group and has the following entries:
       - `type` : `String` — "group"
       - `name` : `String` — name of the folder
       - `items`: `Array` — list of items, can be either groups, colors or images
     - represents a color asset, and has the following entries:
       - `type` : `String` — "color"
       - `name` : `String` — name of the color
       - `value`: `String` — the actual full name for loading the color
     - represents an image asset, and has the following entries:
       - `type` : `String` — "image"
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image
*/
extension AssetsCatalogParser {
  public func stencilContext() -> [String: Any] {
    let catalogs = self.catalogs
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map { catalog -> [String: Any] in
        [
          "name": catalog.name,
          "assets": structure(entries: catalog.entries)
        ]
      }

    return [
      "catalogs": catalogs
    ]
  }

  private func structure(entries: [Catalog.Entry]) -> [[String: Any]] {
    return entries.map { entry in
      switch entry {
      case .group(let name, let items):
        return [
          "type": "group",
          "name": name,
          "items": structure(entries: items)
        ]
      case .color(let name, let value):
        return [
          "type": "color",
          "name": name,
          "value": value
        ]
      case .image(let name, let value):
        return [
          "type": "image",
          "name": name,
          "value": value
        ]
      }
    }
  }
}
