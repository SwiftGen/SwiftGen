//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit
import Foundation
import PathKit

extension Colors {
  struct Palette {
    let name: String
    let colors: [String: UInt32]
  }
}

protocol ColorsFileTypeParser: AnyObject {
  init(options: [String: Any])

  static var allOptions: ParserOptionList { get }
  static var extensions: [String] { get }

  func parseFile(at path: Path) throws -> Colors.Palette
}

// MARK: - Private Helpers

extension Colors {
  static func parse(hex hexString: String, key: String? = nil, path: Path) throws -> UInt32 {
    let scanner = Scanner(string: hexString)

    let prefixLen: Int
    if scanner.scanString("#", into: nil) {
      prefixLen = 1
    } else if scanner.scanString("0x", into: nil) {
      prefixLen = 2
    } else {
      prefixLen = 0
    }

    var value: UInt32 = 0
    guard scanner.scanHexInt32(&value) else {
      throw ParserError.invalidHexColor(path: path, string: hexString, key: key)
    }

    let len = hexString.lengthOfBytes(using: .utf8) - prefixLen
    if len == 6 {
      // There were no alpha component, assume 0xff
      value = (value << 8) | 0xff
    }

    return value
  }
}

extension NSColor {
  var rgbColor: NSColor? {
    guard colorSpace.colorSpaceModel != .rgb else { return self }

    return usingColorSpaceName(.calibratedRGB)
  }

  var hexValue: UInt32 {
    guard let rgb = rgbColor else { return 0 }

    let hexRed = UInt32(round(rgb.redComponent * 0xFF)) << 24
    let hexGreen = UInt32(round(rgb.greenComponent * 0xFF)) << 16
    let hexBlue = UInt32(round(rgb.blueComponent * 0xFF)) << 8
    let hexAlpha = UInt32(round(rgb.alphaComponent * 0xFF))

    return hexRed | hexGreen | hexBlue | hexAlpha
  }
}
