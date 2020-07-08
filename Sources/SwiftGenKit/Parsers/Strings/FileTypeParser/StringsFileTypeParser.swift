//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

protocol StringsFileTypeParser: AnyObject {
  init(options: ParserOptionValues)

  /// Parsers with a higher-priority will replace identical keys from lower-priority parsers.
  static var priority: Int { get }
  static var extensions: [String] { get }

  func parseFile(at path: Path) throws -> [Strings.Entry]
}
