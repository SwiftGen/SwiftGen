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
    /// A dictionary of key-value pairs specifying the rule (value) to use for each variable (key).
    /// Every variable that is part of the `formatKey` must be contained in this dictionary.
    let variables: [String: VariableRule]
  }

  /// Variable width entries are used to define width variations for a localized string.
  ///
  /// Reference: https://developer.apple.com/documentation/foundation/nsstring/1413104-variantfittingpresentationwidth
  struct VariableWidthEntry: Codable {
    let rules: [String: String]
  }
}

extension StringsDict.PluralEntry {
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
  ) throws -> [String: PluralEntry.VariableRule] {
    var variables = [String: PluralEntry.VariableRule]()

    for variableKey in try StringsDict.variableKeysFromFormatKey(formatKey) {
      let variable = try container.decode(PluralEntry.VariableRule.self, forKey: CodingKeys(key: variableKey))
      variables[variableKey] = variable

      // Nested FormatKey in Variable. Check if one of the strings (zero, one, ...) contains format keys,
      // decode them and add them to `variables`
      let childVariableKeys = Set(try variable.formatStrings.flatMap { try StringsDict.variableKeysFromFormatKey($0) })
      for variableKey in Array(childVariableKeys) {
        variables[variableKey] = try container.decode(PluralEntry.VariableRule.self, forKey: CodingKeys(key: variableKey))
      }
    }
    return variables
  }

  /// Parses a format string and returns an array of discovered variable keys.
  /// Every variable key that is contained within the format string is preceded
  /// by the %#@ characters and followed by the @ character.
  private static func variableKeysFromFormatKey(_ formatKey: String) throws -> [String] {
    let pattern = #"%(?>\d\$)?#@([\w\.\p{Pd}]+)@"#
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let nsrange = NSRange(formatKey.startIndex..<formatKey.endIndex, in: formatKey)
    let matches = regex.matches(in: formatKey, options: [], range: nsrange)

    return matches.compactMap { match -> String? in
      let captureGroupRange = match.range(at: 1)
      guard
        captureGroupRange.location != NSNotFound,
        let range = Range(captureGroupRange, in: formatKey)
      else {
        return nil
      }

      return String(formatKey[range])
    }
  }
}

// - MARK: Helpers

extension StringsDict.PluralEntry {
  var translation: String? {
    var result = formatKey
    variables.forEach { keyValuePair in
      let (key, variable) = keyValuePair
      result = result.replacingOccurrences(of: "%#@\(key)@", with: variable.other)
    }

    return "Plural case 'other': \(result)"
  }
}

extension StringsDict.PluralEntry.VariableRule {
  var formatStrings: [String] {
    [zero, one, two, few, many, other].compactMap { $0 }
  }
}
