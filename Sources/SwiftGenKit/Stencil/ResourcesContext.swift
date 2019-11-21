//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

extension Resource.Parser {
  public func stencilContext() -> [String : Any] {
    let files = self.files
      .sorted { lhs, rhs in lhs.name < rhs.name }

    return [
      "files": files
    ]
  }

  private func map(file: Resource.File) -> [String: Any] {
    return [
      "name": file.name,
      "path": file.path,
      "extension": file.ext ?? ""
    ]
  }
}
