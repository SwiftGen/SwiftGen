//
//  Decoder.swift
//  Yams
//
//  Created by Norio Nomura on 5/6/17.
//  Copyright (c) 2017 Yams. All rights reserved.
//

import Foundation

public class YAMLDecoder {
    public init() {}
    public func decode<T>(_ type: T.Type = T.self,
                          from yaml: String,
                          userInfo: [CodingUserInfoKey: Any] = [:]) throws -> T where T: Swift.Decodable {
        do {
            let node = try Yams.compose(yaml: yaml, .basic) ?? ""
            let decoder = _Decoder(referencing: node, userInfo: userInfo)
            let container = try decoder.singleValueContainer()
            return try container.decode(type)
        } catch let error as DecodingError {
            throw error
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                    debugDescription: "The given data was not valid YAML.",
                                                    underlyingError: error))
        }
    }
}

private struct _Decoder: Decoder {

    private let node: Node

    init(referencing node: Node, userInfo: [CodingUserInfoKey: Any], codingPath: [CodingKey] = []) {
        self.node = node
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    // MARK: - Swift.Decoder Methods

    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let mapping = node.mapping else {
            throw _typeMismatch(at: codingPath, expectation: Node.Mapping.self, reality: node)
        }
        return .init(_KeyedDecodingContainer<Key>(decoder: self, wrapping: mapping))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let sequence = node.sequence else {
            throw _typeMismatch(at: codingPath, expectation: Node.Sequence.self, reality: node)
        }
        return _UnkeyedDecodingContainer(decoder: self, wrapping: sequence)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer { return self }

    // MARK: -

    /// constuct `T` from `node`
    func construct<T: ScalarConstructible>(_ type: T.Type) throws -> T {
        let scalar = try self.scalar()
        guard let constructed = type.construct(from: scalar) else {
            throw _typeMismatch(at: codingPath, expectation: type, reality: scalar)
        }
        return constructed
    }

    /// create a new `_Decoder` instance referencing `node` as `key` inheriting `userInfo`
    func decoder(referencing node: Node, `as` key: CodingKey) -> _Decoder {
        return .init(referencing: node, userInfo: userInfo, codingPath: codingPath + [key])
    }

    /// returns `Node.Scalar` or throws `DecodingError.typeMismatch`
    private func scalar() throws -> Node.Scalar {
        switch node {
        case .scalar(let scalar):
            return scalar
        case .mapping(let mapping):
            throw _typeMismatch(at: codingPath, expectation: Node.Scalar.self, reality: mapping)
        case .sequence(let sequence):
            throw _typeMismatch(at: codingPath, expectation: Node.Scalar.self, reality: sequence)
        }
    }
}

private struct _KeyedDecodingContainer<Key: CodingKey> : KeyedDecodingContainerProtocol {

    private let decoder: _Decoder
    private let mapping: Node.Mapping

    init(decoder: _Decoder, wrapping mapping: Node.Mapping) {
        self.decoder = decoder
        self.mapping = mapping
    }

    // MARK: - Swift.KeyedDecodingContainerProtocol Methods

    var codingPath: [CodingKey] { return decoder.codingPath }
    var allKeys: [Key] { return mapping.keys.compactMap { $0.string.flatMap(Key.init(stringValue:)) } }
    func contains(_ key: Key) -> Bool { return mapping[key.stringValue] != nil }

    func decodeNil(forKey key: Key) throws -> Bool {
        return try node(for: key) == Node("null", Tag(.null))
    }

