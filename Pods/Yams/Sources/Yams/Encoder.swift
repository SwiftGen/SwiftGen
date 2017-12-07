//
//  Encoder.swift
//  Yams
//
//  Created by Norio Nomura on 5/2/17.
//  Copyright (c) 2017 Yams. All rights reserved.
//

import Foundation

public class YAMLEncoder {
    public typealias Options = Emitter.Options
    public var options = Options()
    public init() {}
    public func encode<T: Swift.Encodable>(_ value: T, userInfo: [CodingUserInfoKey: Any] = [:]) throws -> String {
        do {
            let encoder = _Encoder(userInfo: userInfo)
            var container = encoder.singleValueContainer()
            try container.encode(value)
            return try serialize(node: encoder.node, options: options)
        } catch let error as EncodingError {
            throw error
        } catch {
            let description = "Unable to encode the given top-level value to YAML."
            let context = EncodingError.Context(codingPath: [],
                                                debugDescription: description,
                                                underlyingError: error)
            throw EncodingError.invalidValue(value, context)
        }
    }
}

class _Encoder: Swift.Encoder { // swiftlint:disable:this type_name
    var node: Node = .unused

    init(userInfo: [CodingUserInfoKey: Any] = [:], codingPath: [CodingKey] = []) {
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    // MARK: - Swift.Encoder Methods

    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        if canEncodeNewValue {
            node = [:]
        } else {
            precondition(
                node.isMapping,
                "Attempt to push new keyed encoding container when already previously encoded at this path."
            )
        }
        return .init(_KeyedEncodingContainer<Key>(referencing: self))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        if canEncodeNewValue {
            node = []
        } else {
            precondition(
                node.isSequence,
                "Attempt to push new keyed encoding container when already previously encoded at this path."
            )
        }
        return _UnkeyedEncodingContainer(referencing: self)
    }

    func singleValueContainer() -> SingleValueEncodingContainer { return self }

    // MARK: -

    fileprivate var mapping: Node.Mapping {
        get { return node.mapping ?? [:] }
        set { node.mapping = newValue }
    }

    fileprivate var sequence: Node.Sequence {
        get { return node.sequence ?? [] }
        set { node.sequence = newValue }
    }

    /// Encode `ScalarRepresentable` to `node`
    fileprivate func represent<T: ScalarRepresentable>(_ value: T) throws {
        assertCanEncodeNewValue()
        node = try box(value)
    }

    fileprivate func represent<T: ScalarRepresentableCustomizedForCodable>(_ value: T) throws {
        assertCanEncodeNewValue()
        node = value.representedForCodable()
    }

    /// create a new `_ReferencingEncoder` instance as `key` inheriting `userInfo`
    fileprivate func encoder(for key: CodingKey) -> _ReferencingEncoder {
        return .init(referencing: self, key: key)
    }

    /// create a new `_ReferencingEncoder` instance at `index` inheriting `userInfo`
    fileprivate func encoder(at index: Int) -> _ReferencingEncoder {
        return .init(referencing: self, at: index)
    }

    /// Create `Node` from `ScalarRepresentable`.
    /// Errors throwed by `ScalarRepresentable` will be boxed into `EncodingError`
    fileprivate func box(_ representable: ScalarRepresentable) throws -> Node {
        do {
            return try representable.represented()
        } catch {
            let context = EncodingError.Context(codingPath: codingPath,
                                                debugDescription: "Unable to encode the given value to YAML.",
                                                underlyingError: error)
            throw EncodingError.invalidValue(representable, context)
        }
    }

    fileprivate var canEncodeNewValue: Bool { return node == .unused }
}

class _ReferencingEncoder: _Encoder { // swiftlint:disable:this type_name
    private enum Reference { case mapping(String), sequence(Int) }

    private let encoder: _Encoder
    private let reference: Reference

    fileprivate init(referencing encoder: _Encoder, key: CodingKey) {
        self.encoder = encoder
        reference = .mapping(key.stringValue)
        super.init(userInfo: encoder.userInfo, codingPath: encoder.codingPath + [key])
    }

