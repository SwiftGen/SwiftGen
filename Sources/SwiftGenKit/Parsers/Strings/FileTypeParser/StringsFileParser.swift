//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsFileParser: StringsFileTypeParser {
    private let options: ParserOptionValues

    init(options: ParserOptionValues) {
      self.options = options
    }

    static let extensions = ["strings"]

    // Localizable.strings files are generally UTF16, not UTF8!
    func parseFile(at path: Path) throws -> [Strings.Entry] {
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path)
      }

      let entries = try PropertyListDecoder()
        .decode([String: String].self, from: data)
        .map { key, translation in
          try Entry(key: key, translation: translation, keyStructureSeparator: options[Option.separator])
        }

      var dict = Dictionary(uniqueKeysWithValues: entries.map { ($0.key, $0) })
      if let parser = StringsFileWithCommentsParser(file: path) {
        parser.enrich(entries: &dict)
      }

      return Array(dict.values)
    }
  }
}
