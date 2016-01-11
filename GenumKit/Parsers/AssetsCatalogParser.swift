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

  public func parseDirectory(path: String) {
    if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
      while let path = dirEnum.nextObject() as? NSString {
        if path.pathExtension == "imageset" {
          let imageName = (path.lastPathComponent as NSString).stringByDeletingPathExtension
          self.addImageName(imageName)
        }
      }
    }
  }
}
