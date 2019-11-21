//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Resource {
  struct File {
    let path: Path
    let name: String
    let ext: String

    init(path: Path, relativeTo parent: Path? = nil) throws {
      guard path.exists else {
        throw ParserError.invalidFile(path: path, reason: "Unable to read file")
      }

      self.path = parent.flatMap { path.relative(to: $0) } ?? path
      self.ext = path.extension ?? ""
      let name = path.lastComponentWithoutExtension
      self.name = "\(name)\(self.ext.uppercasedFirst())"
    }
  }
}
