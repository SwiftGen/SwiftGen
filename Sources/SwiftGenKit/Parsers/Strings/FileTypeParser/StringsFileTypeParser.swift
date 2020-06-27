//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

protocol StringsFileTypeParser: AnyObject {
  init(options: ParserOptionValues)

  var shouldOverwriteValuesInExistingTable: Bool { get }

  static var extensions: [String] { get }

  func parseFile(at path: Path) throws -> [Strings.Entry]
}
