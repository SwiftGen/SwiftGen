//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit
import Foundation
import PathKit

extension Colors {
  final class CLRFileParser: ColorsFileTypeParser {
    init(options: [String: Any] = [:]) {
    }

    static let extensions = ["clr"]

    private enum Keys {
      static let userColors = "UserColors"
    }

    func parseFile(at path: Path) throws -> Palette {
      if let colorsList = NSColorList(name: Keys.userColors, fromFile: path.string) {
        var colors = [String: UInt32]()

        for colorName in colorsList.allKeys {
          colors[colorName] = colorsList.color(withKey: colorName)?.hexValue
        }

        let name = path.lastComponentWithoutExtension
        return Palette(name: name, colors: colors)
      } else {
        throw ParserError.invalidFile(path: path, reason: "Invalid color list")
      }
    }
  }
}
