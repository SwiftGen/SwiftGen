//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

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

// Mark: - Plist processing

private enum AssetCatalog: String {
  case children = "children"
  case filename = "filename"
  case providesNamespace = "provides-namespace"
  case root = "com.apple.actool.catalog-contents"
}

extension AssetsCatalogParser {
  static let ImageSet = "imageset"

  private func process(items: [[String: AnyObject]], prefix: String = "") {
    for item in items {
      let filename = item[AssetCatalog.filename.rawValue] as! NSString

      // this is a simple imageset
      if filename.pathExtension == AssetsCatalogParser.ImageSet {
        let imageName = (filename.lastPathComponent as NSString).stringByDeletingPathExtension
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

// Mark: - ACTool

extension AssetsCatalogParser {
  private func loadAssetCatalogContents(path: String) -> [[String: AnyObject]]? {
    let output = executeCommand("/usr/bin/env", args: [
      "xcrun",
      "actool",
      "--print-contents",
      path
      ])

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

  private func executeCommand(command: String, args: [String]) -> NSData {
    let task = NSTask()

    task.launchPath = command
    task.arguments = args

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    return data
  }
}
