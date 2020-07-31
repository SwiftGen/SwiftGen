//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/plist.md
//

extension Plist.Parser {
  public func stencilContext() -> [String: Any] {
    let files = self.files
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map(map(file:))

    return [
      "files": files
    ]
  }

  private func map(file: Plist.File) -> [String: Any] {
    let document = StencilContextLazyDocument(data: file.document)

    return [
      "name": file.name,
      "path": file.path.string,
      "document": document,
      // Deprecated: remains for legacy/compatibility reasons; will be removed in 7.0
      "documents": [document]
    ]
  }
}
