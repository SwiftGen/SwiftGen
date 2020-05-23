//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

extension Strings {
  final class StringsFileParser: StringsFileTypeParser {
    private let options: ParserOptionValues

    let shouldOverwriteValuesInExistingTable: Bool = false

    init(options: ParserOptionValues) {
      self.options = options
    }

    static let extensions = ["strings"]
    static let allOptions: ParserOptionList = [Option.separator]

    // Localizable.strings files are generally UTF16, not UTF8!
    func parseFile(at path: Path) throws -> [Strings.Entry] {
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }

      let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
      guard let dict = plist as? [String: String] else {
        throw ParserError.invalidFormat
      }

      return try dict.map { key, translation in
        try Entry(key: key, translation: translation, keyStructureSeparator: options[Option.separator])
      }
    }
  }
}
