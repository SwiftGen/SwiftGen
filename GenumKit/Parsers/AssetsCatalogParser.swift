//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import PathKit

public final class AssetsCatalogParser {
  var entries = [Entry]()

  public init() {}

  @discardableResult
  public func addImage(named name: String) -> Bool {
    if (entries.contains { $0.name == name }) {
      return false
    } else {
      entries.append(Entry(name: name, value: name))
      return true
    }
  }

  public func parseCatalog(at path: String) {
    guard let items = loadAssetCatalog(at: path) else { return }

    // process recursively
    entries = process(items: items)
  }

  struct Entry {
    var name: String
    var value: String
    var items: [Entry]?

    init(name: String, value: String) {
      self.name = name
      self.value = value
    }

    init(name: String, items: [Entry]) {
      self.name = name
      self.items = items
      self.value = ""
    }
  }
}

// MARK: - Plist processing

private enum AssetCatalog: String {
  case children = "children"
  case filename = "filename"
  case providesNamespace = "provides-namespace"
  case root = "com.apple.actool.catalog-contents"
}

extension AssetsCatalogParser {
  static let imageSetExtension = "imageset"

  fileprivate func process(items: [[String: Any]], withPrefix prefix: String = "") -> [Entry] {
    var result = [Entry]()

    for item in items {
      guard let filename = item[AssetCatalog.filename.rawValue] as? String else { continue }
      let path = Path(filename)

      if path.`extension` == AssetsCatalogParser.imageSetExtension {
        // this is a simple imageset
        let imageName = path.lastComponentWithoutExtension

        result += [Entry(name: imageName, value: "\(prefix)\(imageName)")]
      } else {
        // this is a group/folder
        let children = item[AssetCatalog.children.rawValue] as? [[String: Any]] ?? []

        if let providesNamespace = item[AssetCatalog.providesNamespace.rawValue] as? NSNumber,
          providesNamespace.boolValue {
          let processed = process(items: children, withPrefix: "\(prefix)\(filename)/")
          result += [Entry(name: filename, items: processed)]
        } else {
          let processed = process(items: children, withPrefix: prefix)
          result += [Entry(name: filename, items: processed)]
        }
      }
    }

    return result
  }
}

// MARK: - ACTool

extension AssetsCatalogParser {
  fileprivate func loadAssetCatalog(at path: String) -> [[String: Any]]? {
    let command = Command("xcrun", arguments: "actool", "--print-contents", path)
    let output = command.execute() as Data

    // try to parse plist
    guard let plist = try? PropertyListSerialization
        .propertyList(from: output, format: nil) else { return nil }

    // get first parsed catalog
    guard let contents = plist as? [String: Any],
      let catalogs = contents[AssetCatalog.root.rawValue] as? [[String: Any]],
      let catalog = catalogs.first else { return nil }

    // get list of children
    guard let children = catalog[AssetCatalog.children.rawValue] as? [[String: Any]] else { return nil }

    return children
  }
}
