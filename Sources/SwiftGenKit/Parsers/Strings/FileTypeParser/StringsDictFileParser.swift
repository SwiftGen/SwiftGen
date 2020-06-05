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

      do {
        let plurals = try Strings.StringsDictFileParser.propertyListDecoder
          .decode([String: StringsDict].self, from: data)
          .compactMapValues { stringsDict -> StringsDict.PluralEntry? in
            // We only support .pluralEntry (and not .variableWidthEntry) for now, so filter out the rest
            guard case let .pluralEntry(pluralEntry) = stringsDict else { return nil }
            return pluralEntry
          }

        return try plurals.map { keyValuePair -> Entry in
          // Extract the placeholders (`NSStringFormatValueTypeKey`) from the different variable definitions
          // into a single flattened list of placeholders
          let (key, pluralEntry) = keyValuePair
          let valueTypes = pluralEntry.variables.reduce(into: [String]()) { valueTypes, variable in
            valueTypes.append("%\(variable.rule.valueTypeKey)")
          }

          return Entry(
            key: key,
            translation: "Plural format key: \"\(pluralEntry.formatKey)\"",
            types: try PlaceholderType.placeholders(fromFormat: valueTypes.joined(separator: " ")),
            keyStructureSeparator: options[Option.separator]
          )
        }
      } catch DecodingError.keyNotFound(let codingKey, let context) {
        throw ParserError.invalidPluralFormat(
          missingVariableKey: codingKey.stringValue,
          pluralKey: context.codingPath.first?.stringValue ?? ""
        )
      }
    }
  }
}
