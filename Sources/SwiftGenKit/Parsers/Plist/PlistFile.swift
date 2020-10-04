//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Plist {
  struct File {
    let path: Path
    let name: String
    let document: Any

    init(path: Path, relativeTo parent: Path? = nil) throws {
      self.path = parent.flatMap { path.relative(to: $0) } ?? path
      self.name = path.lastComponentWithoutExtension

      let content: Any?
      do {
        let decoder = PropertyListDecoder()
        let data = try Data(contentsOf: path.url)
        content = try decoder.decode(AnyCodable.self, from: data).value
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: error.localizedDescription)
      }

      if let doc = content as? [String: Any] {
        self.document = doc
      } else if let doc = content as? [Any] {
        self.document = doc
      } else {
        throw ParserError.invalidFile(path: path, reason: "Unknown plist contents")
      }
    }
  }
}
