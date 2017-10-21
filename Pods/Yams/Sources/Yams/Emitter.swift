//
//  Emitter.swift
//  Yams
//
//  Created by Norio Nomura on 12/28/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
    import CYaml
#endif
import Foundation

/// Produce YAML String from objects
///
/// - Parameters:
///   - objects: Sequence of Object
///   - canonical: output should be the "canonical" format as in the YAML specification.
///   - indent: the intendation increment.
///   - width: the preferred line width. @c -1 means unlimited.
///   - allowUnicode: unescaped non-ASCII characters are allowed if true.
///   - lineBreak: preferred line break.
///   - explicitStart: explicit document start `---`
///   - explicitEnd: explicit document end `...`
///   - version: YAML version directive
/// - Returns: YAML String
/// - Throws: `YamlError`
public func dump<Objects>(
    objects: Objects,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil) throws -> String
    where Objects: Sequence {
        func representable(from object: Any) throws -> NodeRepresentable {
            if let representable = object as? NodeRepresentable {
                return representable
            }
            throw YamlError.emitter(problem: "\(object) does not conform to NodeRepresentable!")
        }
        let nodes = try objects.map(representable(from:)).map { try $0.represented() }
        return try serialize(
            nodes: nodes,
            canonical: canonical,
            indent: indent,
            width: width,
            allowUnicode: allowUnicode,
            lineBreak: lineBreak,
            explicitStart: explicitStart,
            explicitEnd: explicitEnd,
            version: version)
}

/// Produce YAML String from object
///
/// - Parameters:
///   - object: Object
///   - canonical: output should be the "canonical" format as in the YAML specification.
///   - indent: the intendation increment.
///   - width: the preferred line width. @c -1 means unlimited.
///   - allowUnicode: unescaped non-ASCII characters are allowed if true.
///   - lineBreak: preferred line break.
///   - explicitStart: explicit document start `---`
///   - explicitEnd: explicit document end `...`
///   - version: YAML version directive
/// - Returns: YAML String
/// - Throws: `YamlError`
public func dump(
    object: Any?,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil) throws -> String {
    return try serialize(
        node: object.represented(),
        canonical: canonical,
        indent: indent,
        width: width,
        allowUnicode: allowUnicode,
        lineBreak: lineBreak,
        explicitStart: explicitStart,
        explicitEnd: explicitEnd,
        version: version)
}

/// Produce YAML String from `Node`
///
/// - Parameters:
///   - nodes: Sequence of `Node`
///   - canonical: output should be the "canonical" format as in the YAML specification.
///   - indent: the intendation increment.
///   - width: the preferred line width. @c -1 means unlimited.
///   - allowUnicode: unescaped non-ASCII characters are allowed if true.
///   - lineBreak: preferred line break.
///   - explicitStart: explicit document start `---`
///   - explicitEnd: explicit document end `...`
///   - version: YAML version directive
/// - Returns: YAML String
/// - Throws: `YamlError`
public func serialize<Nodes>(
    nodes: Nodes,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil) throws -> String
    where Nodes: Sequence, Nodes.Iterator.Element == Node {
        let emitter = Emitter(
            canonical: canonical,
            indent: indent,
            width: width,
            allowUnicode: allowUnicode,
            lineBreak: lineBreak,
            explicitStart: explicitStart,
            explicitEnd: explicitEnd,
            version: version)
        try emitter.open()
        try nodes.forEach(emitter.serialize)
        try emitter.close()
        #if USE_UTF8
            return String(data: emitter.data, encoding: .utf8)!
        #else
            return String(data: emitter.data, encoding: .utf16)!
        #endif
}

