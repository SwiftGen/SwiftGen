//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public protocol Parser {
  /// Parser initializer. Please use the `createWith(options:warningHandler:)` factory method instead,
  /// it'll ensure the safety of the provided options.
  ///
  /// - Parameter options: Dictionary of options, used to customize processing.
  /// - Parameter warningHandler: Callback for logging issues.
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
  /// Factory method for safely creating a parser instance. Options will be checked against the list of
  /// supported options (in `allOptions`).
  ///
  /// - Parameter options: Dictionary of options, checked against `allOptions`.
  /// - Parameter warningHandler: Callback for logging issues.
  /// - Returns: An instance of the parser.
  static func createWith(options: [String: Any], warningHandler: MessageHandler?) throws -> Self {
    try allOptions.check(options: options)
    return try Self.init(options: options, warningHandler: warningHandler)
  }

  /// Recursively search through the given paths, parsing any file or folder that matches the given filter.
  ///
  /// - Parameter paths: The paths to search recursively through.
  /// - Parameter filter: The filter to apply to each path.
  func searchAndParse(paths: [Path], filter: Filter) throws {
    for path in paths {
      try searchAndParse(path: path, filter: filter)
    }
  }

  /// Recursively search through the given path, parsing any file or folder that matches the given filter.
  ///
  /// - Parameter path: The path to search recursively through.
  /// - Parameter filter: The filter to apply to each path.
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