    fileprivate init(referencing encoder: _Encoder, at index: Int) {
        self.encoder = encoder
        reference = .sequence(index)
        super.init(userInfo: encoder.userInfo, codingPath: encoder.codingPath + [_YAMLCodingKey(index: index)])
    }

    deinit {
        switch reference {
        case .mapping(let key):
            encoder.node[key] = node
        case .sequence(let index):
            encoder.node[index] = node
        }
    }
}

struct _KeyedEncodingContainer<K: CodingKey> : KeyedEncodingContainerProtocol { // swiftlint:disable:this type_name
    typealias Key = K

    private let encoder: _Encoder

    fileprivate init(referencing encoder: _Encoder) {
        self.encoder = encoder
    }

    // MARK: - Swift.KeyedEncodingContainerProtocol Methods

    var codingPath: [CodingKey] { return encoder.codingPath }
    func encodeNil(forKey key: Key)               throws { encoder.mapping[key.stringValue] = .null }
    func encode(_ value: Bool, forKey key: Key)   throws { try encoder(for: key).represent(value) }
    func encode(_ value: Int, forKey key: Key)    throws { try encoder(for: key).represent(value) }
    func encode(_ value: Int8, forKey key: Key)   throws { try encoder(for: key).represent(value) }
    func encode(_ value: Int16, forKey key: Key)  throws { try encoder(for: key).represent(value) }
    func encode(_ value: Int32, forKey key: Key)  throws { try encoder(for: key).represent(value) }
    func encode(_ value: Int64, forKey key: Key)  throws { try encoder(for: key).represent(value) }
    func encode(_ value: UInt, forKey key: Key)   throws { try encoder(for: key).represent(value) }
    func encode(_ value: UInt8, forKey key: Key)  throws { try encoder(for: key).represent(value) }
    func encode(_ value: UInt16, forKey key: Key) throws { try encoder(for: key).represent(value) }
    func encode(_ value: UInt32, forKey key: Key) throws { try encoder(for: key).represent(value) }
    func encode(_ value: UInt64, forKey key: Key) throws { try encoder(for: key).represent(value) }
    func encode(_ value: Float, forKey key: Key)  throws { try encoder(for: key).represent(value) }
    func encode(_ value: Double, forKey key: Key) throws { try encoder(for: key).represent(value) }
    func encode(_ value: String, forKey key: Key) throws { encoder.mapping[key.stringValue] = Node(value) }
    func encode<T>(_ value: T, forKey key: Key)   throws where T: Encodable { try encoder(for: key).encode(value) }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                    forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        return encoder(for: key).container(keyedBy: type)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return encoder(for: key).unkeyedContainer()
    }

    func superEncoder() -> Encoder { return encoder(for: _YAMLCodingKey.super) }
    func superEncoder(forKey key: Key) -> Encoder { return encoder(for: key) }

    // MARK: -

    private func encoder(for key: CodingKey) -> _ReferencingEncoder { return encoder.encoder(for: key) }
}

struct _UnkeyedEncodingContainer: UnkeyedEncodingContainer { // swiftlint:disable:this type_name
    private let encoder: _Encoder

    fileprivate init(referencing encoder: _Encoder) {
        self.encoder = encoder
    }

    // MARK: - Swift.UnkeyedEncodingContainer Methods