/// Produce YAML String from `Node`
///
/// - Parameters:
///   - node: `Node`
///   - canonical: output should be the "canonical" format as in the YAML specification.
///   - indent: the intendation increment.
///   - width: the preferred line width. @c -1 means unlimited.
///   - allowUnicode: unescaped non-ASCII characters are allowed if true.
///   - lineBreak: preferred line break.
///   - explicitStart: explicit document start `---`
///   - explicitEnd: explicit document end `...`
///   - version: YAML version directive
/// - Returns: YAML String
/// - Throws: `YamlError`
public func serialize(
    node: Node,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil) throws -> String {
    return try serialize(
        nodes: [node],
        canonical: canonical,
        indent: indent,
        width: width,
        allowUnicode: allowUnicode,
        lineBreak: lineBreak,
        explicitStart: explicitStart,
        explicitEnd: explicitEnd,
        version: version)
}

public final class Emitter {
    public enum LineBreak {
        /// Use CR for line breaks (Mac style).
        case cr // swiftlint:disable:this identifier_name
        /// Use LN for line breaks (Unix style).
        case ln // swiftlint:disable:this identifier_name
        /// Use CR LN for line breaks (DOS style).
        case crln
    }

    public var data = Data()

    let documentStartImplicit: Int32
    let documentEndImplicit: Int32
    let version: (major: Int, minor: Int)?

    public init(canonical: Bool = false,
                indent: Int = 0,
                width: Int = 0,
                allowUnicode: Bool = false,
                lineBreak: LineBreak = .ln,
                explicitStart: Bool = false,
                explicitEnd: Bool = false,
                version: (major: Int, minor: Int)? = nil) {
        documentStartImplicit = explicitStart ? 0 : 1
        documentEndImplicit = explicitStart ? 0 : 1
        self.version = version

        // configure emitter
        yaml_emitter_initialize(&emitter)

        yaml_emitter_set_output(&self.emitter, { pointer, buffer, size in
            guard let buffer = buffer else { return 0 }
            let emitter = unsafeBitCast(pointer, to: Emitter.self)
            emitter.data.append(buffer, count: size)
            return 1
        }, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))

        yaml_emitter_set_canonical(&emitter, canonical ? 1 : 0)
        yaml_emitter_set_indent(&emitter, Int32(indent))
        yaml_emitter_set_width(&emitter, Int32(width))
        yaml_emitter_set_unicode(&emitter, allowUnicode ? 1 : 0)
        switch lineBreak {
        case .cr: yaml_emitter_set_break(&emitter, YAML_CR_BREAK)
        case .ln: yaml_emitter_set_break(&emitter, YAML_LN_BREAK)
        case .crln: yaml_emitter_set_break(&emitter, YAML_CRLN_BREAK)
        }

        #if USE_UTF8
            yaml_emitter_set_encoding(&emitter, YAML_UTF8_ENCODING)
        #else
            yaml_emitter_set_encoding(&emitter, isLittleEndian ? YAML_UTF16LE_ENCODING : YAML_UTF16BE_ENCODING)
        #endif
    }

    deinit {
        yaml_emitter_delete(&emitter)
    }

    public func open() throws {
        switch state {
        case .initialized:
            var event = yaml_event_t()
            #if USE_UTF8
                yaml_stream_start_event_initialize(&event, YAML_UTF8_ENCODING)
            #else
                let encoding = isLittleEndian ? YAML_UTF16LE_ENCODING : YAML_UTF16BE_ENCODING
                yaml_stream_start_event_initialize(&event, encoding)
            #endif
            try emit(&event)
            state = .opened
        case .opened:
            throw YamlError.emitter(problem: "serializer is already opened")
        case .closed:
            throw YamlError.emitter(problem: "serializer is closed")
        }
    }

    public func close() throws {
        switch state {
        case .initialized:
            throw YamlError.emitter(problem: "serializer is not opened")
        case .opened:
            var event = yaml_event_t()
            yaml_stream_end_event_initialize(&event)
            try emit(&event)
            state = .closed
        case .closed:
            break // do nothing
        }
    }

    public func serialize(node: Node) throws {
        switch state {
        case .initialized:
            throw YamlError.emitter(problem: "serializer is not opened")
        case .opened:
            break
        case .closed:
            throw YamlError.emitter(problem: "serializer is closed")
        }
        var event = yaml_event_t()
        var versionDirective: UnsafeMutablePointer<yaml_version_directive_t>?
        var versionDirectiveValue = yaml_version_directive_t()
        if let (major, minor) = version {
            versionDirectiveValue.major = Int32(major)
            versionDirectiveValue.minor = Int32(minor)
            versionDirective = UnsafeMutablePointer(&versionDirectiveValue)
        }
        // TODO: Support tags
        yaml_document_start_event_initialize(&event, versionDirective, nil, nil, documentStartImplicit)
        try emit(&event)
        try serializeNode(node)
        yaml_document_end_event_initialize(&event, documentEndImplicit)
        try emit(&event)
    }

    // private
    fileprivate var emitter = yaml_emitter_t()

    fileprivate enum State { case initialized, opened, closed }
    fileprivate var state: State = .initialized
}

