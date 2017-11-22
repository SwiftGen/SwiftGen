//
//  Parser.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
    import CYaml
#endif
import Foundation

/// Parse all YAML documents in a String
/// and produce corresponding Swift objects.
///
/// - Parameters:
///   - yaml: String
///   - resolver: Resolver
///   - constructor: Constructor
/// - Returns: YamlSequence<Any>
/// - Throws: YamlError
public func load_all(yaml: String,
                     _ resolver: Resolver = .default,
                     _ constructor: Constructor = .default) throws -> YamlSequence<Any> {
    let parser = try Parser(yaml: yaml, resolver: resolver, constructor: constructor)
    return YamlSequence { try parser.nextRoot()?.any }
}

/// Parse the first YAML document in a String
/// and produce the corresponding Swift object.
///
/// - Parameters:
///   - yaml: String
///   - resolver: Resolver
///   - constructor: Constructor
/// - Returns: Any?
/// - Throws: YamlError
public func load(yaml: String,
                 _ resolver: Resolver = .default,
                 _ constructor: Constructor = .default) throws -> Any? {
    return try Parser(yaml: yaml, resolver: resolver, constructor: constructor).singleRoot()?.any
}

/// Parse all YAML documents in a String
/// and produce corresponding representation trees.
///
/// - Parameters:
///   - yaml: String
///   - resolver: Resolver
///   - constructor: Constructor
/// - Returns: YamlSequence<Node>
/// - Throws: YamlError
public func compose_all(yaml: String,
                        _ resolver: Resolver = .default,
                        _ constructor: Constructor = .default) throws -> YamlSequence<Node> {
    let parser = try Parser(yaml: yaml, resolver: resolver, constructor: constructor)
    return YamlSequence(parser.nextRoot)
}

/// Parse the first YAML document in a String
/// and produce the corresponding representation tree.
///
/// - Parameters:
///   - yaml: String
///   - resolver: Resolver
///   - constructor: Constructor
/// - Returns: Node?
/// - Throws: YamlError
public func compose(yaml: String,
                    _ resolver: Resolver = .default,
                    _ constructor: Constructor = .default) throws -> Node? {
    return try Parser(yaml: yaml, resolver: resolver, constructor: constructor).singleRoot()
}

/// Sequence that holds error
public struct YamlSequence<T>: Sequence, IteratorProtocol {
    public private(set) var error: Swift.Error?

    public mutating func next() -> T? {
        do {
            return try closure()
        } catch {
            self.error = error
            return nil
        }
    }

    fileprivate init(_ closure: @escaping () throws -> T?) {
        self.closure = closure
    }

    private let closure: () throws -> T?
}

public final class Parser {
    // MARK: public
    public let yaml: String
    public let resolver: Resolver
    public let constructor: Constructor

    /// Set up Parser.
    ///
    /// - Parameter string: YAML
    /// - Parameter resolver: Resolver
    /// - Parameter constructor: Constructor
    /// - Throws: YamlError
    public init(yaml string: String,
                resolver: Resolver = .default,
                constructor: Constructor = .default) throws {
        yaml = string
        self.resolver = resolver
        self.constructor = constructor

        yaml_parser_initialize(&parser)
        #if USE_UTF8
            yaml_parser_set_encoding(&parser, YAML_UTF8_ENCODING)
            utf8CString = string.utf8CString
            utf8CString.withUnsafeBytes { bytes in
                let input = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
                yaml_parser_set_input_string(&parser, input, bytes.count - 1)
            }
        #else
            // use native endian
            let isLittleEndian = 1 == 1.littleEndian
            yaml_parser_set_encoding(&parser, isLittleEndian ? YAML_UTF16LE_ENCODING : YAML_UTF16BE_ENCODING)
            let encoding: String.Encoding = isLittleEndian ? .utf16LittleEndian : .utf16BigEndian
            data = yaml.data(using: encoding)!
            data.withUnsafeBytes { bytes in
                yaml_parser_set_input_string(&parser, bytes, data.count)
            }
        #endif
        try parse() // Drop YAML_STREAM_START_EVENT
    }

    deinit {
        yaml_parser_delete(&parser)
    }

    /// Parse next document and return root Node.
    ///
    /// - Returns: next Node
    /// - Throws: YamlError
    public func nextRoot() throws -> Node? {
        guard !streamEndProduced, try parse().type != YAML_STREAM_END_EVENT else { return nil }
        return try loadDocument()
    }

    public func singleRoot() throws -> Node? {
        guard !streamEndProduced, try parse().type != YAML_STREAM_END_EVENT else { return nil }
        let node = try loadDocument()
        let event = try parse()
        if event.type != YAML_STREAM_END_EVENT {
            throw YamlError.composer(
                context: YamlError.Context(text: "expected a single document in the stream",
                                           mark: Mark(line: 1, column: 1)),
                problem: "but found another document", event.startMark,
                yaml: yaml
            )
        }
        return node
    }

    // MARK: private
    fileprivate var anchors = [String: Node]()
    fileprivate var parser = yaml_parser_t()
#if USE_UTF8
    private let utf8CString: ContiguousArray<CChar>
#else
    private let data: Data
#endif
}

// MARK: implementation details
extension Parser {
    fileprivate var streamEndProduced: Bool {
        return parser.stream_end_produced != 0
    }

