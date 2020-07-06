//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import Yams

public extension Yaml {
  struct File {
    let path: Path
    let name: String
    let documents: [Any]

    init(path: Path, relativeTo parent: Path? = nil) throws {
      guard let string: String = try? path.read() else {
        throw ParserError.invalidFile(path: path, reason: "Unable to read file")
      }

      self.path = parent.flatMap { path.relative(to: $0) } ?? path
      self.name = path.lastComponentWithoutExtension

      do {
        var items = try Yams.load_all(yaml: string)

        var result: [Any] = []
        while let item = items.next() {
          result.append(item)
        }
        self.documents = result

        if let error = items.error {
          throw error
        }
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: error.localizedDescription)
      }
    }
  }
}
