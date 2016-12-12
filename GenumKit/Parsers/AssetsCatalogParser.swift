//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import PathKit

public final class AssetsCatalogParser {
  typealias Catalog = [Entry]
  var catalogs = [String: Catalog]()

  public init() {}

  public func parseCatalog(at path: Path) {
    guard let items = loadAssetCatalog(at: path) else { return }
    let name = path.lastComponentWithoutExtension

    // process recursively (and append if already exists)
    var catalog = catalogs[name] ?? Catalog()
    catalog += process(items: items)
    catalogs[name] = catalog
  }

  enum Entry {
  case group(name: String, items: [Entry])
  case image(name: String, value: String)
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

  /**
   This method recursively parses a tree of nodes (similar to a directory structure)
   resulting from the `actool` utility.
   
   Each node in an asset catalog is either (there are more types, but we ignore those):
   - An imageset, which is essentially a group containing a list of files (the latter is ignored).

         <dict>
           <key>children</key>
           <array>
             ...actual file items here (for example the 1x, 2x and 3x images)...
           </array>
           <key>filename</key>
           <string>Tomato.imageset</string>
         </dict>

   - A group, containing sub items such as imagesets or groups. A group can provide a namespaced,
     which means that all the sub items will have to be prefixed with their parent's name.

         <dict>
           <key>children</key>
           <array>
             ...sub items such as groups or imagesets...
           </array>
           <key>filename</key>
           <string>Round</string>
           <key>provides-namespace</key>
           <true/>
         </dict>
   
   - Parameter items: The array of items to recursively process.
   - Parameter prefix: The prefix to prepend values with (from namespaced groups).
   - Returns: An array of processed Entry items (a catalog).
  */
  fileprivate func process(items: [[String: Any]], withPrefix prefix: String = "") -> Catalog {
    var result = Catalog()

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
          result += [.group(name: filename, items: processed)]
        } else {
          let processed = process(items: children, withPrefix: prefix)
          result += [.group(name: filename, items: processed)]
        }
      }
    }

    return result
  }
}

// MARK: - ACTool

extension AssetsCatalogParser {
  /**
   Try to parse an asset catalog using the `actool` utilty. While it supports parsing
   multiple catalogs at once, we only use it to parse one at a time.

   The output of the utility is a Plist and should be similar to this:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>com.apple.actool.catalog-contents</key>
     <array>
       <dict>
         <key>children</key>
         <array>
           ...
         </array>
         <key>filename</key>
         <string>Images.xcassets</string>
       </dict>
     </array>
   </dict>
   </plist>
   ```
   
   - Parameter path: The path to the catalog to parse.
   - Returns: An array of dictionaries, representing the tree of nodes in the catalog.
  */
  fileprivate func loadAssetCatalog(at path: Path) -> [[String: Any]]? {
    let command = Command("xcrun", arguments: "actool", "--print-contents", path.description)
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
