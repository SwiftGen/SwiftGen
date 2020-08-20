//
// SwiftGenKit
// Copyright © 2020 SwiftGen
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
  init(options: ParserOptionValues)

  static var allOptions: ParserOptionList { get }
  static var extensions: [String] { get }

  func parseFile(at path: Path) throws -> Colors.Palette
}

extension ColorsFileTypeParser {
  static var allOptions: ParserOptionList {
    []
  }
}

// MARK: - Private Helpers

extension Colors {
  static func parse(hex: String, key: String? = nil, path: Path, format: ColorFormat = .rgba) throws -> UInt32 {
    let scanner = Scanner(string: hex)

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
      throw ParserError.invalidHexColor(path: path, string: hex, key: key)
    }

    let len = hex.lengthOfBytes(using: .utf8) - prefixLen
    if len == 6 {
      // There were no alpha component, assume 0xff
      value = (value << 8) | 0xff
    } else if len == 8 && format == .argb {
      // When using argb, the alpha component should be moved to the back
      value = (value << 8) | (value >> 24)
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
