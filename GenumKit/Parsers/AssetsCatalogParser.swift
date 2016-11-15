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

  public func addImageName(name: String) -> Bool {
    if imageNames.contains(name) {
      return false
    } else {
      imageNames.append(name)
      return true
    }
  }

  public func parseCatalog(path: String) {
    guard let items = loadAssetCatalogContents(path) else { return }

    // process recursively
    process(items)
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

  private func process(items: [[String: AnyObject]], prefix: String = "") {
    for item in items {
      guard let filename = item[AssetCatalog.filename.rawValue] as? String else { continue }
      let path = Path(filename)

      if path.`extension` == AssetsCatalogParser.ImageSetExtension {
        // this is a simple imageset
        let imageName = path.lastComponentWithoutExtension
        addImageName("\(prefix)\(imageName)")
      } else {
        // this is a group/folder
        let children = item[AssetCatalog.children.rawValue] as? [[String: AnyObject]] ?? []

        if let providesNamespace = item[AssetCatalog.providesNamespace.rawValue] as? NSNumber where providesNamespace.boolValue {
          process(children, prefix: "\(prefix)\(filename)/")
        } else {
          process(children, prefix: prefix)
        }
      }
    }
  }
}

// MARK: - ACTool

extension AssetsCatalogParser {
  private func loadAssetCatalogContents(path: String) -> [[String: AnyObject]]? {
    let command = Command("xcrun", arguments: "actool", "--print-contents", path)
    let output = command.execute()

    // try to parse plist
    guard let plist = try? NSPropertyListSerialization.propertyListWithData(output, options: .Immutable, format: nil) else { return nil }

    // get first parsed catalog
    guard let contents = plist as? [String: AnyObject],
      let catalogs = contents[AssetCatalog.root.rawValue] as? [[String: AnyObject]],
      let catalog = catalogs.first else { return nil }

    // get list of children
    guard let children = catalog[AssetCatalog.children.rawValue] as? [[String: AnyObject]] else { return nil }

    return children
  }
}
