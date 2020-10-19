//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

extension Colors {
  final class XMLFileParser: ColorsFileTypeParser {
    private let colorFormat: ColorFormat

    init(options: ParserOptionValues) throws {
      let format = options[Option.colorFormat]

      if let colorFormat = ColorFormat(rawValue: format) {
        self.colorFormat = colorFormat
      } else {
        let formats: [String] = ColorFormat.allCases.compactMap { $0.rawValue }
        throw ParserError.unsupportedColorFormat(string: format, supported: formats)
      }
    }

    static var allOptions: ParserOptionList = [Option.colorFormat]

    static let extensions = ["xml"]

    private enum XML {
      static let colorXPath = "/resources/color"
      static let nameAttribute = "name"
    }

    func parseFile(at path: Path) throws -> Palette {
      let document: Kanna.XMLDocument
      do {
        document = try Kanna.XML(xml: path.read(), encoding: .utf8)
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
      }

      var colors = [String: UInt32]()

      for color in document.xpath(XML.colorXPath) {
        guard let value = color.text else {
          throw ParserError.invalidFile(path: path, reason: "Invalid structure, color must have a value.")
        }
        guard let name = color["name"], !name.isEmpty else {
          throw ParserError.invalidFile(path: path, reason: "Invalid structure, color \(value) must have a name.")
        }

        colors[name] = try Colors.parse(hex: value, key: name, path: path, format: colorFormat)
      }

      let name = path.lastComponentWithoutExtension
      return Palette(name: name, colors: colors)
    }
  }
}
