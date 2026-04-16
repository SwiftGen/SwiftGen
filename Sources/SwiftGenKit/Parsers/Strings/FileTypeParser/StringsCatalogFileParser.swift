//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsCatalogFileParser: StringsFileTypeParser {
    private let options: ParserOptionValues

    init(options: ParserOptionValues) {
      self.options = options
    }

    static let extensions = ["xcstrings"]

    func parseFile(at path: Path) throws -> [Strings.Entry] {
      let file = try File(path: path)
      let entries = try parseFile(file)
      return entries
    }

    func parseFile(_ file: File) throws -> [Strings.Entry] {
      let sourceLanguage = file.document.sourceLanguage

      do {
        return try file.document.strings.compactMap { key, entry -> Strings.Entry? in
          guard let localization = entry.localizations[sourceLanguage] else {
            return nil
          }
          var stringEntry = Strings.Entry(
            key: key,
            translation: translation(from: localization, key: key),
            types: try placeholderFormat(from: localization, key: key),
            keyStructureSeparator: options[Option.separator]
          )
          stringEntry.comment = entry.comment
          return stringEntry
        }
      } catch {
        throw error
      }
    }

    private func translation(
      from localization: Strings.Localization,
      key: String
    ) -> String {
      if localization.variations?.plural != nil {
        return "Plural format key: \(key)"
      }
      return localization.stringUnit?.value ?? "Key: \(key)"
    }

    private func placeholderFormat(
      from localization: Strings.Localization,
      key: String
    ) throws -> [Strings.PlaceholderType] {
      let keyValue = localization.stringUnit?.value ?? key
      let placeholderTypes = try Strings.PlaceholderType.placeholderTypes(
        fromFormat: keyValue
      )
      if !placeholderTypes.isEmpty {
        return placeholderTypes
      } else {
        let plurals = localization.variations?.plural?.all.map { $0.stringUnit.value } ?? []
        let types = try plurals.map { format in try Strings.PlaceholderType.placeholderTypes(fromFormat: format) }
        return types.first { types in
          !types.isEmpty
        } ?? []
      }
    }
  }
}
