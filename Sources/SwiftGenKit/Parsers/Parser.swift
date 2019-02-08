//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public protocol Parser {
  init(options: [String: Any], warningHandler: MessageHandler?) throws

  /// Regex for the default filter
  static var defaultFilter: String { get }

  /// List of supported options
  static var allOptions: ParserOptionList { get }

  /// Try to parse the file (or directory) at the given path, relative to some parent path.
  ///
  /// - Parameter path: The file/directory to parse
  /// - Parameter parent: The parent path (may not be the direct parent)
  func parse(path: Path, relativeTo parent: Path) throws

  /// Generate the stencil context from the parsed content.
  ///
  /// - Returns: A dictionary representing the parsed data 
  func stencilContext() -> [String: Any]

  /// This callback will be called when a Parser want to emit a diagnostics message
  /// You can set this on the usage-site to a closure that prints the diagnostics in any way you see fit
  /// Arguments are (message, file, line)
  typealias MessageHandler = (String, String, UInt) -> Void
  var warningHandler: MessageHandler? { get set }
}

public extension Parser {
  func searchAndParse(paths: [Path], filter: Filter) throws {
    for path in paths {
      try searchAndParse(path: path, filter: filter)
    }
  }

  func searchAndParse(path: Path, filter: Filter) throws {
    if path.matches(filter: filter) {
      let parentDir = path.absolute().parent()
      try parse(path: path, relativeTo: parentDir)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
      let parentDir = path.absolute()

      for path in dirChildren where path.matches(filter: filter) {
        try parse(path: path, relativeTo: parentDir)
      }
    }
  }
}
