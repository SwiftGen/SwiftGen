//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

final class ColorsXMLFileParser: ColorsFileTypeParser {
  static let extensions = ["xml"]

  private enum XML {
    static let colorXPath = "/resources/color"
    static let nameAttribute = "name"
  }

  func parseFile(at path: Path) throws -> Palette {
    guard let document = Kanna.XML(xml: try path.read(), encoding: .utf8) else {
      throw ColorsParserError.invalidFile(path: path, reason: "Unknown XML parser error.")
    }

    var colors = [String: UInt32]()

    for color in document.xpath(XML.colorXPath) {
      guard let value = color.text else {
        throw ColorsParserError.invalidFile(path: path, reason: "Invalid structure, color must have a value.")
      }
      guard let name = color["name"], !name.isEmpty else {
        throw ColorsParserError.invalidFile(path: path, reason: "Invalid structure, color \(value) must have a name.")
      }

      colors[name] = try parse(hex: value, key: name, path: path)
    }

    let name = path.lastComponentWithoutExtension
    return Palette(name: name, colors: colors)
  }
}