    fileprivate func loadDocument() throws -> Node {
        let node = try loadNode(from: parse())
        try parse() // Drop YAML_DOCUMENT_END_EVENT
        return node
    }

    private func loadNode(from event: Event) throws -> Node {
        switch event.type {
        case YAML_ALIAS_EVENT:
            return try loadAlias(from: event)
        case YAML_SCALAR_EVENT:
            return try loadScalar(from: event)
        case YAML_SEQUENCE_START_EVENT:
            return try loadSequence(from: event)
        case YAML_MAPPING_START_EVENT:
            return try loadMapping(from: event)
        default:
            fatalError("unreachable")
        }
    }

    @discardableResult
    fileprivate func parse() throws -> Event {
        let event = Event()
        guard yaml_parser_parse(&parser, &event.event) == 1 else {
            throw YamlError(from: parser, with: yaml)
        }
        return event
    }

    private func loadAlias(from event: Event) throws -> Node {
        guard let alias = event.aliasAnchor else {
            fatalError("unreachable")
        }
        guard let node = anchors[alias] else {
            throw YamlError.composer(context: nil,
                                     problem: "found undefined alias", event.startMark,
                                     yaml: yaml)
        }
        return node
    }

    private func loadScalar(from event: Event) throws -> Node {
        let node = Node.scalar(.init(event.scalarValue, tag(event.scalarTag), event.scalarStyle, event.startMark))
        if let anchor = event.scalarAnchor {
            anchors[anchor] = node
        }
        return node
    }

    private func loadSequence(from firstEvent: Event) throws -> Node {
        var array = [Node]()
        var event = try parse()
        while event.type != YAML_SEQUENCE_END_EVENT {
            array.append(try loadNode(from: event))
            event = try parse()
        }
        let node = Node.sequence(.init(array, tag(firstEvent.sequenceTag), event.sequenceStyle, event.startMark))
        if let anchor = firstEvent.sequenceAnchor {
            anchors[anchor] = node
        }
        return node
    }

    private func loadMapping(from firstEvent: Event) throws -> Node {
        var pairs = [(Node, Node)]()
        var event = try parse()
        while event.type != YAML_MAPPING_END_EVENT {
            let key = try loadNode(from: event)
            event = try parse()
            let value = try loadNode(from: event)
            pairs.append((key, value))
            event = try parse()
        }
        let node = Node.mapping(.init(pairs, tag(firstEvent.mappingTag), event.mappingStyle, event.startMark))
        if let anchor = firstEvent.mappingAnchor {
            anchors[anchor] = node
        }
        return node
    }

    private func tag(_ string: String?) -> Tag {
        let tagName = string.map(Tag.Name.init(rawValue:)) ?? .implicit
        return Tag(tagName, resolver, constructor)
    }
}

/// Representation of `yaml_event_t`
private class Event {
    var event = yaml_event_t()
    deinit { yaml_event_delete(&event) }

    var type: yaml_event_type_t {
        return event.type
    }

    // alias
    var aliasAnchor: String? {
        return string(from: event.data.alias.anchor)
    }

    // scalar
    var scalarAnchor: String? {
        return string(from: event.data.scalar.anchor)
    }
    var scalarStyle: Node.Scalar.Style {
        // swiftlint:disable:next force_unwrapping
        return Node.Scalar.Style(rawValue: event.data.scalar.style.rawValue)!
    }
    var scalarTag: String? {
        guard event.data.scalar.plain_implicit == 0,
            event.data.scalar.quoted_implicit == 0 else {
                return nil
        }
        return string(from: event.data.scalar.tag)
    }
    var scalarValue: String {
        // scalar may contain NULL characters
        let buffer = UnsafeBufferPointer(start: event.data.scalar.value,
                                         count: event.data.scalar.length)
        // libYAML converts scalar characters into UTF8 if input is other than YAML_UTF8_ENCODING
        return String(bytes: buffer, encoding: .utf8)!
    }

    // sequence
    var sequenceAnchor: String? {
        return string(from: event.data.sequence_start.anchor)
    }
    var sequenceStyle: Node.Sequence.Style {
        // swiftlint:disable:next force_unwrapping
        return Node.Sequence.Style(rawValue: event.data.sequence_start.style.rawValue)!
    }
    var sequenceTag: String? {
        return event.data.sequence_start.implicit != 0
            ? nil : string(from: event.data.sequence_start.tag)
    }

    // mapping
    var mappingAnchor: String? {
        return string(from: event.data.scalar.anchor)
    }
    var mappingStyle: Node.Mapping.Style {
        // swiftlint:disable:next force_unwrapping
        return Node.Mapping.Style(rawValue: event.data.mapping_start.style.rawValue)!
    }
    var mappingTag: String? {
        return event.data.mapping_start.implicit != 0
            ? nil : string(from: event.data.sequence_start.tag)
    }

    // start_mark
    var startMark: Mark {
        return Mark(line: event.start_mark.line + 1, column: event.start_mark.column + 1)
    }
}

private func string(from pointer: UnsafePointer<UInt8>!) -> String? {
    return String.decodeCString(pointer, as: UTF8.self, repairingInvalidCodeUnits: true)?.result
}
