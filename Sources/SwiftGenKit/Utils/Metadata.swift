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
    let dataType = type(of: data)

    if data is String {
      return [Key.type: ValueType.string]
    } else if dataType == Bool.self {
      return [Key.type: ValueType.bool]
    } else if dataType == Int.self {
      return [Key.type: ValueType.int]
    } else if dataType == Double.self {
      return [Key.type: ValueType.double]
    } else if dataType == Date.self {
      return [Key.type: ValueType.date]
    } else if dataType == Data.self {
      return [Key.type: ValueType.data]
    } else if let data = data as? NSNumber {
      return [Key.type: valueType(for: data)]
    } else if let data = data as? [Any] {
      return [
        Key.type: ValueType.array,
        Key.element: Metadata.describe(arrayElement: data)
      ]
    } else if let data = data as? [String: Any] {
      return [
        Key.type: ValueType.dictionary,
        Key.properties: Metadata.describe(dictionary: data)
      ]
    } else if dataType == NSNull.self || Mirror(reflecting: data).displayStyle == .optional {
      return [Key.type: ValueType.optional]
    } else {
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
    } else if let array = array as? [NSNumber], let valueType = elementValueType(for: array) {
      return [Key.type: valueType]
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

  private static func valueType(for number: NSNumber) -> String {
    if CFGetTypeID(number) == CFBooleanGetTypeID() {
      return ValueType.bool
    } else {
      switch CFNumberGetType(number) {
      case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .charType, .intType, .longType, .longLongType,
        .nsIntegerType:
        return ValueType.int
      case .float32Type, .float64Type, .floatType, .doubleType, .cgFloatType:
        return ValueType.double
      default:
        return ValueType.any
      }
    }
  }

  private static func elementValueType(for array: [NSNumber]) -> String? {
    let valueTypes = Set(array.map(valueType(for:)))

    if valueTypes.count < 2, let elementType = valueTypes.first {
      return elementType
    } else {
      return nil
    }
  }
}