    func decode(_ type: Bool.Type, forKey key: Key)   throws -> Bool { return try decoder(for: key).construct(type) }
    func decode(_ type: Int.Type, forKey key: Key)    throws -> Int { return try decoder(for: key).construct(type) }
    func decode(_ type: Int8.Type, forKey key: Key)   throws -> Int8 { return try decoder(for: key).construct(type) }
    func decode(_ type: Int16.Type, forKey key: Key)  throws -> Int16 { return try decoder(for: key).construct(type) }
    func decode(_ type: Int32.Type, forKey key: Key)  throws -> Int32 { return try decoder(for: key).construct(type) }
    func decode(_ type: Int64.Type, forKey key: Key)  throws -> Int64 { return try decoder(for: key).construct(type) }
    func decode(_ type: UInt.Type, forKey key: Key)   throws -> UInt { return try decoder(for: key).construct(type) }
    func decode(_ type: UInt8.Type, forKey key: Key)  throws -> UInt8 { return try decoder(for: key).construct(type) }
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { return try decoder(for: key).construct(type) }
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { return try decoder(for: key).construct(type) }
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { return try decoder(for: key).construct(type) }
    func decode(_ type: Float.Type, forKey key: Key)  throws -> Float { return try decoder(for: key).construct(type) }
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double { return try decoder(for: key).construct(type) }
    func decode(_ type: String.Type, forKey key: Key) throws -> String { return try decoder(for: key).construct(type) }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        return try decoder(for: key).decode(type) // use SingleValueDecodingContainer's method
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                    forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        return try decoder(for: key).container(keyedBy: type)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try decoder(for: key).unkeyedContainer()
    }

    func superDecoder() throws -> Decoder { return try decoder(for: _YAMLCodingKey.super) }
    func superDecoder(forKey key: Key) throws -> Decoder { return try decoder(for: key) }

    // MARK: -

    private func node(for key: CodingKey) throws -> Node {
        guard let node = mapping[key.stringValue] else {
            throw _keyNotFound(at: codingPath, key, "No value associated with key \(key) (\"\(key.stringValue)\").")
        }
        return node
    }

    private func decoder(for key: CodingKey) throws -> _Decoder {
        return decoder.decoder(referencing: try node(for: key), as: key)
    }
}

private struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {

    private let decoder: _Decoder
    private let sequence: Node.Sequence

    init(decoder: _Decoder, wrapping sequence: Node.Sequence) {
        self.decoder = decoder
        self.sequence = sequence
        self.currentIndex = 0
    }

    // MARK: - Swift.UnkeyedDecodingContainer Methods

    var codingPath: [CodingKey] { return decoder.codingPath }
    var count: Int? { return sequence.count }
    var isAtEnd: Bool { return currentIndex >= sequence.count }
    var currentIndex: Int

    mutating func decodeNil() throws -> Bool {
        try throwErrorIfAtEnd(Any?.self)
        if currentNode == Node("null", Tag(.null)) {
            currentIndex += 1
            return true
        } else {
            return false
        }
    }

    mutating func decode(_ type: Bool.Type)   throws -> Bool { return try construct(type) }
    mutating func decode(_ type: Int.Type)    throws -> Int { return try construct(type) }
    mutating func decode(_ type: Int8.Type)   throws -> Int8 { return try construct(type) }
    mutating func decode(_ type: Int16.Type)  throws -> Int16 { return try construct(type) }
    mutating func decode(_ type: Int32.Type)  throws -> Int32 { return try construct(type) }
    mutating func decode(_ type: Int64.Type)  throws -> Int64 { return try construct(type) }
    mutating func decode(_ type: UInt.Type)   throws -> UInt { return try construct(type) }
    mutating func decode(_ type: UInt8.Type)  throws -> UInt8 { return try construct(type) }
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 { return try construct(type) }
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 { return try construct(type) }
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 { return try construct(type) }
    mutating func decode(_ type: Float.Type)  throws -> Float { return try construct(type) }
    mutating func decode(_ type: Double.Type) throws -> Double { return try construct(type) }
    mutating func decode(_ type: String.Type) throws -> String { return try construct(type) }

    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try throwErrorIfAtEnd(type)
        let value = try currentDecoder.decode(type) // use SingleValueDecodingContainer's method
        currentIndex += 1
        return value
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        try throwErrorIfAtEnd(KeyedDecodingContainer<NestedKey>.self)
        let container = try currentDecoder.container(keyedBy: type)
        currentIndex += 1
        return container
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try throwErrorIfAtEnd(UnkeyedDecodingContainer.self)
        let container = try currentDecoder.unkeyedContainer()
        currentIndex += 1
        return container
    }

    mutating func superDecoder() throws -> Decoder {
        try throwErrorIfAtEnd(Decoder.self)
        defer { currentIndex += 1 }
        return currentDecoder
    }

    // MARK: -

    private var currentKey: CodingKey { return _YAMLCodingKey(index: currentIndex) }
    private var currentNode: Node { return sequence[currentIndex] }
    private var currentDecoder: _Decoder { return decoder.decoder(referencing: currentNode, as: currentKey) }

    private func throwErrorIfAtEnd<T>(_ type: T.Type) throws {
        if isAtEnd { throw _valueNotFound(at: codingPath + [currentKey], type, "Unkeyed container is at end.") }
    }

    private mutating func construct<T: ScalarConstructible>(_ type: T.Type) throws -> T {
        try throwErrorIfAtEnd(type)
        let decoded: T = try currentDecoder.construct(type)
        currentIndex += 1
        return decoded
    }
}

