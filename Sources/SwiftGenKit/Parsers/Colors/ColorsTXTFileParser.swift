//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Colors {
  final class TextFileParser: ColorsFileTypeParser {
    private var colors = [String: UInt32]()

    init(options: [String: Any] = [:]) {
    }

    static let allOptions = ParserOptionList()
    static let extensions = ["txt"]

    // Text file expected to be:
    //  - One line per entry
    //  - Each line composed by the color name, then ":", then the color hex representation
    //  - Extra spaces will be skipped
    func parseFile(at path: Path) throws -> Palette {
      do {
        let dict = try keyValueDict(from: path, withSeperator: ":")
        for key in dict.keys {
          try addColor(named: key, value: colorValue(forKey: key, onDict: dict), path: path)
        }
      } catch let error as ParserError {
        throw error
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: error.localizedDescription)
      }

      let name = path.lastComponentWithoutExtension
      return Palette(name: name, colors: colors)
    }

    private func addColor(named name: String, value: String, path: Path) throws {
      try addColor(named: name, value: Colors.parse(hex: value, key: name, path: path))
    }

    private func addColor(named name: String, value: UInt32) {
      colors[name] = value
    }

    private func keyValueDict(from path: Path, withSeperator seperator: String = ":") throws -> [String: String] {
      let content = try path.read(.utf8)
      let lines = content.components(separatedBy: CharacterSet.newlines)

      var dict: [String: String] = [:]
      for line in lines {
        let scanner = Scanner(string: line)
        scanner.charactersToBeSkipped = .whitespaces

        var key: NSString?
        var value: NSString?
        guard scanner.scanUpTo(seperator, into: &key) &&
          scanner.scanString(seperator, into: nil) &&
          scanner.scanUpToCharacters(from: .whitespaces, into: &value) else {
            continue
        }

        if let key: String = key?.trimmingCharacters(in: .whitespaces),
          let value: String = value?.trimmingCharacters(in: .whitespaces) {
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
  }
}
