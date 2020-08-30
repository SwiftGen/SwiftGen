//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Files.Parser {
  public func stencilContext() -> [String: Any] {
    let files = self.files
      .sorted { $0.name.lowercased() < $1.name.lowercased() }

    if options[Files.Option.compact] && !files.isEmpty && !files[0].path.isEmpty {
      // Find a common ancestor of all files to reduce nested enums
      var common = [files[0].path[0]]
      loop: repeat {
        for index in 0..<files.count {
          if !files[index].path.starts(with: common) {
            common.removeLast()
            break loop
          }
        }
        if files[0].path.count > common.count {
          common += [files[0].path[common.count]]
        } else {
          break loop
        }
      } while (true)
      return structure(entries: files, atKeyPath: common, usingMapper: map(file:))
    } else {
      return structure(entries: files, usingMapper: map(file:))
    }
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
