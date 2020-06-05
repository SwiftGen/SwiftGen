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
    static let propertyListDecoder = PropertyListDecoder()

    // Localizable.strings files are generally UTF16, not UTF8!
    func parseFile(at path: Path) throws -> [Strings.Entry] {
      guard let data = try? path.read() else {
        throw ParserError.failureOnLoading(path: path.string)
      }

      let dict = try Strings.StringsFileParser.propertyListDecoder
        .decode([String: String].self, from: data)

      return try dict.map { key, translation in
        try Entry(key: key, translation: translation, keyStructureSeparator: options[Option.separator])
      }
    }
  }
}
