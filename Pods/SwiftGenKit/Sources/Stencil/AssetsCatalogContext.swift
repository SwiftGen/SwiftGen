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
     - represents a folder and has the following entries:
       - `name` : `String` — name of the folder
       - `items`: `Array` — list of items, can be either folders or images
     - represents an image asset, and has the following entries:
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image
*/
extension AssetsCatalogParser {
  public func stencilContext(enumName: String = "Asset") -> [String: Any] {
    let images = catalogs.flatMap { justValues(entries: $1) }.sorted(by: <)
    let structured = catalogs.keys.sorted(by: <).map { name -> [String: Any] in
      return [
        "name": name,
        "assets": structure(entries: catalogs[name] ?? [])
      ]
    }

    return [
      "catalogs": structured,

      // NOTE: This is a deprecated variable
      "enumName": enumName,
      "images": images,
      "param": ["enumName": enumName]
    ]
  }

  private func justValues(entries: [Entry]) -> [String] {
    var result = [String]()

    for entry in entries {
      switch entry {
      case let .group(name: _, items: items):
        result += justValues(entries: items)
      case let .image(name: _, value: value):
        result += [value]
      }
    }

    return result
  }

  private func structure(entries: [Entry]) -> [[String: Any]] {
    return entries.map { entry in
      switch entry {
      case let .group(name: name, items: items):
        return [
          "name": name,
          "items": structure(entries: items)
        ]
      case let .image(name: name, value: value):
        return [
          "name": name,
          "value": value
        ]
      }
    }
  }
}
