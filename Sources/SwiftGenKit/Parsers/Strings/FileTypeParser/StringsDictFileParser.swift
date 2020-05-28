//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsDictFileParser: StringsFileTypeParser {
    private let options: ParserOptionValues

    let shouldOverwriteValuesInExistingTable: Bool = true

    init(options: ParserOptionValues) {
      self.options = options
    }

    static let extensions = ["stringsdict"]
    static let allOptions: ParserOptionList = [Option.separator]
    static let propertyListDecoder = PropertyListDecoder()

    func parseFile(at path: Path) throws -> [Strings.Entry] {
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }

      let plurals = try Strings.StringsDictFileParser.propertyListDecoder
        .decode([String: StringsDict].self, from: data)
        .compactMapValues { stringsDict -> StringsDict.PluralEntry? in
          guard case let .pluralEntry(pluralEntry) = stringsDict else { return nil }
          return pluralEntry
        }

      return try plurals.map { keyValuePair -> Entry in
        let (key, pluralEntry) = keyValuePair
        let valueTypes = pluralEntry.variables.reduce(into: [String]()) { valueTypes, variable in
          valueTypes.append("%\(variable.rule.valueTypeKey)")
        }

        return Entry(
          key: key,
          translation: pluralEntry.translation ?? "",
          types: try PlaceholderType.placeholders(fromFormat: valueTypes.joined(separator: " ")),
          keyStructureSeparator: options[Option.separator]
        )
      }
    }
  }
}
