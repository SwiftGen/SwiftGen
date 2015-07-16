import Foundation
//@import SwiftIdentifier

public class SwiftGenAssetsEnumFactory {
    var enumName : String
    var assetNames = [String]()
    
    public init(enumName : String = "ImageAsset") {
        self.enumName = enumName
    }
    
    public func addAssetName(name: String) -> Bool {
        if assetNames.contains(name) {
            return false
        }
        else {
            assetNames.append(name)
            return true
        }
    }
    
    public func addAssetAtPath(path: String) -> Bool {
        let assetName = path.lastPathComponent.stringByDeletingPathExtension
        return self.addAssetName(assetName)
    }
    
    public func parseDirectory(path: String) {
        if let dirEnum = NSFileManager.defaultManager().enumeratorAtPath(path) {
            while let path = dirEnum.nextObject() as? String {
                if path.pathExtension == "imageset" {
                    self.addAssetAtPath(path)
                }
            }
        }
    }
    
    public func generate() -> String {
        var text = ""
        
        text += "enum \(enumName) : String {\n"
        
        for name in assetNames {
            let caseName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "    case \(caseName) = \"\(name)\"\n"
        }
        
        text += "\n"
        text += "    var image: UIImage {\n"
        text += "        return UIImage(named: self.rawValue)!\n"
        text += "    }\n"
        
        text += "}\n\n"
        
        text += "extension UIImage {\n"
        text += "    convenience init(asset: ImageAsset) {\n"
        text += "        self.init(named: asset.rawValue)!\n"
        text += "    }\n"
        text += "}\n"
        
        return text
    }
}
