//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Colors {
  final class JSONFileParser: ColorsFileTypeParser {
    init(options: [String: Any] = [:]) {
    }

    static let allOptions = ParserOptionList()
    static let extensions = ["json"]

    func parseFile(at path: Path) throws -> Palette {
      do {
        let json = try JSONSerialization.jsonObject(with: try path.read(), options: [])
        guard let dict = json as? [String: String] else {
          throw ParserError.invalidFile(
            path: path,
            reason: "Invalid structure, must be an object with string values."
          )
        }

        var colors = [String: UInt32]()
        for (key, value) in dict {
          colors[key] = try Colors.parse(hex: value, key: key, path: path)
        }

        let name = path.lastComponentWithoutExtension
        return Palette(name: name, colors: colors)
      } catch let error as ParserError {
        throw error
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: error.localizedDescription)
      }
    }
  }
}
