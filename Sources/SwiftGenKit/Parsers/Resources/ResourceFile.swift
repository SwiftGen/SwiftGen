//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Resource {
  struct File {
    let name: String
    let ext: String?

    init(path: Path, relativeTo parent: Path? = nil) throws {
      guard path.exists else {
        throw ParserError.invalidFile(path: path, reason: "Unable to read file")
      }

      self.ext = path.extension
      let name = path.lastComponentWithoutExtension
      self.name = "\(name)\(self.ext?.uppercasedFirst() ?? "")"
    }
  }
}
