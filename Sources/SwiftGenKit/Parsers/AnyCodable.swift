//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

// Original credits to Ian Keen (https://gist.github.com/IanKeen/df3bed29e2613ead94aa3b16967b9d14)

import Foundation

// swiftlint:disable cyclomatic_complexity function_body_length
public struct AnyCodable: Codable {
  public let value: Any?

  public init(_ value: Any?) {
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if container.decodeNil() {
      self.value = nil
    } else if let value = try? container.decode([String: AnyCodable].self) {
      self.value = value.compactMapValues({ $0.value })
    } else if let value = try? container.decode([AnyCodable].self) {
      self.value = value.compactMap({ $0.value })
    } else if let value = try? container.decode(Bool.self) {
      self.value = value
    } else if let value = try? container.decode(String.self) {
      self.value = value
    } else if let value = try? container.decode(Date.self) {
      self.value = value
    } else if let value = try? container.decode(Int.self) {
      self.value = value
    } else if let value = try? container.decode(Int8.self) {
      self.value = value
    } else if let value = try? container.decode(Int16.self) {
      self.value = value
    } else if let value = try? container.decode(Int32.self) {
      self.value = value
    } else if let value = try? container.decode(Int64.self) {
      self.value = value
    } else if let value = try? container.decode(UInt.self) {
      self.value = value
    } else if let value = try? container.decode(UInt8.self) {
      self.value = value
    } else if let value = try? container.decode(UInt16.self) {
      self.value = value
    } else if let value = try? container.decode(UInt32.self) {
      self.value = value
    } else if let value = try? container.decode(UInt64.self) {
      self.value = value
    } else if let value = try? container.decode(Double.self) {
      self.value = value
    } else if let value = try? container.decode(Float.self) {
      self.value = value
    } else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Unable to decode value"
      )
    }
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    switch value {
    case nil:
      try container.encodeNil()
    case let value as [String: AnyCodable]:
      try container.encode(value)
    case let value as [String: Any]:
      try container.encode(value.mapValues(AnyCodable.init))
    case let value as [AnyCodable]:
      try container.encode(value)
    case let value as [Any]:
      try container.encode(value.map(AnyCodable.init))
    case let value as Bool:
      try container.encode(value)
    case let value as String:
      try container.encode(value)
    case let value as Date:
      try container.encode(value)
    case let value as Int:
      try container.encode(value)
    case let value as Int8:
      try container.encode(value)
    case let value as Int16:
      try container.encode(value)
    case let value as Int32:
      try container.encode(value)
    case let value as Int64:
      try container.encode(value)
    case let value as UInt:
      try container.encode(value)
    case let value as UInt8:
      try container.encode(value)
    case let value as UInt16:
      try container.encode(value)
    case let value as UInt32:
      try container.encode(value)
    case let value as UInt64:
      try container.encode(value)
    case let value as Double:
      try container.encode(value)
    case let value as Float:
      try container.encode(value)
    default:
      throw EncodingError.invalidValue(
        value ?? "<nil>",
        .init(codingPath: container.codingPath, debugDescription: "Unable to encode value")
      )
    }
  }
}
// swiftlint:enable cyclomatic_complexity function_body_length

extension KeyedDecodingContainer {
  public func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
    let anyCodable = try decode(AnyCodable.self, forKey: key)
    guard let value = anyCodable.value as? [String: Any] else {
      let type = Swift.type(of: anyCodable.value)
      throw DecodingError.typeMismatch(
        type,
        .init(codingPath: self.codingPath, debugDescription: "Expected [String: Any], found \(type)")
      )
    }
    return value
  }
}

extension KeyedEncodingContainer {
  public mutating func encode(_ value: [String: Any], forKey key: K) throws {
    try encode(AnyCodable(value), forKey: key)
  }
}
