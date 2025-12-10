//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public struct Filter {
  public enum Error: Swift.Error, CustomStringConvertible {
    case invalidRegex(pattern: String)

    public var description: String {
      switch self {
      case .invalidRegex(let pattern):
        return "error: Unable to parse regular expression '\(pattern)'."
      }
    }
  }

  /// Options to further narrow down filtering
  public struct Options: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }

    /// Equivalent of Path.DirectoryEnumerationOptions.skipsSubdirectoryDescendants
    public static let skipsSubdirectoryDescendants = Self(rawValue: 1 << 0)
    /// Equivalent of Path.DirectoryEnumerationOptions.skipsPackageDescendants
    public static let skipsPackageDescendants = Self(rawValue: 1 << 1)
    /// Equivalent of Path.DirectoryEnumerationOptions.skipsHiddenFiles
    public static let skipsHiddenFiles = Self(rawValue: 1 << 2)
    /// Ignore directories
    public static let skipsDirectories = Self(rawValue: 1 << 3)
    /// Ignore files
    public static let skipsFiles = Self(rawValue: 1 << 4)

    public static let `default`: Self = [.skipsDirectories, .skipsHiddenFiles, .skipsPackageDescendants]

    fileprivate var directoryEnumerationOptions: Path.DirectoryEnumerationOptions {
      Path.DirectoryEnumerationOptions(
        [
          contains(.skipsSubdirectoryDescendants) ? .skipsSubdirectoryDescendants : nil,
          contains(.skipsPackageDescendants) ? .skipsPackageDescendants : nil,
          contains(.skipsHiddenFiles) ? .skipsHiddenFiles : nil
        ].compactMap { $0 }
      )
    }
  }

  fileprivate let regex: NSRegularExpression
  fileprivate let options: Options

  /// Creates a filter with the given pattern, must be a valid regular expression.
  ///
  /// - Parameter pattern: The regular expression provided by the user
  /// - Parameter options: Filter options to further narrow searching
  public init(pattern: String, options: Options = .default) throws {
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
      self.options = options
    } catch {
      throw Error.invalidRegex(pattern: pattern)
    }
  }
}

extension Parser {
  /// Create the regex for a filter for the given list of file extensions. The extensions will be matched at the end
  /// of a filename, and will be matched case-insensitively.
  ///
  /// - Parameter extensions: The list of file extensions.
  /// - Returns: The regex as a `String`.
  static func filterRegex(forExtensions extensions: [String]) -> String {
    let extensionsList = extensions.map { NSRegularExpression.escapedPattern(for: $0) }.joined(separator: "|")
    // - require at least one character that is not a "/" before the "." in order to avoid matching dotfiles
    // - then a literal "."
    // - then one of the accepted extensions, in a case-insensitive way (`(?:i…)`), at the end of the string (`$`)
    return "[^/]\\.(?i:\(extensionsList))$"
  }
}

extension Path {
  /// Checks if this path matches the given filter (regular expression).
  ///
  /// - Parameter filter: The regular expression to match
  /// - Returns: true if it matches
  func matches(filter: Filter) -> Bool {
    if filter.options.contains(.skipsDirectories) && isDirectory {
      return false
    } else if filter.options.contains(.skipsFiles) && isFile {
      return false
    } else {
      let range = NSRange(string.startIndex..<string.endIndex, in: string)
      return filter.regex.firstMatch(in: string, options: [], range: range) != nil
    }
  }

  /// Recursively search through the given path, returning any files or folders that matches the given filter.
  ///
  /// - Parameter path: The path to search recursively through.
  /// - Parameter filter: The filter to apply to each path.
  /// - Returns: Each path, and it's parent path, found matching the filter.
  func subpaths(matching filter: Filter) throws -> [(path: Path, parentDir: Path)] {
    if matches(filter: filter) {
      let parentDir = absolute().parent()
      return [(self, parentDir)]
    } else {
      let parentDir = absolute()
      return iterateChildren(options: filter.options.directoryEnumerationOptions)
        .filter { $0.matches(filter: filter) }
        .map { ($0, parentDir) }
    }
  }
}
