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
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: YamlSequence<Any>
///
/// - throws: YamlError
public func load_all(yaml: String,
                     _ resolver: Resolver = .default,
                     _ constructor: Constructor = .default,
                     _ encoding: Parser.Encoding = .default) throws -> YamlSequence<Any> {
    let parser = try Parser(yaml: yaml, resolver: resolver, constructor: constructor, encoding: encoding)
    return YamlSequence { try parser.nextRoot()?.any }
}

/// Parse the first YAML document in a String
/// and produce the corresponding Swift object.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: Any?
///
/// - throws: YamlError
public func load(yaml: String,
                 _ resolver: Resolver = .default,
                 _ constructor: Constructor = .default,
                 _ encoding: Parser.Encoding = .default) throws -> Any? {
    return try Parser(yaml: yaml, resolver: resolver, constructor: constructor, encoding: encoding).singleRoot()?.any
}

/// Parse all YAML documents in a String
/// and produce corresponding representation trees.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: YamlSequence<Node>
///
/// - throws: YamlError
public func compose_all(yaml: String,
                        _ resolver: Resolver = .default,
                        _ constructor: Constructor = .default,
                        _ encoding: Parser.Encoding = .default) throws -> YamlSequence<Node> {
    let parser = try Parser(yaml: yaml, resolver: resolver, constructor: constructor, encoding: encoding)
    return YamlSequence(parser.nextRoot)
}

/// Parse the first YAML document in a String
/// and produce the corresponding representation tree.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: Node?
///
/// - throws: YamlError
public func compose(yaml: String,
                    _ resolver: Resolver = .default,
                    _ constructor: Constructor = .default,
                    _ encoding: Parser.Encoding = .default) throws -> Node? {
    return try Parser(yaml: yaml, resolver: resolver, constructor: constructor, encoding: encoding).singleRoot()
}

/// Sequence that holds an error.
public struct YamlSequence<T>: Sequence, IteratorProtocol {
    /// This sequence's error, if any.
    public private(set) var error: Swift.Error?

    /// `Swift.Sequence.next()`.
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

/// Parses YAML strings.
public final class Parser {
    /// YAML string.
    public let yaml: String
    /// Resolver.
    public let resolver: Resolver
    /// Constructor.
    public let constructor: Constructor

    /// Encoding
    public enum Encoding: String {
        /// Use `YAML_UTF8_ENCODING`
        case utf8
        /// Use `YAML_UTF16(BE|LE)_ENCODING`
        case utf16
        /// The default encoding, determined at run time based on the String type's native encoding.
        /// This can be overridden by setting `YAMS_DEFAULT_ENCODING` to either `UTF8` or `UTF16`.
        /// This value is case insensitive.
        public static var `default`: Encoding = {
            let key = "YAMS_DEFAULT_ENCODING"
            if let yamsEncoding = ProcessInfo.processInfo.environment[key],
                let encoding = Encoding(rawValue: yamsEncoding.lowercased()) {
                print("""
                    `Parser.Encoding.default` was set to `\(encoding)` by the `\(key)` environment variable.
                    """)
                return encoding
            }
            return key.utf8.withContiguousStorageIfAvailable({ _ in true }) != nil ? .utf8 : .utf16
        }()

        /// The equivalent `Swift.Encoding` value for `self`.
        internal var swiftStringEncoding: String.Encoding {
            switch self {
            case .utf8:
                return .utf8
            case .utf16:
                return .utf16
            }
        }
    }
    /// Encoding
    public let encoding: Encoding

    /// Set up a `Parser` with a `String` value as input.
    ///
    /// - parameter string: YAML string.
    /// - parameter resolver: Resolver, `.default` if omitted.
    /// - parameter constructor: Constructor, `.default` if omitted.
    /// - parameter encoding: Encoding, `.default` if omitted.
    ///
    /// - throws: `YamlError`.
    public init(yaml string: String,
                resolver: Resolver = .default,
                constructor: Constructor = .default,
                encoding: Encoding = .default) throws {
        yaml = string
        self.resolver = resolver
        self.constructor = constructor
        self.encoding = encoding

        yaml_parser_initialize(&parser)
        switch encoding {
        case .utf8:
            yaml_parser_set_encoding(&parser, YAML_UTF8_ENCODING)
            let utf8View = yaml.utf8
            buffer = .utf8View(utf8View)
            if try utf8View.withContiguousStorageIfAvailable(startParse(with:)) != nil {
                // Attempt to parse with underlying UTF8 String encoding was successful, nothing further to do
            } else {
                // Fall back to using UTF8 slice
                let utf8Slice = string.utf8CString.dropLast()
                buffer = .utf8Slice(utf8Slice)
                try utf8Slice.withUnsafeBytes(startParse(with:))
            }
        case .utf16:
            // use native endianness
            let isLittleEndian = 1 == 1.littleEndian
            yaml_parser_set_encoding(&parser, isLittleEndian ? YAML_UTF16LE_ENCODING : YAML_UTF16BE_ENCODING)
            let encoding: String.Encoding = isLittleEndian ? .utf16LittleEndian : .utf16BigEndian
            let data = yaml.data(using: encoding)!
            buffer = .utf16(data)
            try data.withUnsafeBytes(startParse(with:))
        }
    }

