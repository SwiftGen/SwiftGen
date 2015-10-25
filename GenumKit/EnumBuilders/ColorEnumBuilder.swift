//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation

public final class ColorEnumBuilder {
  var colors = [String:UInt32]()
  
  public init() {}
  
  public func addColorWithName(name: String, value: String) {
    addColorWithName(name, value: ColorEnumBuilder.parse(value))
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
  
  // MARK: - Private Helpers
  
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
