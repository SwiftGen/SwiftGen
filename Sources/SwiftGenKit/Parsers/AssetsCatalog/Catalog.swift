//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension AssetsCatalog {
  struct Catalog {
    let name: String
    let entries: [Entry]
  }
}

// MARK: - Parser

extension AssetsCatalog.Catalog {
  init(path: Path) {
    name = path.lastComponentWithoutExtension
    entries = AssetsCatalog.Catalog.process(folder: path)
  }

  /**
   This method recursively parses a directory structure, processing each folder (files are ignored).
   */
  static func process(folder: Path, withPrefix prefix: String = "") -> [AssetsCatalog.Entry] {
    return (try? folder.children().sorted(by: <).compactMap {
      AssetsCatalog.Entry(path: $0, withPrefix: prefix)
    }) ?? []
  }
}
