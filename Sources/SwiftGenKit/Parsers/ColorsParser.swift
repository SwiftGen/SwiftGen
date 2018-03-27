//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum ColorsParserError: Error, CustomStringConvertible {
  case invalidHexColor(path: Path, string: String, key: String?)
  case invalidFile(path: Path, reason: String)
  case unsupportedFileType(path: Path, supported: [String])

  public var description: String {
    switch self {
    case let .invalidHexColor(path, string, key):
      let keyInfo = key.flatMap { " for key \"\($0)\"" } ?? ""
      return "error: Invalid hex color \"\(string)\" found\(keyInfo) (\(path))."
    case let .invalidFile(path, reason):
      return "error: Unable to parse file at \(path). \(reason)"
    case let .unsupportedFileType(path, supported):
      return "error: Unsupported file type for \(path). " +
        "The supported file types are: \(supported.joined(separator: ", "))"
    }
  }
}

struct Palette {
  let name: String
  let colors: [String: UInt32]
}

protocol ColorsFileTypeParser: class {
  static var extensions: [String] { get }

  init()
  func parseFile(at path: Path) throws -> Palette
}

public final class ColorsParser: Parser {
  private var parsers = [String: ColorsFileTypeParser.Type]()
  var palettes = [Palette]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler

    register(parser: ColorsCLRFileParser.self)
    register(parser: ColorsJSONFileParser.self)
    register(parser: ColorsTextFileParser.self)
    register(parser: ColorsXMLFileParser.self)
  }

  public func parse(path: Path) throws {
    guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
      throw ColorsParserError.unsupportedFileType(path: path, supported: Array(parsers.keys))
    }

    let parser = parserType.init()
    let palette = try parser.parseFile(at: path)

    palettes += [palette]
  }

  func register(parser: ColorsFileTypeParser.Type) {
    for ext in parser.extensions {
      if let old = parsers[ext] {
        warningHandler?("""
          error: Parser \(parser) tried to register the file type '\(ext)' already \
          registered by \(old).
          """,
          #file,
          #line)
      }
      parsers[ext] = parser
    }
  }
}

// MARK: - Private Helpers

func parse(hex hexString: String, key: String? = nil, path: Path) throws -> UInt32 {
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
    throw ColorsParserError.invalidHexColor(path: path, string: hexString, key: key)
  }

  let len = hexString.lengthOfBytes(using: .utf8) - prefixLen
  if len == 6 {
    // There were no alpha component, assume 0xff
    value = (value << 8) | 0xff
  }

  return value
}

extension NSColor {
  var rgbColor: NSColor? {
    guard colorSpace.colorSpaceModel != .RGB else { return self }

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