extension _Decoder: SingleValueDecodingContainer {

    // MARK: - Swift.SingleValueDecodingContainer Methods

    func decodeNil() -> Bool { return node.null == NSNull() }
    func decode(_ type: Bool.Type)   throws -> Bool { return try construct(type) }
    func decode(_ type: Int.Type)    throws -> Int { return try construct(type) }
    func decode(_ type: Int8.Type)   throws -> Int8 { return try construct(type) }
    func decode(_ type: Int16.Type)  throws -> Int16 { return try construct(type) }
    func decode(_ type: Int32.Type)  throws -> Int32 { return try construct(type) }
    func decode(_ type: Int64.Type)  throws -> Int64 { return try construct(type) }
    func decode(_ type: UInt.Type)   throws -> UInt { return try construct(type) }
    func decode(_ type: UInt8.Type)  throws -> UInt8 { return try construct(type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { return try construct(type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { return try construct(type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { return try construct(type) }
    func decode(_ type: Float.Type)  throws -> Float { return try construct(type) }
    func decode(_ type: Double.Type) throws -> Double { return try construct(type) }
    func decode(_ type: String.Type) throws -> String { return try construct(type) }
    func decode<T>(_ type: T.Type)   throws -> T where T: Decodable {
        return try construct(type) ?? type.init(from: self)
    }

    // MARK: -

    private func construct<T>(_ type: T.Type) throws -> T? {
        guard let constructibleType = type as? ScalarConstructible.Type else {
            return nil
        }
        let scalar = try self.scalar()
        guard let value = constructibleType.construct(from: scalar) else {
            throw _valueNotFound(at: codingPath, type, "Expected \(type) value but found \(scalar) instead.")
        }
        return value as? T
    }
}

// MARK: - DecodingError helpers

private func _keyNotFound(at codingPath: [CodingKey], _ key: CodingKey, _ description: String) -> DecodingError {
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
    return.keyNotFound(key, context)
}

private func _valueNotFound(at codingPath: [CodingKey], _ type: Any.Type, _ description: String) -> DecodingError {
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
    return .valueNotFound(type, context)
}

private func _typeMismatch(at codingPath: [CodingKey], expectation: Any.Type, reality: Any) -> DecodingError {
    let description = "Expected to decode \(expectation) but found \(type(of: reality)) instead."
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
    return .typeMismatch(expectation, context)
}

extension FixedWidthInteger where Self: SignedInteger {
    public static func construct(from scalar: Node.Scalar) -> Self? {
        return Int.construct(from: scalar).flatMap(Self.init(exactly:))
    }
}

extension FixedWidthInteger where Self: UnsignedInteger {
    public static func construct(from scalar: Node.Scalar) -> Self? {
        return UInt.construct(from: scalar).flatMap(Self.init(exactly:))
    }
}

extension Int16: ScalarConstructible {}
extension Int32: ScalarConstructible {}
extension Int64: ScalarConstructible {}
extension Int8: ScalarConstructible {}
extension UInt16: ScalarConstructible {}
extension UInt32: ScalarConstructible {}
extension UInt64: ScalarConstructible {}
extension UInt8: ScalarConstructible {}

extension Decimal: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> Decimal? {
        return Decimal(string: scalar.string)
    }
}

extension URL: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> URL? {
        return URL(string: scalar.string)
    }
}