    /// Set up a `Parser` with a `Data` value as input.
    ///
    /// - parameter string: YAML Data encoded using the `encoding` encoding.
    /// - parameter resolver: Resolver, `.default` if omitted.
    /// - parameter constructor: Constructor, `.default` if omitted.
    /// - parameter encoding: Encoding, `.default` if omitted.
    ///
    /// - throws: `YamlError`.
    public convenience init(yaml data: Data,
                            resolver: Resolver = .default,
                            constructor: Constructor = .default,
                            encoding: Encoding = .default) throws {
        guard let yamlString = String(data: data, encoding: encoding.swiftStringEncoding) else {
            throw YamlError.dataCouldNotBeDecoded(encoding: encoding.swiftStringEncoding)
        }

        try self.init(
            yaml: yamlString,
            resolver: resolver,
            constructor: constructor,
            encoding: encoding
        )
    }

    deinit {
        yaml_parser_delete(&parser)
    }

    /// Parse next document and return root Node.
    ///
    /// - returns: next Node.
    ///
    /// - throws: `YamlError`.
    public func nextRoot() throws -> Node? {
        guard !streamEndProduced, try parse().type != YAML_STREAM_END_EVENT else { return nil }
        return try loadDocument()
    }

    /// Parses the document expecting a single root Node and returns it.
    ///
    /// - returns: Single root Node.
    ///
    /// - throws: `YamlError`.
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

    // MARK: - Private Members

    private var anchors = [String: Node]()
    private var parser = yaml_parser_t()

    private enum Buffer {
        case utf8View(String.UTF8View)
        case utf8Slice(ArraySlice<CChar>)
        case utf16(Data)
    }
    private var buffer: Buffer
}

// MARK: Implementation Details
private extension Parser {
    var streamEndProduced: Bool {
        return parser.stream_end_produced != 0
    }

    func loadDocument() throws -> Node {
        let node = try loadNode(from: parse())
        try parse() // Drop YAML_DOCUMENT_END_EVENT
        return node
    }

    func loadNode(from event: Event) throws -> Node {
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

    func startParse(with buffer: UnsafeRawBufferPointer) throws {
        yaml_parser_set_input_string(&parser, buffer.baseAddress?.assumingMemoryBound(to: UInt8.self), buffer.count)
        try parse() // Drop YAML_STREAM_START_EVENT
    }

    func startParse(with buffer: UnsafeBufferPointer<UInt8>) throws {
        yaml_parser_set_input_string(&parser, buffer.baseAddress, buffer.count)
        try parse() // Drop YAML_STREAM_START_EVENT
    }

    @discardableResult
    func parse() throws -> Event {
        let event = Event()
        guard yaml_parser_parse(&parser, &event.event) == 1 else {
            throw YamlError(from: parser, with: yaml)
        }
        return event
    }

    func loadAlias(from event: Event) throws -> Node {
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

    func loadScalar(from event: Event) throws -> Node {
        let node = Node.scalar(.init(event.scalarValue, tag(event.scalarTag), event.scalarStyle, event.startMark))
        if let anchor = event.scalarAnchor {
            anchors[anchor] = node
        }
        return node
    }

    func loadSequence(from firstEvent: Event) throws -> Node {
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

    func loadMapping(from firstEvent: Event) throws -> Node {
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

    func tag(_ string: String?) -> Tag {
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
        return Node.Scalar.Style(rawValue: numericCast(event.data.scalar.style.rawValue))!
    }
    var scalarTag: String? {
        if event.data.scalar.quoted_implicit == 1 {
            return Tag.Name.str.rawValue
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
        return Node.Sequence.Style(rawValue: numericCast(event.data.sequence_start.style.rawValue))!
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
        return Node.Mapping.Style(rawValue: numericCast(event.data.mapping_start.style.rawValue))!
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
