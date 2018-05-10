//
//  Metadata.swift
//  SwiftGenKit
//
//  Created by David Jennes on 05/05/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

enum Metadata {
  private enum Key {
    static let element = "element"
    static let properties = "properties"
    static let type = "type"
  }

  private enum ValueType {
    static let any = "Any"
    static let array = "Array"
    static let dictionary = "Dictionary"
    static let bool = "Bool"
    static let int = "Int"
    static let data = "Data"
    static let date = "Date"
    static let double = "Double"
    static let string = "String"
  }

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
    default:
      return [Key.type: ValueType.any]
    }
  }

  private static func describe(dictionary: [String: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: dictionary.map { item in
      (
        key: item.key,
        value: Metadata.generate(for: item.value)
      )
    })
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
    } else if let array = array as? [[Any]] {
      return [
        Key.type: ValueType.array,
        Key.element: Metadata.describe(arrayElement: array)
      ]
    } else if array is [[String: Any]] {
      return [
        Key.type: ValueType.dictionary
      ]
    } else {
      return [Key.type: ValueType.any]
    }
  }
}
