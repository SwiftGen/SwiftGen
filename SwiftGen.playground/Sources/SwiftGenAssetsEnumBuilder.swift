import Foundation
//@import SwiftIdentifier
//@import SwiftGenIndentation

public class SwiftGenAssetsEnumBuilder {
    private var assetNames = [String]()
    
    public init() {}
    
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
    
    public func build(enumName enumName : String = "Asset", indentation indent : SwiftGenIndentation = .Spaces(4)) -> String {
        var text = "// AUTO-GENERATED FILE, DO NOT EDIT\n\n"
        let t = indent.string
        
        text += "import Foundation\n"
        text += "import UIKit\n"
        text += "\n"
        
        text += "extension UIImage {\n"

        text += "\(t)enum \(enumName) : String {\n"
        
        for name in assetNames {
            let caseName = name.asSwiftIdentifier(forbiddenChars: "_")
            text += "\(t)\(t)case \(caseName) = \"\(name)\"\n"
        }
        
        text += "\n"
        text += "\(t)\(t)var image: UIImage {\n"
        text += "\(t)\(t)\(t)return UIImage(named: self.rawValue)!\n"
        text += "\(t)\(t)}\n"
        
        text += "\(t)}\n\n"
        
        text += "\(t)convenience init?(asset: \(enumName)) {\n"
        text += "\(t)\(t)self.init(named: asset.rawValue)\n"
        text += "\(t)}\n"
        text += "}\n"
        
        return text
    }
}
