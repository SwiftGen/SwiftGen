//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

protocol StringsFileTypeParser: AnyObject {
  static var extensions: [String] { get }

  init()
  func parseFile(at path: Path) throws -> [Strings.Entry]
}
