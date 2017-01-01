//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Foundation
import AppKit.NSColor
import PathKit

public protocol ColorsFileParser {
  var colors: [String: UInt32] { get }
}

public enum ColorsParserError: Error, CustomStringConvertible {
  case invalidHexColor(string: String, key: String?)
  case invalidFile(reason: String)

  public var description: String {
    switch self {
    case .invalidHexColor(string: let string, key: let key):
      let keyInfo = key.flatMap { k in " for key \"\(k)\"" } ?? ""
      return "error: Invalid hex color \"\(string)\" found\(keyInfo)."
    case .invalidFile(reason: let reason):
      return "error: Unable to parse file. \(reason)"
    }
  }
}

// MARK: - Private Helpers

fileprivate func parse(hex hexString: String, key: String? = nil) throws -> UInt32 {
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
    throw ColorsParserError.invalidHexColor(string: hexString, key: key)
  }

  let len = hexString.lengthOfBytes(using: .utf8) - prefixLen
  if len == 6 {
    // There were no alpha component, assume 0xff
    value = (value << 8) | 0xff
  }

  return value
}

// MARK: - Text File Parser

public final class ColorsTextFileParser: ColorsFileParser {
  public private(set) var colors = [String: UInt32]()

  public init() {}

  public func addColor(named name: String, value: String) throws {
    try addColor(named: name, value: parse(hex: value, key: name))
  }

  public func addColor(named name: String, value: UInt32) {
    colors[name] = value
  }

  public func keyValueDict(from path: Path, withSeperator seperator: String = ":") throws -> [String:String] {

    let content = try path.read(.utf8)
    let lines = content.components(separatedBy: CharacterSet.newlines)
    let whitespace = CharacterSet.whitespaces
    let skippedCharacters = NSMutableCharacterSet()
    skippedCharacters.formUnion(with: whitespace)
    skippedCharacters.formUnion(with: skippedCharacters as CharacterSet)

    var dict: [String: String] = [:]
    for line in lines {
      let scanner = Scanner(string: line)
      scanner.charactersToBeSkipped = skippedCharacters as CharacterSet

      var key: NSString?
      var value: NSString?
      guard scanner.scanUpTo(seperator, into: &key) &&
        scanner.scanString(seperator, into: nil) &&
        scanner.scanUpToCharacters(from: whitespace, into: &value) else {
          continue
      }

      if let key: String = key?.trimmingCharacters(in: whitespace),
        let value: String = value?.trimmingCharacters(in: whitespace) {
        dict[key] = value
      }
    }

    return dict
  }

  private func colorValue(forKey key: String, onDict dict: [String: String]) -> String {
    var currentKey = key
    var stringValue: String = ""
    while let value = dict[currentKey]?.trimmingCharacters(in: CharacterSet.whitespaces) {
      currentKey = value
      stringValue = value
    }

    return stringValue
  }

  // Text file expected to be:
  //  - One line per entry
  //  - Each line composed by the color name, then ":", then the color hex representation
  //  - Extra spaces will be skipped
  public func parseFile(at path: Path, separator: String = ":") throws {
    do {
      let dict = try keyValueDict(from: path, withSeperator: separator)
      for key in dict.keys {
        try addColor(named: key, value: colorValue(forKey: key, onDict: dict))
      }
    } catch let error as ColorsParserError {
      throw error
    } catch let error {
      throw ColorsParserError.invalidFile(reason: error.localizedDescription)
    }
  }
}

// MARK: - CLR File Parser

public final class ColorsCLRFileParser: ColorsFileParser {
  public private(set) var colors = [String: UInt32]()

  public init() {}

  public func parseFile(at path: Path) throws {
    if let colorsList = NSColorList(name: "UserColors", fromFile: path.description) {
      for colorName in colorsList.allKeys {
        colors[colorName] = colorsList.color(withKey: colorName)?.rgbColor?.hexValue
      }
    } else {
      throw ColorsParserError.invalidFile(reason: "Invalid color list")
    }
  }

}

extension NSColor {

  fileprivate var rgbColor: NSColor? {
    return usingColorSpaceName(NSCalibratedRGBColorSpace)
  }

  fileprivate var hexValue: UInt32 {
    let hexRed   = UInt32(redComponent   * 0xFF) << 24
    let hexGreen = UInt32(greenComponent * 0xFF) << 16
    let hexBlue  = UInt32(blueComponent  * 0xFF) << 8
    let hexAlpha = UInt32(alphaComponent * 0xFF)
    return hexRed | hexGreen | hexBlue | hexAlpha
  }

}

// MARK: - Android colors.xml File Parser

public final class ColorsXMLFileParser: ColorsFileParser {
  static let colorTagName = "color"
  static let colorNameAttribute = "name"

  public private(set) var colors = [String: UInt32]()

  public init() {}

  private class ParserDelegate: NSObject, XMLParserDelegate {
    var parsedColors = [String: UInt32]()
    var currentColorName: String? = nil
    var currentColorValue: String? = nil
    var colorParserError: Error? = nil

    @objc func parser(_ parser: XMLParser, didStartElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?,
                      attributes attributeDict: [String: String]) {
      guard elementName == ColorsXMLFileParser.colorTagName else { return }
      currentColorName = attributeDict[ColorsXMLFileParser.colorNameAttribute]
      currentColorValue = nil
    }

    @objc func parser(_ parser: XMLParser, foundCharacters string: String) {
      currentColorValue = (currentColorValue ?? "") + string
    }

    @objc func parser(_ parser: XMLParser, didEndElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?) {
      guard elementName == ColorsXMLFileParser.colorTagName else { return }
      guard let colorName = currentColorName, let colorValue = currentColorValue else { return }

      do {
        parsedColors[colorName] = try parse(hex: colorValue, key: colorName)
      } catch let error as ColorsParserError {
        colorParserError = error
        parser.abortParsing()
      } catch {
        parser.abortParsing()
      }

      currentColorName = nil
      currentColorValue = nil
    }
  }

  public func parseFile(at path: Path) throws {
    let parser = XMLParser(data: try path.read())
    let delegate = ParserDelegate()
    parser.delegate = delegate

    if parser.parse() {
      colors = delegate.parsedColors
    } else if let error = delegate.colorParserError {
      throw error
    } else {
      let reason = parser.parserError?.localizedDescription ?? "Unknown XML parser error."
      throw ColorsParserError.invalidFile(reason: reason)
    }
  }

}

// MARK: - JSON File Parser

public final class ColorsJSONFileParser: ColorsFileParser {
  public private(set) var colors = [String: UInt32]()

  public init() {}

  public func parseFile(at path: Path) throws {
    do {
      let json = try JSONSerialization.jsonObject(with: try path.read(), options: [])

      guard let dict = json as? [String: String] else {
        throw ColorsParserError.invalidFile(reason: "Invalid structure, must be an object with string values.")
      }

      for (key, value) in dict {
        colors[key] = try parse(hex: value, key: key)
      }
    } catch let error as ColorsParserError {
      throw error
    } catch let error {
      throw ColorsParserError.invalidFile(reason: error.localizedDescription)
    }
  }
}
