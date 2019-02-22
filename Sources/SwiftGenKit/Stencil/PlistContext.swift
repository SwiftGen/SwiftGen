//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/Plist.md
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
    return [
      "name": file.name,
      "path": file.path.string,
      // Note: we wrap the document into a single-value array so that the structure of
      // this context is identical to the one produced by the YAML parser
      "documents": [map(document: file.document)]
    ]
  }

  private func map(document: Any) -> [String: Any] {
    return [
      "data": document,
      "metadata": Metadata.generate(for: document)
    ]
  }
}
