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

      return []
    }
  }
}
