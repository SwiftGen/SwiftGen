//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

extension Filters.Strings {
  /// Checks if the given string contains given substring
  ///
  /// - Parameters:
  ///   - value: the string value to check if it contains substring
  ///   - arguments: the arguments to the function; expecting one string argument - substring
  /// - Returns: the result whether true or not
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
  ///           if number of arguments is not one or if the given argument isn't a string
  static func contains(_ value: Any?, arguments: [Any?]) throws -> Bool {
      let string = try Filters.parseString(from: value)
      let substring = try Filters.parseStringArgument(from: arguments)
      return string.contains(substring)
  }

  /// Checks if the given string has given prefix
  ///
  /// - Parameters:
  ///   - value: the string value to check if it has prefix
  ///   - arguments: the arguments to the function; expecting one string argument - prefix
  /// - Returns: the result whether true or not
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
  ///           if number of arguments is not one or if the given argument isn't a string
  static func hasPrefix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      let string = try Filters.parseString(from: value)
      let prefix = try Filters.parseStringArgument(from: arguments)
      return string.hasPrefix(prefix)
  }

  /// Checks if the given string has given suffix
  ///
  /// - Parameters:
  ///   - value: the string value to check if it has prefix
  ///   - arguments: the arguments to the function; expecting one string argument - suffix
  /// - Returns: the result whether true or not
  /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
  ///           if number of arguments is not one or if the given argument isn't a string
  static func hasSuffix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      let string = try Filters.parseString(from: value)
      let suffix = try Filters.parseStringArgument(from: arguments)
      return string.hasSuffix(suffix)
  }
}