// MARK: implementation details
extension Emitter {
    fileprivate func emit(_ event: UnsafeMutablePointer<yaml_event_t>) throws {
        guard yaml_emitter_emit(&emitter, event) == 1 else {
            throw YamlError(from: emitter)
        }
    }

    fileprivate func serializeNode(_ node: Node) throws {
        switch node {
        case .scalar: try serializeScalarNode(node)
        case .sequence: try serializeSequenceNode(node)
        case .mapping: try serializeMappingNode(node)
        }
    }

    private func serializeScalarNode(_ node: Node) throws {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        let scalar = node.scalar!
        var value = scalar.string.utf8CString, tag = node.tag.name.rawValue.utf8CString
        let scalar_style = yaml_scalar_style_t(rawValue: scalar.style.rawValue)
        var event = yaml_event_t()
        _ = value.withUnsafeMutableBytes { value in
            tag.withUnsafeMutableBytes { tag in
                yaml_scalar_event_initialize(
                    &event,
                    nil,
                    tag.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    value.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    Int32(value.count - 1),
                    1,
                    1,
                    scalar_style)
            }
        }
        try emit(&event)
    }

    private func serializeSequenceNode(_ node: Node) throws {
        assert(node.isSequence) // swiftlint:disable:next force_unwrapping
        var sequence = node.sequence!, tag = node.tag.name.rawValue.utf8CString
        let implicit: Int32 = node.tag.name == .seq ? 1 : 0
        let sequence_style = yaml_sequence_style_t(rawValue: sequence.style.rawValue)
        var event = yaml_event_t()
        _ = tag.withUnsafeMutableBytes { tag in
            yaml_sequence_start_event_initialize(
                &event,
                nil,
                tag.baseAddress?.assumingMemoryBound(to: UInt8.self),
                implicit,
                sequence_style)
        }
        try emit(&event)
        try sequence.forEach(self.serializeNode)
        yaml_sequence_end_event_initialize(&event)
        try emit(&event)
    }

    private func serializeMappingNode(_ node: Node) throws {
        assert(node.isMapping) // swiftlint:disable:next force_unwrapping
        let mapping = node.mapping!
        var tag = node.tag.name.rawValue.utf8CString
        let implicit: Int32 = node.tag.name == Tag.Name.map ? 1 : 0
        let mapping_style = yaml_mapping_style_t(rawValue: mapping.style.rawValue)
        var event = yaml_event_t()
        _ = tag.withUnsafeMutableBytes { tag in
            yaml_mapping_start_event_initialize(
                &event,
                nil,
                tag.baseAddress?.assumingMemoryBound(to: UInt8.self),
                implicit,
                mapping_style)
        }
        try emit(&event)
        try mapping.forEach {
            try self.serializeNode($0.key)
            try self.serializeNode($0.value)
        }
        yaml_mapping_end_event_initialize(&event)
        try emit(&event)
    }
}

private let isLittleEndian = 1 == 1.littleEndian
