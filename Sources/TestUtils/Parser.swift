//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
import SwiftGenKit

public extension SwiftGenKit.Parser {
  func searchAndParse(path: Path) throws {
    let filter = try Filter(pattern: Self.defaultFilter, options: Self.filterOptions)
    try searchAndParse(path: path, filter: filter)
  }

  func searchAndParse(paths: [Path]) throws {
    for path in paths {
      try searchAndParse(path: path)
    }
  }
}
