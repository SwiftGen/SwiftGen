//
// SwiftGenKit
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation

enum Metadata {
  private enum Key {
    static let element = "element"
    static let items = "items"
    static let properties = "properties"
    static let type = "type"
  }

  private enum ValueType {
    static let any = "Any"
    static let optional = "Optional"
    static let array = "Array"
    static let dictionary = "Dictionary"
    static let bool = "Bool"
    static let int = "Int"
    static let data = "Data"
    static let date = "Date"
    static let double = "Double"
    static let string = "String"
  }

  /// Generate structured metadata information about the given data, describing the value's type. This also recurses
  /// for complex types (such as arrays and dictionaries), describing the type information of sub-elements (such as an
  /// array's element, or each of a dictionary's properties).
  ///
  /// Note: this is used for the Plist and YAML Stencil contexts
  ///
  /// - Parameter data: The value to describe
  /// - Returns: Dictionary with type information about the value (for Stencil context)
  static func generate(for data: Any) -> [String: Any] {
    switch data {
    case is String:
      return [Key.type: ValueType.string]
    case is Bool:
      return [Key.type: ValueType.bool]
    case is Int:
      return [Key.type: ValueType.int]
    case is Double:
      return [Key.type: ValueType.double]
    case is Date:
      return [Key.type: ValueType.date]
    case is Data:
      return [Key.type: ValueType.data]
    case let data as [Any]:
      return [
        Key.type: ValueType.array,
        Key.element: Metadata.describe(arrayElement: data)
      ]
    case let data as [String: Any]:
      return [
        Key.type: ValueType.dictionary,
        Key.properties: Metadata.describe(dictionary: data)
      ]
    case is NSNull, nil:
      return [Key.type: ValueType.optional]
    default:
      return [Key.type: ValueType.any]
    }
  }

  private static func describe(dictionary: [String: Any]) -> [String: Any] {
    Dictionary(
      uniqueKeysWithValues: dictionary.map { item in
        (key: item.key, value: Metadata.generate(for: item.value))
      }
    )
  }

  private static func describe(arrayElement array: [Any]) -> [String: Any] {
    if array is [String] {
      return [Key.type: ValueType.string]
    } else if array is [Bool] {
      return [Key.type: ValueType.bool]
    } else if array is [Int] {
      return [Key.type: ValueType.int]
    } else if array is [Double] {
      return [Key.type: ValueType.double]
    } else if array is [Date] {
      return [Key.type: ValueType.date]
    } else if array is [Data] {
      return [Key.type: ValueType.data]
    } else if array is [[Any]] {
      return [
        Key.type: ValueType.array,
        Key.items: array.map { Metadata.generate(for: $0) }
      ]
    } else if array is [[String: Any]] {
      return [
        Key.type: ValueType.dictionary,
        Key.items: array.map { Metadata.generate(for: $0) }
      ]
    } else {
      return [
        Key.type: ValueType.any,
        Key.items: array.map { Metadata.generate(for: $0) }
      ]
    }
  }
}
