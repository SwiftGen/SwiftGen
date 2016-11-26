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
    let found = entries.contains {
      if case let .image(imageName, _) = $0, imageName == name {
      return true
    } else {
      return false
    }
  }

  guard !found else { return false }
  entries.append(Entry.image(name: name, value: name))

    return true
  }

  public func parseCatalog(at path: Path) {
    guard let items = loadAssetCatalog(at: path) else { return }

    // process recursively
    entries = process(items: items)
  }

  enum Entry {
  case image(name: String, value: String)
  case namespace(name: String, items: [Entry])
  }
}

// MARK: - Plist processing

private enum AssetCatalog {
  static let children = "children"
  static let filename = "filename"
  static let providesNamespace = "provides-namespace"
  static let root = "com.apple.actool.catalog-contents"
}

extension AssetsCatalogParser {
  static let imageSetExtension = "imageset"

  fileprivate func process(items: [[String: Any]], withPrefix prefix: String = "") -> [Entry] {
    var result = [Entry]()

    for item in items {
      guard let filename = item[AssetCatalog.filename] as? String else { continue }
      let path = Path(filename)

      if path.extension == AssetsCatalogParser.imageSetExtension {
        // this is a simple imageset
        let imageName = path.lastComponentWithoutExtension

        result += [.image(name: imageName, value: "\(prefix)\(imageName)")]
      } else {
        // this is a group/folder
        let children = item[AssetCatalog.children] as? [[String: Any]] ?? []

        if let providesNamespace = item[AssetCatalog.providesNamespace] as? Bool,
          providesNamespace {
          let processed = process(items: children, withPrefix: "\(prefix)\(filename)/")
          result += [.namespace(name: filename, items: processed)]
        } else {
          let processed = process(items: children, withPrefix: prefix)
          result += [.namespace(name: filename, items: processed)]
        }
      }
    }

    return result
  }
}

// MARK: - ACTool

extension AssetsCatalogParser {
  fileprivate func loadAssetCatalog(at path: Path) -> [[String: Any]]? {
    let command = Command("xcrun", arguments: "actool", "--print-contents", String(describing: path))
    let output = command.execute() as Data

    // try to parse plist
    guard let plist = try? PropertyListSerialization
        .propertyList(from: output, format: nil) else { return nil }

    // get first parsed catalog
    guard let contents = plist as? [String: Any],
      let catalogs = contents[AssetCatalog.root] as? [[String: Any]],
      let catalog = catalogs.first else { return nil }

    // get list of children
    guard let children = catalog[AssetCatalog.children] as? [[String: Any]] else { return nil }

    return children
  }
}
