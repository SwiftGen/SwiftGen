//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public protocol Parser {
  init(options: [String: Any], warningHandler: MessageHandler?) throws

  // Parsing and context generation
  func parse(path: Path) throws
  func parse(paths: [Path]) throws
  func stencilContext() -> [String: Any]

  /// This callback will be called when a Parser want to emit a diagnostics message
  /// You can set this on the usage-site to a closure that prints the diagnostics in any way you see fit
  /// Arguments are (message, file, line)
  typealias MessageHandler = (String, String, UInt) -> Void
  var warningHandler: MessageHandler? { get set }
}

public extension Parser {
  func parse(paths: [Path]) throws {
    for path in paths {
      try parse(path: path)
    }
  }
}
