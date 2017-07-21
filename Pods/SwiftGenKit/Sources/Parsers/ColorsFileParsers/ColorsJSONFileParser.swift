//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

final class ColorsJSONFileParser: ColorsFileTypeParser {
  static let extensions = ["json"]

  func parseFile(at path: Path) throws -> Palette {
    do {
      let json = try JSONSerialization.jsonObject(with: try path.read(), options: [])
      guard let dict = json as? [String: String] else {
        throw ColorsParserError.invalidFile(path: path,
                                            reason: "Invalid structure, must be an object with string values.")
      }

      var colors = [String: UInt32]()
      for (key, value) in dict {
        colors[key] = try parse(hex: value, key: key, path: path)
      }

      let name = path.lastComponentWithoutExtension
      return Palette(name: name, colors: colors)
    } catch let error as ColorsParserError {
      throw error
    } catch let error {
      throw ColorsParserError.invalidFile(path: path, reason: error.localizedDescription)
    }
  }
}
