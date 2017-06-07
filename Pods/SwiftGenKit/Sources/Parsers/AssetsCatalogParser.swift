//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

struct Catalog {
  enum Entry {
    case group(name: String, items: [Entry])
    case image(name: String, value: String)
  }

  let name: String
  let entries: [Entry]
}

public final class AssetsCatalogParser: Parser {
  public enum Error: Swift.Error, CustomStringConvertible {
    case invalidFile

    public var description: String {
      switch self {
      case .invalidFile:
        return "error: File must be an asset catalog"
      }
    }
  }

  var catalogs = [Catalog]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    guard path.extension == AssetCatalog.extension else {
      throw AssetsCatalogParser.Error.invalidFile
    }

    let name = path.lastComponentWithoutExtension
    let entries = process(folder: path)

    catalogs += [Catalog(name: name, entries: entries)]
  }
}

// MARK: - Plist processing

private enum AssetCatalog {
  static let `extension` = "xcassets"

  enum Contents {
    static let path = "Contents.json"
    static let properties = "properties"
    static let providesNamespace = "provides-namespace"
  }

  enum Item {
    static let imageSet = "imageset"

    /**
     * This is a list of supported asset catalog item types, for now we just
     * support `image set`s. If you want to add support for new types, just add
     * it to this whitelist, and add the necessary code to the
     * `process(items:withPrefix:)` method.
     */
    static let supported = [imageSet]
  }
}

extension AssetsCatalogParser {
  /**
   This method recursively parses a directory structure, processing each folder (files are ignored).
  */
  func process(folder: Path, withPrefix prefix: String = "") -> [Catalog.Entry] {
    return (try? folder.children().flatMap {
      process(item: $0, withPrefix: prefix)
    }) ?? []
  }

  /**
   Each node in an asset catalog is either (there are more types, but we ignore those):
     - An imageset, which is essentially a group containing a list of files (the latter is ignored).
   
     - A group, containing sub items such as imagesets or groups. A group can provide a namespaced,
       which means that all the sub items will have to be prefixed with their parent's name.

         {
           "properties" : {
             "provides-namespace" : true
           }
         }

   - Parameter folder: The directory path to recursively process.
   - Parameter prefix: The prefix to prepend values with (from namespaced groups).
   - Returns: An array of processed Entry items (a catalog).
  */
  func process(item: Path, withPrefix prefix: String) -> Catalog.Entry? {
    guard item.isDirectory else { return nil }
    let type = item.extension ?? ""

    switch (type, AssetCatalog.Item.supported.contains(type)) {
    case (AssetCatalog.Item.imageSet, _):
      let name = item.lastComponentWithoutExtension
      return .image(name: name, value: "\(prefix)\(name)")
    case ("", _), (_, true):
      let filename = item.lastComponent
      let subPrefix = isNamespaced(path: item) ? "\(prefix)\(filename)/" : prefix

      return .group(
        name: filename,
        items: process(folder: item, withPrefix: subPrefix)
      )
    default:
      return nil
    }
  }

  private func isNamespaced(path: Path) -> Bool {
    if let contents = self.contents(for: path),
      let properties = contents[AssetCatalog.Contents.properties] as? [String: Any],
      let providesNamespace = properties[AssetCatalog.Contents.providesNamespace] as? Bool {
      return providesNamespace
    } else {
      return false
    }
  }

  private func contents(for path: Path) -> [String: Any]? {
    let contents = path + Path(AssetCatalog.Contents.path)

    guard let data = try? contents.read(),
      let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
        return nil
    }

    return json as? [String: Any]
  }
}
