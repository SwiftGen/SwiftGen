//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public extension JSON {
  struct File {
    let path: Path
    let name: String
    let document: Any

    init(path: Path, relativeTo parent: Path? = nil) throws {
      guard let data: Data = try? path.read() else {
        throw ParserError.invalidFile(path: path, reason: "Unable to read file")
      }

      self.path = parent.flatMap { path.relative(to: $0) } ?? path
      self.name = path.lastComponentWithoutExtension

      do {
        self.document = try JSONSerialization.jsonObject(with: data)
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: error.localizedDescription)
      }
    }
  }
}
