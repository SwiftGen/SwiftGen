#!/usr/bin/env xcrun swift -I ./lib -L ./lib

import Foundation
import StringIdentifier

var generatedCases = Set<String>()

func generateCase(name: String) {
  let caseName = name.asSwiftIdentifier()
  if generatedCases.contains(caseName) {
    print("    // case \(caseName) = \"\(name)\" /* Duplicate entry */\n")
  }
  else {
    print("    case \(caseName) = \"\(name)\"\n")
    generatedCases.insert(caseName)
  }
}

func generateEnum(scanDir: String) {
  print("enum ImageAsset : String {\n")

  if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(scanDir) {
    while let path = dirEnum.nextObject() as? String {
      if path.pathExtension == "imageset" {
        generateCase(path.lastPathComponent.stringByDeletingPathExtension)
      }
    }
  }

  print("\n")
  print("    var image: UIImage {\n")
  print("        return UIImage(named: self.rawValue)!\n")
  print("    }\n")

  print("}\n\n")

  print("extension UIImage {\n")
  print("    convenience init(asset: ImageAsset) {\n")
  print("        self.init(named: asset.rawValue)!\n")
  print("    }\n")
  print("}\n")
}


let scanDir = Process.argc < 2 ? "." : Process.arguments[1]
generateEnum(scanDir)

