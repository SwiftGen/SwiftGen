//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/Json.md
//

extension JSON.Parser {
  public func stencilContext() -> [String: Any] {
    let files = self.files
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map(map(file:))

    return [
      "files": files
    ]
  }

  private func map(file: JSON.File) -> [String: Any] {
    [
      "name": file.name,
      "path": file.path.string,
      "documents": [map(document: file.document)]
    ]
  }

  private func map(document: Any) -> [String: Any] {
    [
      "data": document,
      "metadata": Metadata.generate(for: document)
    ]
  }
}
