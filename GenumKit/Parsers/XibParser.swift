//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public final class XibParser {
  var nibNames = [String]()
  
  public init() {}
  
  public func addNibName(name: String) -> Bool {
    if nibNames.contains(name) {
      return false
    } else {
      nibNames.append(name)
      return true
    }
  }
  
  public func parseDirectory(path: String) {
    if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
      while let path = dirEnum.nextObject() as? NSString {
        if path.pathExtension == "xib" {
          let nibName = (path.lastPathComponent as NSString).stringByDeletingPathExtension
          self.addNibName(nibName)
        }
      }
    }
  }
}
