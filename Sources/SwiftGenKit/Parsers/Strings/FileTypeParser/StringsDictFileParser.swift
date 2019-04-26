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

      let plurals = try Strings.StringsDictFileParser.propertyListDecoder.decode([String: StringsDict].self, from: data)
        .compactMapValues { stringsDict -> StringsDict.PluralEntry? in
          guard case let .pluralEntry(pluralEntry) = stringsDict else { return nil }
          return pluralEntry
        }

      return try plurals.map { keyValuePair -> Entry in
        let (key, pluralEntry) = keyValuePair
        // swiftlint:disable:next todo
        // TODO: this only considers the first format value type. If the formatKey of a plural contains
        // different variables, it won't be able to create a fitting Entry
        let formatValueType = "%\(pluralEntry.variables.first?.value.valueTypeKey ?? "")"
        let placeholderTypes = try PlaceholderType.placeholders(fromFormat: formatValueType)
        return Entry(
          key: key,
          translation: pluralEntry.translation ?? "",
          types: placeholderTypes,
          keyStructureSeparator: options[Option.separator]
        )
      }
    }
  }
}
