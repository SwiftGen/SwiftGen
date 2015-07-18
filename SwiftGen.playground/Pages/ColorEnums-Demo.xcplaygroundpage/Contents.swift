import UIKit

extension UIColor {
    typealias ColorComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    struct Cache {
        static var components = [String:ColorComponents]()
    }
    
    private static func parseHex(hexString: String) -> ColorComponents {
        if let cached = Cache.components[hexString] {
            return cached
        }
        
        let scanner = NSScanner(string: hexString)
        let hasHash = scanner.scanString("#", intoString: nil)
        let len = hexString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - (hasHash ? 1 : 0)
        let hasAlpha = len == 4 || len == 8
        
        var hexValue : UInt32 = 0
        scanner.scanHexInt(&hexValue)
        
        var alpha = CGFloat(1.0)
        if hasAlpha {
            alpha = CGFloat(hexValue & 0xff) / 255.0
            hexValue = hexValue >> 8
        }
        
        let red   = CGFloat((hexValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00ff00) >>  8) / 255.0
        let blue  = CGFloat((hexValue & 0x0000ff)      ) / 255.0
        
        let comps = (red, green, blue, alpha)
        Cache.components[hexString] = comps
        return comps
    }
    
    convenience init(hexString: String) {
        let comps = UIColor.parseHex(hexString)
        self.init(red: comps.red, green: comps.green, blue: comps.blue, alpha: comps.alpha)
    }
}


extension UIColor {
    enum Name : String {
        case Blue = "#0000ff"
        case TranslucentRed = "ff0000cc"
        case White = "ffffff"
        case Translucent = "ffffffcc"
        
        var components : ColorComponents {
            return UIColor.parseHex(self.rawValue)
        }
        
        var color : UIColor {
            return UIColor(hexString: self.rawValue)
        }
    }

    static func colorNamed(name: Name) -> UIColor {
        return name.color
    }
}

UIColor.colorNamed(.Blue)
UIColor.colorNamed(.Translucent)
UIColor.Name.Translucent.color