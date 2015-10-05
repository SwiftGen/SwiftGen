import Foundation
//@import SwiftIdentifier
//@import SwiftGenIndentation

public final class SwiftGenColorEnumBuilder {
    public init() {}
    
    public func addColorWithName(name: String, value: String) {
        addColorWithName(name, value: SwiftGenColorEnumBuilder.parse(value))
    }
    
    public func addColorWithName(name: String, value: UInt32) {
        colors[name] = value
    }
    
    // Text file expected to be:
    //  - One line per entry
    //  - Each line composed by the color name, then ":", then the color hex representation
    //  - Extra spaces will be skipped
    public func parseTextFile(path: String, separator: String = ":") throws {
        let content = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        let lines = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let ws = NSCharacterSet.whitespaceCharacterSet()
        for line in lines {
            let scanner = NSScanner(string: line)
            scanner.charactersToBeSkipped = ws
            var key: NSString?
            if scanner.scanUpToString(":", intoString: &key) {
                scanner.scanString(":", intoString: nil)
                var value: NSString?
                if scanner.scanUpToCharactersFromSet(ws, intoString: &value) {
                    addColorWithName(key! as String, value: value! as String)
                }
            }
        }
    }
    
    public func build(enumName enumName: String = "Name", generateStringInit stringInit: Bool = false, indentation indent: SwiftGenIndentation = .Spaces(4)) -> String {
        var text = "// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen\n\n"
        let t = indent.string
        text += commonCode(generateStringInit: stringInit, indentationString: t)
        
        guard !colors.isEmpty else {
            return text + "// No colors found"
        }
        
        text += "extension UIColor {\n"
        text += "    enum \(enumName) : UInt32 {\n"
        for (name, value) in colors {
            let caseName = name.asSwiftIdentifier()
            let hexValue = String(value, radix: 16)
            text += "        case \(caseName) = 0x\(hexValue)\n"
        }
        text += "    }\n"
        text += "\n"
        text += "    convenience init(named name: \(enumName)) {\n"
        text += "        self.init(rgbaValue: name.rawValue)\n"
        text += "    }\n"
        text += "}\n"
        
        return text
    }
    
    
    // MARK: - Private Helpers
    
    private var colors = [String:UInt32]()
    
    private func commonCode(generateStringInit stringInit: Bool, indentationString t: String) -> String {
        var text = ""
        
        text += "import UIKit\n"
        text += "\n"
        text += "extension UIColor {\n"
        if (stringInit) {
            text += "\(t)convenience init(hexString: String) {\n"
            text += "\(t)\(t)struct Cache {\n"
            text += "\(t)\(t)\(t)static var values = [String:UInt32]()\n"
            text += "\(t)\(t)}\n"
            text += "\n"
            text += "\(t)\(t)if let cached = Cache.values[hexString] {\n"
            text += "\(t)\(t)\(t)self.init(rgbaValue: cached)\n"
            text += "\(t)\(t)\(t)return\n"
            text += "\(t)\(t)}\n"
            text += "\(t)\(t)\n"
            text += "\(t)\(t)let scanner = NSScanner(string: hexString)\n"
            text += "\(t)\(t)let hasHash = scanner.scanString(\"#\", intoString: nil)\n"
            text += "\(t)\(t)\n"
            text += "\(t)\(t)var value : UInt32 = 0\n"
            text += "\(t)\(t)scanner.scanHexInt(&value)\n"
            text += "\(t)\(t)\n"
            text += "\(t)\(t)let len = hexString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - (hasHash ? 1 : 0)\n"
            text += "\(t)\(t)if len == 6 {\n"
            text += "\(t)\(t)\(t)// There were no alpha component, assume 0xff\n"
            text += "\(t)\(t)\(t)value = (value << 8) | 0xff\n"
            text += "\(t)\(t)}\n"
            text += "\(t)\(t)\n"
            text += "\(t)\(t)Cache.values[hexString] = value\n"
            text += "\(t)\(t)\n"
            text += "\(t)\(t)self.init(rgbaValue: value)\n"
            text += "\(t)}\n"
            text += "\(t)\n"
        }
        text += "\(t)convenience init(rgbaValue: UInt32) {\n"
        text += "\(t)\(t)let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0\n"
        text += "\(t)\(t)let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0\n"
        text += "\(t)\(t)let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0\n"
        text += "\(t)\(t)let alpha = CGFloat((rgbaValue\(t)  ) & 0xff) / 255.0\n"
        text += "\(t)\(t)\n"
        text += "\(t)\(t)self.init(red: red, green: green, blue: blue, alpha: alpha)\n"
        text += "\(t)}\n"
        text += "}\n\n"
        
        return text
    }
    
    private static func parse(hexString: String) -> UInt32 {
        let scanner = NSScanner(string: hexString)
        let prefixLen: Int
        if scanner.scanString("#", intoString: nil) {
            prefixLen = 1
        } else if scanner.scanString("0x", intoString: nil) {
            prefixLen = 2
        } else {
            prefixLen = 0
        }
        
        var value : UInt32 = 0
        scanner.scanHexInt(&value)
        
        let len = hexString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) - prefixLen
        if len == 6 {
            // There were no alpha component, assume 0xff
            value = (value << 8) | 0xff
        }
        
        return value
    }
}
