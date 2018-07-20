//
//  Attribute.swift
//  SwiftGenKit
//
//  Created by Grant Butler on 7/19/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation

extension CoreData {
  public struct Attribute {
    public let name: String
    public let isIndexed: Bool
    public let isOptional: Bool
    public let isTransient: Bool
    public let usesScalarValueType: Bool

    public let type: AttributeType
    public let customClassName: String?
    public let typeName: String
  }

  public enum AttributeType: String {
    case integer16     = "Integer 16"
    case integer32     = "Integer 32"
    case integer64     = "Integer 64"
    case decimal       = "Decimal"
    case double        = "Double"
    case float         = "Float"
    case string        = "String"
    case boolean       = "Boolean"
    case date          = "Date"
    case binaryData    = "Binary"
    case transformable = "Transformable"
    case URI           = "URI"
    case UUID          = "UUID"
  }
}

