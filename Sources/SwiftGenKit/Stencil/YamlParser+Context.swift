//
// SwiftGenKit
// Copyright © 2019 SwiftGen
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
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map(map(file:))

    return [
      "files": files
    ]
  }

  private func map(file: Yaml.File) -> [String: Any] {
    [
      "name": file.name,
      "path": file.path.string,
      "documents": file.documents.map(Document.init)
    ]
  }

  // We need to use a `NSObject` subclass + `@objc` to make Stencil use KVC to access this property,
  // and thus allow that `lazy var` not to be resolved by Stencil too early or before it's accessed in the template
  final class Document: NSObject {
    @objc let data: Any
    @objc private(set) lazy var metadata: [String: Any] = Metadata.generate(for: data)

    init(data: Any) {
      self.data = data
      super.init()
    }
  }
}
