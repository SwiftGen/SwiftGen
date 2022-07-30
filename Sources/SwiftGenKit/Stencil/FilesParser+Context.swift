//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Files.Parser {
  public func stencilContext() -> [String: Any] {
    let groups: [[String: Any]] = files
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { name, files in
        var contents = structure(entries: files, usingMapper: map(file:))
        contents["name"] = name
        return contents
      }

    return ["groups": groups]
  }

  private func map(file: Files.File) -> [String: Any] {
    [
      "name": file.name,
      "ext": file.ext ?? "",
      "path": file.path.joined(separator: Path.separator),
      "mimeType": file.mimeType
    ]
  }

  typealias Mapper = (_ file: Files.File) -> [String: Any]
  private func structure(
    entries: [Files.File],
    atKeyPath keyPath: [String] = [],
    usingMapper mapper: @escaping Mapper
  ) -> [String: Any] {
    var structuredFiles: [String: Any] = [:]
    if let name = keyPath.last {
      structuredFiles["name"] = name
    }

    // Collect the files at this level
    let files = entries
      .filter { $0.path == keyPath }
      .sorted { $0.name.lowercased() < $1.name.lowercased() }
      .map { mapper($0) }

    if !files.isEmpty {
      structuredFiles["files"] = files
    }

    // Collect files deeper in the hierarchy, group them by directory name,
    // sort and structure those files
    let childEntries = entries.filter { $0.path.count > keyPath.count }
    let children = Dictionary(grouping: childEntries) { $0.path[keyPath.count] }
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { name, entries in
        structure(entries: entries, atKeyPath: keyPath + [name], usingMapper: mapper)
      }

    if !children.isEmpty {
      structuredFiles["directories"] = children
    }

    return structuredFiles
  }
}
