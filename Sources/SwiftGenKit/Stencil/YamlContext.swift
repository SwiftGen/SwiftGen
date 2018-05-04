//
//  YamlContext.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

/*
 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `documents`: `Array` — List of documents. JSON files will only have 1 document
       - `data`: `Any` — The contents of the document
 */
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
    return [
      "name": file.name,
      "path": file.path.string,
      "documents": file.documents.map(map(document:))
    ]
  }

  private func map(document: Any) -> [String: Any] {
    return [
      "data": document
    ]
  }
}
