//
//  PlistContext.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import Yams

/*
 These extensions are needed otherwise Yams can't serialize Plist files (which
 internally still use Objective-C types)
 */

extension NSDictionary: NodeRepresentable {
  public func represented() throws -> Node {
    guard let dictionary = self as? [AnyHashable: Any] else { fatalError("bla") }
    return try dictionary.represented()
  }
}

extension NSArray: NodeRepresentable {
  public func represented() throws -> Node {
    guard let array = self as? [Any] else { fatalError("bla") }
    return try array.represented()
  }
}

/*
 - `files`: `Array` — List of files
    - `name`: `String` — Name of the file (without extension)
    - `path` : `String` — the path to the file, relative to the folder being scanned
    - `documents`: `Array` — List of documents. Plist files will only have 1 document
       - `data`: `Any` — The contents of the document
 */
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
      "data": document
    ]
  }
}
