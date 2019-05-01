//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

enum StringsDict: Decodable {
  struct PluralEntry: Codable {
    struct Variable: Codable {
      let specTypeKey: String
      let valueTypeKey: String
      let zero: String?
      let one: String?
      let two: String?
      let few: String?
      let many: String?
      let other: String

      // swiftlint:disable:next nesting
      enum CodingKeys: String, CodingKey {
        case specTypeKey = "NSStringFormatSpecTypeKey"
        case valueTypeKey = "NSStringFormatValueTypeKey"

        case zero, one, two, few, many, other
      }
    }

    let formatKey: String
    let variables: [String: Variable]
  }

  struct VariableWidthEntry {
    let rules: [String: String]
  }

  case pluralEntry(PluralEntry)
  case variableWidthEntry(VariableWidthEntry)

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

    static let formatKey = CodingKeys.make(key: "NSStringLocalizedFormatKey")
    static let variableWidthRules = CodingKeys.make(key: "NSStringVariableWidthRuleType")
    static func make(key: String) -> CodingKeys {
      return CodingKeys(stringValue: key)! // swiftlint:disable:this force_unwrapping
    }
  }

  init(from coder: Decoder) throws {
    let container = try coder.container(keyedBy: CodingKeys.self)
    let formatKey = try container.decodeIfPresent(String.self, forKey: .formatKey)
    let variableWidthRules = try container.decodeIfPresent([String: String].self, forKey: .variableWidthRules)

    switch (formatKey, variableWidthRules) {
    case (.none, .none), (.some, .some):
      throw Strings.ParserError.invalidFormat
    case let (.some(formatKey), .none):
      let variables = try StringsDict.decodeVariables(in: container, formatKey: formatKey)
      self = .pluralEntry(PluralEntry(formatKey: formatKey, variables: variables))
    case let (.none, .some(variableWidthRules)):
      self = .variableWidthEntry(VariableWidthEntry(rules: variableWidthRules))
    }
  }

  private static func decodeVariables(
    in container: KeyedDecodingContainer<StringsDict.CodingKeys>,
    formatKey: String
  ) throws -> [String: PluralEntry.Variable] {
    var variables = [String: PluralEntry.Variable]()
    for variableKey in try StringsDict.variableKeysFromFormatKey(formatKey) {
      let variable = try container.decode(PluralEntry.Variable.self, forKey: .make(key: variableKey))
      variables[variableKey] = variable

      // Nested FormatKey in Variable. Check if one of the strings (zero, one, ...) contains format keys,
      // decode them and add them to `variables`
      let childVariableKeys = Set(try variable.formatStrings.flatMap { try StringsDict.variableKeysFromFormatKey($0) })
      for variableKey in Array(childVariableKeys) {
        variables[variableKey] = try container.decode(PluralEntry.Variable.self, forKey: .make(key: variableKey))
      }
    }
    return variables
  }

  private static func variableKeysFromFormatKey(_ formatKey: String) throws -> [String] {
    let pattern = "%(?>\\d\\$)?#@([\\w\\.\\p{Pd}]+)@"
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

extension StringsDict.PluralEntry.Variable {
  var formatStrings: [String] {
    return [zero, one, two, few, many, other].compactMap { $0 }
  }
}
