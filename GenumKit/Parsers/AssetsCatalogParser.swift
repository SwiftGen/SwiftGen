//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import PathKit

public final class AssetsCatalogParser {
  var imageNames = [String]()

  public init() {}

  @discardableResult
  public func addImage(named name: String) -> Bool {
    if imageNames.contains(name) {
      return false
    } else {
      imageNames.append(name)
      return true
    }
  }

  public func parseCatalog(at path: Path) {
    guard let items = loadAssetCatalog(at: path) else { return }
    // process recursively
    processCatalog(items: items)
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

  fileprivate func processCatalog(items: [[String: AnyObject]], withPrefix prefix: String = "") {
    for item in items {
      guard let filename = item[AssetCatalog.filename.rawValue] as? String else { continue }
      let path = Path(filename)

      if path.extension == AssetsCatalogParser.imageSetExtension {
        // this is a simple imageset
        let imageName = path.lastComponentWithoutExtension
        addImage(named: "\(prefix)\(imageName)")
      } else {
        // this is a group/folder
        let children = item[AssetCatalog.children.rawValue] as? [[String: AnyObject]] ?? []

        if let providesNamespace = item[AssetCatalog.providesNamespace.rawValue] as? NSNumber,
            providesNamespace.boolValue {
          processCatalog(items: children, withPrefix: "\(prefix)\(filename)/")
        } else {
          processCatalog(items: children, withPrefix: prefix)
        }
      }
    }
  }
}

// MARK: - ACTool

extension AssetsCatalogParser {
  fileprivate func loadAssetCatalog(at path: Path) -> [[String: AnyObject]]? {
    let command = Command("xcrun", arguments: "actool", "--print-contents", String(describing: path))
    let output = command.execute() as Data

    // try to parse plist
    guard let plist = try? PropertyListSerialization
        .propertyList(from: output, format: nil) else { return nil }

    // get first parsed catalog
    guard let contents = plist as? [String: AnyObject],
      let catalogs = contents[AssetCatalog.root.rawValue] as? [[String: AnyObject]],
      let catalog = catalogs.first else { return nil }

    // get list of children
    guard let children = catalog[AssetCatalog.children.rawValue] as? [[String: AnyObject]] else { return nil }

    return children
  }
}
