//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

extension Files.Parser {
  public func stencilContext() -> [String: Any] {
    let files = self.files
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map(map(file:))

    return [
      "files": files
    ]
  }

  private func map(file: Files.File) -> [String: Any] {
    [
      "name": file.name,
      "ext": file.ext ?? "",
      "path": file.path,
      "mimeType": file.mimeType
    ]
  }
}
