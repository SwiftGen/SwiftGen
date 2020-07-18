//
// SwiftGenKit
// Copyright © 2020 SwiftGen
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
  ///
  /// Note: SwiftGen doesn't yet support parsing those VariableWidth entries
  struct VariableWidthEntry: Codable {
    let rules: [String: String]
  }
}

extension StringsDict.PluralEntry {
  /// `Variable`s are a key-value pair specifying the rule to use for each variable (name).
  struct Variable: Codable {
    let name: String
    let rule: VariableRule
  }

  /// A VariableRule contains the actual localized plural strings for every possible plural case that
  /// is available in a specific locale. Since some locales only support a subset of plural forms,
  /// most of them are optional.
  struct VariableRule: Codable {
    /// The only possible value is `NSStringPluralRuleType`.
    let specTypeKey: String
    /// A string format specifier for a number, but without the `%` prefix; as in `d` for an integer.
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
      let entry = coder.codingPath.last?.stringValue ?? "<unknown>"
      throw Strings.ParserError.invalidFormat(
        reason: """
        Entry "\(entry)" expects either "\(CodingKeys.formatKey.stringValue)" or \
        "\(CodingKeys.variableWidthRules.stringValue)" but got either neither or both
        """
      )
    case let (.some(formatKey), .none):
      let variableNames = StringsDict.variableNames(fromFormatKey: formatKey).map(\.name)
      let variables = try variableNames.reduce(into: [PluralEntry.Variable]()) { variables, variableName in
        let variableRule = try container.decode(PluralEntry.VariableRule.self, forKey: CodingKeys(key: variableName))
        // Combination of the format specifiers of the `PlaceholderType.float` and `PlaceholderType.int`.
        guard ["a", "e", "f", "g", "d", "i", "o", "u", "x"].contains(variableRule.valueTypeKey.suffix(1)) else {
          throw Strings.ParserError.invalidVariableRuleValueType(
            variableName: variableName,
            valueType: variableRule.valueTypeKey
          )
        }
        variables.append(PluralEntry.Variable(name: variableName, rule: variableRule))
      }
      self = .pluralEntry(PluralEntry(formatKey: formatKey, variables: variables))
    case let (.none, .some(variableWidthRules)):
      self = .variableWidthEntry(VariableWidthEntry(rules: variableWidthRules))
    }
  }
}

// - MARK: Helpers

extension StringsDict {
  typealias VariableNameResult = (name: String, range: NSRange, positionalArgument: Int?)

  /// Parses variable names and their ranges from a `NSStringLocalizedFormatKey`.
  /// Every variable name that is contained within the format key is preceded
  /// by the %#@ characters or by the positional variants, e.g. %1$#@, and followed by the @ character.
  ///
  /// - Parameter formatKey: The formatKey from which the variable names should be parsed.
  /// - Returns: An array of discovered variable names, their range within the `formatKey` and the positional argument.
  private static func variableNames(fromFormatKey formatKey: String) -> [VariableNameResult] {
    let pattern = #"%(?>(\d+)\$)?#@([\w\.\p{Pd}]+)@"#
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
      fatalError("Unable to compile regular expression when parsing StringsDict entries")
    }
    let nsrange = NSRange(formatKey.startIndex..<formatKey.endIndex, in: formatKey)
    let matches = regex.matches(in: formatKey, options: [], range: nsrange)

    return matches.lazy.compactMap { match -> VariableNameResult? in
      // the whole format string including delimeters
      let fullMatchNSRange = match.range(at: 0)
      // 1st capture group is the positional argument of the format string (Optional!)
      let positionalArgumentNSRange = match.range(at: 1)
      let positionalArgumentRange = Range(positionalArgumentNSRange, in: formatKey)
      // 2nd capture group is the name of the variable, the string in between the delimeters
      let nameNSRange = match.range(at: 2)
      guard let nameRange = Range(nameNSRange, in: formatKey) else { return nil }

      let position = positionalArgumentRange.flatMap { Int(formatKey[$0]) }
      return (String(formatKey[nameRange]), fullMatchNSRange, position)
    }
  }
}

extension StringsDict.PluralEntry {
  /// Extract the placeholders (`NSStringFormatValueTypeKey`) from the different variable
  /// definitions into a single flattened list of placeholders
  var formatKeyWithVariableValueTypes: String {
    var result = formatKey
    var offset = 0

    for (name, var nsrange, positionalArgument) in StringsDict.variableNames(fromFormatKey: formatKey) {
      guard let variable = variables.first(where: { $0.name == name }) else { continue }

      let variablePlaceholder: String
      if let positionalArgument = positionalArgument {
        variablePlaceholder = "%\(positionalArgument)$\(variable.rule.valueTypeKey)"
      } else {
        variablePlaceholder = "%\(variable.rule.valueTypeKey)"
      }

      nsrange.location += offset
      guard let range = Range(nsrange, in: result) else { continue }
      result.replaceSubrange(range, with: variablePlaceholder)
      offset += variablePlaceholder.count - nsrange.length
    }

    return result
  }
}
