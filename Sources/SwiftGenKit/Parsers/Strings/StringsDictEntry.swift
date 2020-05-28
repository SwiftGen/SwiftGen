//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

/// This enum represents the types of entries a `.stringsdict` file can contain.
enum StringsDict {
  case pluralEntry(PluralEntry)
  case variableWidthEntry(VariableWidthEntry)
}

extension StringsDict {
  /// Plural entries are used to define language plural rules.
  ///
  /// Reference: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/StringsdictFileFormat/StringsdictFileFormat.html
  // swiftlint:disable:previous line_length
  struct PluralEntry: Codable {
    /// A format string that contains variables.
    /// Each variable is preceded by the %#@ characters and followed by the @ character.
    let formatKey: String
    /// An array of variables specifying the rules to use for each variable in the `formatKey`.
    /// Every variable that is part of the `formatKey` must be contained in this dictionary.
    let variables: [Variable]
  }

  /// Variable width entries are used to define width variations for a localized string.
  ///
  /// Reference: https://developer.apple.com/documentation/foundation/nsstring/1413104-variantfittingpresentationwidth
  struct VariableWidthEntry: Codable {
    let rules: [String: String]
  }
}

extension StringsDict.PluralEntry {
  /// `Variable`s are a key-value pair specifying the rule to use for each variable (key).
  struct Variable: Codable {
    let key: String
    let rule: VariableRule
  }

  /// A VariableRule contains the actual localized plural strings for every possible plural case that
  /// is available in a specific locale. Since some locales only support a subset of plural forms,
  /// most of them are optional.
  struct VariableRule: Codable {
    /// The only possible value is `NSStringPluralRuleType`.
    let specTypeKey: String
    /// A string format specifier for a number, as in %d for an integer.
    let valueTypeKey: String
    let zero: String?
    let one: String?
    let two: String?
    let few: String?
    let many: String?
    let other: String

    private enum CodingKeys: String, CodingKey {
      case specTypeKey = "NSStringFormatSpecTypeKey"
      case valueTypeKey = "NSStringFormatValueTypeKey"

      case zero, one, two, few, many, other
    }
  }
}

// - MARK: Decodable conformance

extension StringsDict: Decodable {
  // Custom CodingKeys struct to be able to parse dictionaries with dynamic keys.
  // This is necessary, because each variable used in the formatKey is used as the key
  // to another dictionary containing the rules for that variable.
  private struct CodingKeys: CodingKey {
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {
      self.intValue = intValue
      self.stringValue = "\(intValue)"
    }
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    init(key: String) {
      self.stringValue = key
    }

    // fixed keys
    static let formatKey = CodingKeys(key: "NSStringLocalizedFormatKey")
    static let variableWidthRules = CodingKeys(key: "NSStringVariableWidthRuleType")
  }

  init(from coder: Decoder) throws {
    let container = try coder.container(keyedBy: CodingKeys.self)
    let formatKey = try container.decodeIfPresent(String.self, forKey: .formatKey)
    let variableWidthRules = try container.decodeIfPresent([String: String].self, forKey: .variableWidthRules)

    // We either have a formatKey OR we have a variableWidthRule.
    switch (formatKey, variableWidthRules) {
    case (.none, .none), (.some, .some):
      throw Strings.ParserError.invalidFormat
    case let (.some(formatKey), .none):
      let variables = try StringsDict.decodeVariableRules(in: container, formatKey: formatKey)
      self = .pluralEntry(PluralEntry(formatKey: formatKey, variables: variables))
    case let (.none, .some(variableWidthRules)):
      self = .variableWidthEntry(VariableWidthEntry(rules: variableWidthRules))
    }
  }

