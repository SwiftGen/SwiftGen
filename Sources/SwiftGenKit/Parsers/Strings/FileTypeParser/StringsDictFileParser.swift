//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsDictFileParser: StringsFileTypeParser {
    static let extensions = ["stringsdict"]

    static let propertyListDecoder = PropertyListDecoder()

    func parseFile(at path: Path) throws -> [Strings.Entry] {
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }

      let plurals = try Strings.StringsDictFileParser.propertyListDecoder.decode([String: StringsDict].self, from: data)
        .compactMapValues { stringsDict -> StringsDict.PluralEntry? in
          guard case let .pluralEntry(pluralEntry) = stringsDict else { return nil }
          return pluralEntry
        }

      return try plurals.map { keyValuePair -> Entry in
        let (key, pluralEntry) = keyValuePair
        let formatValueTypes = pluralEntry.variables.mapValues { "%\($0.valueTypeKey)" }.values
        let placeholderTypes = try PlaceholderType.placeholders(fromFormat: Array(formatValueTypes).joined(separator: " "))
        return Entry(key: key, translation: pluralEntry.translation ?? "", types: placeholderTypes)
      }
    }
  }
}
