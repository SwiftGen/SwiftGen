//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

protocol AssetsCatalogEntry {
  var name: String { get }

  // Used for converting to stencil context
  var asDictionary: [String: Any] { get }
}

extension AssetsCatalog {
  enum Entry {
    struct Group: AssetsCatalogEntry {
      let name: String
      let isNamespaced: Bool
      let items: [AssetsCatalogEntry]
    }
    struct Item: AssetsCatalogEntry {
      let name: String
      let value: String
      let item: Constants.Item
    }
  }
}

// MARK: - Parser

enum Constants {
  fileprivate static let path = "Contents.json"
  fileprivate static let properties = "properties"
  fileprivate static let providesNamespace = "provides-namespace"

  ///
  /// This is a list of supported asset catalog item types, for now we just
  /// support `color set`s, `image set`s and `data set`s. If you want to add support for
  /// new types, just add it to this whitelist, and add the necessary code to
  /// the `process(folder:withPrefix:)` method.
  ///
  /// Use as reference:
  /// https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format
  ///
  enum Item: String, CaseIterable {
    case arResourceGroup = "arresourcegroup"
    case colorSet = "colorset"
    case dataSet = "dataset"
    case imageSet = "imageset"
  }
}

extension AssetsCatalog.Entry {
  ///
  /// Each node in an asset catalog is either (there are more types, but we ignore those):
  /// - An AR resource group, which can contain both AR reference images and objects.
  /// - A colorset, which is essentially a group containing a list of colors (the latter is ignored).
  /// - A dataset, which is essentially a group containing a list of files (the latter is ignored).
  /// - An imageset, which is essentially a group containing a list of files (the latter is ignored).
  /// - A group, containing sub items such as imagesets or groups. A group can provide a namespaced,
  ///   which means that all the sub items will have to be prefixed with their parent's name.
  ///
  ///     {
  ///       "properties" : {
  ///         "provides-namespace" : true
  ///       }
  ///     }
  ///
  /// - Parameter path: The directory path to recursively process.
  /// - Parameter prefix: The prefix to prepend values with (from namespaced groups).
  /// - Returns: An array of processed Entry items (a catalog).
  ///
  static func parse(path: Path, withPrefix prefix: String) -> AssetsCatalogEntry? {
    guard path.isDirectory else { return nil }
    let type = path.extension ?? ""

    if let item = Constants.Item(rawValue: type) {
      return AssetsCatalog.Entry.Item(path: path, item: item, withPrefix: prefix)
    } else if type.isEmpty {
      // this is a group, they can't have any '.' in their name
      let filename = path.lastComponent
      let isNamespaced = AssetsCatalog.Entry.isNamespaced(path: path)
      let subPrefix = isNamespaced ? "\(prefix)\(filename)/" : prefix

      return AssetsCatalog.Entry.Group(
        name: filename,
        isNamespaced: isNamespaced,
        items: AssetsCatalog.Catalog.process(folder: path, withPrefix: subPrefix)
      )
    } else {
      // Unknown extension
      return nil
    }
  }
}

// MARK: - Private Helpers

extension AssetsCatalog.Entry.Item {
  fileprivate init(path: Path, item: Constants.Item, withPrefix prefix: String) {
    self.name = path.lastComponentWithoutExtension
    self.value = "\(prefix)\(name)"
    self.item = item
  }
}

extension AssetsCatalog.Entry {
  fileprivate static func isNamespaced(path: Path) -> Bool {
    let metadata = self.metadata(for: path)

    if let properties = metadata[Constants.properties] as? [String: Any],
      let providesNamespace = properties[Constants.providesNamespace] as? Bool {
      return providesNamespace
    } else {
      return false
    }
  }

  private static func metadata(for path: Path) -> [String: Any] {
    let contentsFile = path + Path(Constants.path)

    guard let data = try? contentsFile.read(),
      let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
        return [:]
    }

    return (json as? [String: Any]) ?? [:]
  }
}
