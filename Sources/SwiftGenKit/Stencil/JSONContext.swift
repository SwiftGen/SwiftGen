//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/json.md
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
    let document = map(document: file.document)
    return [
      "name": file.name,
      "path": file.path.string,
      "document": document,
      "documents": [document] // For legacy/compatibility reasons; will be removed in 7.0
    ]
  }

  private func map(document: Any) -> [String: Any] {
    [
      "data": document,
      "metadata": Metadata.generate(for: document)
    ]
  }
}
