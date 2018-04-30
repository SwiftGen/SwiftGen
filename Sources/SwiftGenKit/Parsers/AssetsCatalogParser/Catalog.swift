//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

struct Catalog {
  let name: String
  let entries: [Entry]
}

// MARK: - Parser

extension Catalog {
  init(path: Path) {
    name = path.lastComponentWithoutExtension
    entries = Catalog.process(folder: path)
  }

  /**
   This method recursively parses a directory structure, processing each folder (files are ignored).
   */
  static func process(folder: Path, withPrefix prefix: String = "") -> [Catalog.Entry] {
    return (try? folder.children().sorted(by: <).compactMap {
      Entry(path: $0, withPrefix: prefix)
    }) ?? []
  }
}
