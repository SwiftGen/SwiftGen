//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Catalog {
  enum Entry {
    case group(name: String, items: [Entry])
    case color(name: String, value: String)
    case image(name: String, value: String)
  }
}

// MARK: - Parser

private enum AssetCatalog {
  static let path = "Contents.json"
  static let properties = "properties"
  static let providesNamespace = "provides-namespace"

  /**
   * This is a list of supported asset catalog item types, for now we just
   * support `image set`s and `color set`s. If you want to add support for
   * new types, just add it to this whitelist, and add the necessary code to
   * the `process(items:withPrefix:)` method.
   *
   * Use as reference:
   * https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format
   */
  enum Item: String {
    case colorSet = "colorset"
    case imageSet = "imageset"
  }
}

extension Catalog.Entry {
  /**
   Each node in an asset catalog is either (there are more types, but we ignore those):
     - A colorset, which is essentially a group containing a list of colors (the latter is ignored).
     - An imageset, which is essentially a group containing a list of files (the latter is ignored).
     - A group, containing sub items such as imagesets or groups. A group can provide a namespaced,
       which means that all the sub items will have to be prefixed with their parent's name.

         {
           "properties" : {
             "provides-namespace" : true
           }
         }

   - Parameter path: The directory path to recursively process.
   - Parameter prefix: The prefix to prepend values with (from namespaced groups).
   - Returns: An array of processed Entry items (a catalog).
   */
  init?(path: Path, withPrefix prefix: String) {
    guard path.isDirectory else { return nil }
    let type = path.extension ?? ""

    switch AssetCatalog.Item(rawValue: type) {
    case .colorSet?:
      let name = path.lastComponentWithoutExtension
      self = .color(name: name, value: "\(prefix)\(name)")
    case .imageSet?:
      let name = path.lastComponentWithoutExtension
      self = .image(name: name, value: "\(prefix)\(name)")
    case nil:
      guard type.isEmpty else { return nil }
      let filename = path.lastComponent
      let subPrefix = Catalog.Entry.isNamespaced(path: path) ? "\(prefix)\(filename)/" : prefix

      self = .group(
        name: filename,
        items: Catalog.process(folder: path, withPrefix: subPrefix)
      )
    }
  }
}

// MARK: - Private Helpers

extension Catalog.Entry {
  private static func isNamespaced(path: Path) -> Bool {
    let metadata = self.metadata(for: path)

    if let properties = metadata[AssetCatalog.properties] as? [String: Any],
      let providesNamespace = properties[AssetCatalog.providesNamespace] as? Bool {
      return providesNamespace
    } else {
      return false
    }
  }

  private static func metadata(for path: Path) -> [String: Any] {
    let contentsFile = path + Path(AssetCatalog.path)

    guard let data = try? contentsFile.read(),
      let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
        return [:]
    }

    return (json as? [String: Any]) ?? [:]
  }
}
