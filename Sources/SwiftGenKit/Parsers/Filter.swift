//
// SwiftGenKit
// Copyright © 2020 SwiftGen
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

  fileprivate let regex: NSRegularExpression

  /// Creates a filter with the given pattern, must be a valid regular expression.
  ///
  /// - Parameter pattern: The regular expression provided by the user
  public init(pattern: String) throws {
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
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
    let range = NSRange(string.startIndex..<string.endIndex, in: string)
    return filter.regex.firstMatch(in: string, options: [], range: range) != nil
  }
}
