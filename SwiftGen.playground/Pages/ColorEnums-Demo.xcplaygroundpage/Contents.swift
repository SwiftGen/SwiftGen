import UIKit

extension UIColor {
    struct Cache {
        static var components = [String:UInt32]()
    }
    
    private static func parse(hexString: String) -> UInt32 {
        if let cached = Cache.components[hexString] {
            return cached
        }
        
        let scanner = NSScanner(string: hexString)
        let hasHash = scanner.scanString("#", intoString: nil)
        
        var value : UInt32 = 0
        scanner.scanHexInt(&value)
        
        let len = hexString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - (hasHash ? 1 : 0)
        if len == 6 {
            // There were no alpha component, assume 0xff
            value = (value << 8) | 0xff
        }
        
        Cache.components[hexString] = value
        return value
    }
    
    convenience init(hexString: String) {
        let value = UIColor.parse(hexString)
        self.init(rgbaValue: value)
    }
    
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension UIColor {
    enum Name : String {
        case ArticleTitle = "#33ff33"
        case ArticleBody = "339933"
        case Translucent = "ffffffcc"
    }

    convenience init(named name: Name) {
        self.init(hexString: name.rawValue)
    }
}

UIColor(named: .ArticleTitle)
UIColor(named: .ArticleBody)
UIColor(named: .Translucent)
let orange = UIColor(hexString: "#ffcc88")
let lightGreen = UIColor(rgbaValue: 0x00ff88ff)
