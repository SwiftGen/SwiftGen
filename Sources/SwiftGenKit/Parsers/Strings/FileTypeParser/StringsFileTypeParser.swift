//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

protocol StringsFileTypeParser: AnyObject {
  init(options: ParserOptionValues)

  static var extensions: [String] { get }

  func parseFile(at path: Path) throws -> [Strings.Entry]
}

extension StringsFileTypeParser {
  static func supports(path: Path) -> Bool {
    let fileExt = path.extension ?? ""
    return extensions.contains { ext in
      ext.compare(fileExt, options: .caseInsensitive) == .orderedSame
    }
  }
}