    var codingPath: [CodingKey] { return encoder.codingPath }
    var count: Int { return encoder.sequence.count }
    func encodeNil()             throws { encoder.sequence.append(.null) }
    func encode(_ value: Bool)   throws { try currentEncoder.represent(value) }
    func encode(_ value: Int)    throws { try currentEncoder.represent(value) }
    func encode(_ value: Int8)   throws { try currentEncoder.represent(value) }
    func encode(_ value: Int16)  throws { try currentEncoder.represent(value) }
    func encode(_ value: Int32)  throws { try currentEncoder.represent(value) }
    func encode(_ value: Int64)  throws { try currentEncoder.represent(value) }
    func encode(_ value: UInt)   throws { try currentEncoder.represent(value) }
    func encode(_ value: UInt8)  throws { try currentEncoder.represent(value) }
    func encode(_ value: UInt16) throws { try currentEncoder.represent(value) }
    func encode(_ value: UInt32) throws { try currentEncoder.represent(value) }
    func encode(_ value: UInt64) throws { try currentEncoder.represent(value) }
    func encode(_ value: Float)  throws { try currentEncoder.represent(value) }
    func encode(_ value: Double) throws { try currentEncoder.represent(value) }
    func encode(_ value: String) throws { encoder.sequence.append(Node(value)) }
    func encode<T>(_ value: T)   throws where T: Encodable { try currentEncoder.encode(value) }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        return currentEncoder.container(keyedBy: type)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer { return currentEncoder.unkeyedContainer() }
    func superEncoder() -> Encoder { return currentEncoder }

    // MARK: -

    private var currentEncoder: _ReferencingEncoder {
        defer { encoder.sequence.append("") }
        return encoder.encoder(at: count)
    }
}

extension _Encoder: SingleValueEncodingContainer {

    // MARK: - Swift.SingleValueEncodingContainer Methods

    func encodeNil() throws {
        assertCanEncodeNewValue()
        node = .null
    }

    func encode(_ value: Bool)   throws { try represent(value) }
    func encode(_ value: Int)    throws { try represent(value) }
    func encode(_ value: Int8)   throws { try represent(value) }
    func encode(_ value: Int16)  throws { try represent(value) }
    func encode(_ value: Int32)  throws { try represent(value) }
    func encode(_ value: Int64)  throws { try represent(value) }
    func encode(_ value: UInt)   throws { try represent(value) }
    func encode(_ value: UInt8)  throws { try represent(value) }
    func encode(_ value: UInt16) throws { try represent(value) }
    func encode(_ value: UInt32) throws { try represent(value) }
    func encode(_ value: UInt64) throws { try represent(value) }
    func encode(_ value: Float)  throws { try represent(value) }
    func encode(_ value: Double) throws { try represent(value) }

    func encode(_ value: String) throws {
        assertCanEncodeNewValue()
        node = Node(value)
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        assertCanEncodeNewValue()
        if let customized = value as? ScalarRepresentableCustomizedForCodable {
            node = customized.representedForCodable()
        } else if let representable = value as? ScalarRepresentable {
            node = try box(representable)
        } else {
            try value.encode(to: self)
        }
    }

    // MARK: -

    /// Asserts that a single value can be encoded at the current coding path
    /// (i.e. that one has not already been encoded through this container).
    /// `preconditionFailure()`s if one cannot be encoded.
    fileprivate func assertCanEncodeNewValue() {
        precondition(
            canEncodeNewValue,
            "Attempt to encode value through single value container when previously value already encoded."
        )
    }
}

// MARK: - CodingKey for `_UnkeyedEncodingContainer`, `_UnkeyedDecodingContainer`, `superEncoder` and `superDecoder`

struct _YAMLCodingKey: CodingKey { // swiftlint:disable:this type_name
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }

    static let `super` = _YAMLCodingKey(stringValue: "super")!
}

// MARK: -

private extension Node {
    static let null = Node("null", Tag(.null))
    static let unused = Node("", .unused)
}

private extension Tag {
    static let unused = Tag(.unused)
}

private extension Tag.Name {
    static let unused: Tag.Name = "tag:yams.encoder:unused"
}

private func serialize(node: Node, options: Emitter.Options) throws -> String {
    return try serialize(
        nodes: [node],
        canonical: options.canonical,
        indent: options.indent,
        width: options.width,
        allowUnicode: options.allowUnicode,
        lineBreak: options.lineBreak,
        explicitStart: options.explicitStart,
        explicitEnd: options.explicitEnd,
        version: options.version,
        sortKeys: options.sortKeys)
}
