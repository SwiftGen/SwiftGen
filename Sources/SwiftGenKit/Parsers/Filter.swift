//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT License
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

extension Path {
  /// Checks if this path matches the given filter (regular expression).
  ///
  /// - Parameter filter: The regular expression to match
  /// - Returns: true if it matches
  func matches(filter: Filter) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    return filter.regex.firstMatch(in: string, options: [], range: range) != nil
  }
}
