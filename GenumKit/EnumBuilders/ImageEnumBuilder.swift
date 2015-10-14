//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public final class ImageEnumBuilder {
    private var imageNames = [String]()
    
    public init() {}
    
    public func addImageName(name: String) -> Bool {
        if imageNames.contains(name) {
            return false
        }
        else {
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
    
    public func build(enumName enumName : String = "Asset", indentation indent : Indentation = .Spaces(4)) -> String {
        var text = "// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen\n\n"
        let t = indent.string
        
        text += "import Foundation\n"
        text += "import UIKit\n"
        text += "\n"
        
        guard !imageNames.isEmpty else {
            return text + "// No image found\n"
        }
        
        text += "extension UIImage {\n"

        text += "\(t)enum \(enumName) : String {\n"
        
        for name in imageNames {
            let caseName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "\(t)\(t)case \(caseName) = \"\(name)\"\n"
        }
        
        text += "\n"
        text += "\(t)\(t)var image: UIImage {\n"
        text += "\(t)\(t)\(t)return UIImage(asset: self)\n"
        text += "\(t)\(t)}\n"
        
        text += "\(t)}\n\n"
        
        text += "\(t)convenience init!(asset: \(enumName)) {\n"
        text += "\(t)\(t)self.init(named: asset.rawValue)\n"
        text += "\(t)}\n"
        text += "}\n"
        
        return text
    }
}