  private static func decodeVariableRules(
    in container: KeyedDecodingContainer<StringsDict.CodingKeys>,
    formatKey: String
  ) throws -> [PluralEntry.Variable] {
    guard let variableKeyTuples = StringsDict.variableKeysFromFormatKey(formatKey) else { return [] }
    let sortedVariableKeys = variableKeyTuples
      .sorted { lhs, rhs in
        // Sort by positional argument if present, otherwise by occurrence in the format key
        switch (lhs.positionalArgument, rhs.positionalArgument, lhs.range.lowerBound, rhs.range.lowerBound) {
        case let (.none, .none, lhs, rhs):
          return lhs < rhs
        case (.some, .none, _, _):
          return true
        case (.none, .some, _, _):
          return false
        case let (.some(lhs), .some(rhs), _, _):
          return lhs < rhs
        }
      }
      .map { $0.key }

    return try sortedVariableKeys.reduce(into: [PluralEntry.Variable]()) { variables, variableKey in
      let variableRule = try container.decode(PluralEntry.VariableRule.self, forKey: CodingKeys(key: variableKey))
      variables.append(PluralEntry.Variable(key: variableKey, rule: variableRule))
    }
  }
}

// - MARK: Helpers

extension StringsDict {
  typealias VariableKeyResult = (key: String, range: Range<String.Index>, positionalArgument: Int?)

  /// Parses variable keys and their ranges from a formatKey.
  /// Every variable key that is contained within the format string is preceded
  /// by the %#@ characters or by the positional variants, e.g. %1$#@, and followed by the @ character.
  ///
  /// - Parameter formatKey: The formatKey from which the variable keys should be parsed.
  /// - Returns: An array of discovered variable keys and their range within the `formatKey`.
  // swiftlint:disable:next discouraged_optional_collection
  private static func variableKeysFromFormatKey(_ formatKey: String) -> [VariableKeyResult]? {
    let pattern = #"(%(?>(\d)\$)?#@([\w\.\p{Pd}]+)@)"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
    let nsrange = NSRange(formatKey.startIndex..<formatKey.endIndex, in: formatKey)
    let matches = regex.matches(in: formatKey, options: [], range: nsrange)

    return matches.compactMap { match -> (String, Range<String.Index>, Int?)? in
      // 1st capture group is the whole format string including delimeters
      let rangeNSRange = match.range(at: 1)
      // 2nd capture group is the positional argument of the format string (Optional!)
      let positionalArgumentNSRange = match.range(at: 2)
      // 3rd capture group is the key, the string in between the delimeters
      let keyNSRange = match.range(at: 3)

      guard rangeNSRange.location != NSNotFound, let rangeRange = Range(rangeNSRange, in: formatKey) else { return nil }
      guard keyNSRange.location != NSNotFound, let keyRange = Range(keyNSRange, in: formatKey) else { return nil }

      guard
        positionalArgumentNSRange.location != NSNotFound,
        let positionalArgumentRange = Range(positionalArgumentNSRange, in: formatKey)
      else {
        return (String(formatKey[keyRange]), rangeRange, nil)
      }

      return (String(formatKey[keyRange]), rangeRange, Int(formatKey[positionalArgumentRange]))
    }
  }
}

extension StringsDict.PluralEntry {
  var translation: String? {
    var result = formatKey

    for intermediateResult in sequence(first: result, next: unfurlVariableKeysInFormatKey(_:)) {
      result = intermediateResult
    }

    return "Plural case 'other': \(result)"
  }

  /// Unfurls any variable keys in a formatKey to get a possible translation for the `other` case.
  ///
  /// This method should be used in a recursive context, in which the output will be used as the input for the
  /// next iteration.
  ///
  /// - Parameter formatKey: A format key containing variables.
  /// - Returns: The format key in which all its variable keys are replaced with the content of the `other` translation,
  ///  if the `formatKey` contained any variable keys, `nil` otherwise.
  private func unfurlVariableKeysInFormatKey(_ formatKey: String) -> String? {
    guard let firstRemainingVariableKey = StringsDict.variableKeysFromFormatKey(formatKey)?.first else {
      return nil
    }

    let (key, range, _) = firstRemainingVariableKey
    guard let variable = variables.first(where: { $0.key == key }) else { return nil }

    return formatKey.replacingCharacters(in: range, with: variable.rule.other)
  }
}

extension StringsDict.PluralEntry.VariableRule {
  var formatStrings: [String] {
    [zero, one, two, few, many, other].compactMap { $0 }
  }
}
