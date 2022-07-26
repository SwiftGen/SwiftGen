//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/yaml.md
//

extension Yaml.Parser {
  public func stencilContext() -> [String: Any] {
    let files = self.files
      .sorted { $0.name.compare($1.name, options: .caseInsensitive) == .orderedAscending }
      .map(map(file:))

    return [
      "files": files
    ]
  }

  private func map(file: Yaml.File) -> [String: Any] {
    [
      "name": file.name,
      "path": file.path.string,
      "documents": file.documents.map(StencilContextLazyDocument.init)
    ]
  }
}
