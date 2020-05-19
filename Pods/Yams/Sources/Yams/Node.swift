//
//  Node.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

/// YAML Node.
public enum Node {
    /// Scalar node.
    case scalar(Scalar)
    /// Mapping node.
    case mapping(Mapping)
    /// Sequence node.
    case sequence(Sequence)
}

extension Node {
    /// Create a `Node.scalar` with a string, tag & scalar style.
    ///
    /// - parameter string: String value for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ string: String, _ tag: Tag = .implicit, _ style: Scalar.Style = .any) {
        self = .scalar(.init(string, tag, style))
    }

    /// Create a `Node.mapping` with a sequence of node pairs, tag & scalar style.
    ///
    /// - parameter pairs:  Pairs of nodes to use for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ pairs: [(Node, Node)], _ tag: Tag = .implicit, _ style: Mapping.Style = .any) {
        self = .mapping(.init(pairs, tag, style))
    }

    /// Create a `Node.sequence` with a sequence of nodes, tag & scalar style.
    ///
    /// - parameter nodes:  Sequence of nodes to use for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ nodes: [Node], _ tag: Tag = .implicit, _ style: Sequence.Style = .any) {
        self = .sequence(.init(nodes, tag, style))
    }
}

// MARK: - Public Node Members

extension Node {
    /// The tag for this node.
    ///
    /// - note: Accessing this property causes the tag to be resolved by tag.resolver.
    public var tag: Tag {
        switch self {
        case let .scalar(scalar): return scalar.resolvedTag
        case let .mapping(mapping): return mapping.resolvedTag
        case let .sequence(sequence): return sequence.resolvedTag
        }
    }

    /// The location for this node.
    public var mark: Mark? {
        switch self {
        case let .scalar(scalar): return scalar.mark
        case let .mapping(mapping): return mapping.mark
        case let .sequence(sequence): return sequence.mark
        }
    }

    // MARK: - Typed accessor properties

    /// This node as an `Any`, if convertible.
    public var any: Any {
        return tag.constructor.any(from: self)
    }

    /// This node as a `String`, if convertible.
    public var string: String? {
        return String.construct(from: self)
    }

    /// This node as a `Bool`, if convertible.
    public var bool: Bool? {
        return scalar.flatMap(Bool.construct)
    }

    /// This node as a `Double`, if convertible.
    public var float: Double? {
        return scalar.flatMap(Double.construct)
    }

    /// This node as an `NSNull`, if convertible.
    public var null: NSNull? {
        return scalar.flatMap(NSNull.construct)
    }

    /// This node as an `Int`, if convertible.
    public var int: Int? {
        return scalar.flatMap(Int.construct)
    }

    /// This node as a `Data`, if convertible.
    public var binary: Data? {
        return scalar.flatMap(Data.construct)
    }

    /// This node as a `Date`, if convertible.
    public var timestamp: Date? {
        return scalar.flatMap(Date.construct)
    }

    /// This node as a `UUID`, if convertible.
    public var uuid: UUID? {
        return scalar.flatMap(UUID.construct)
    }

    // MARK: Typed accessor methods

    /// Returns this node mapped as an `Array<Node>`. If the node isn't a `Node.sequence`, the array will be
    /// empty.
    public func array() -> [Node] {
        return sequence.map(Array.init) ?? []
    }

    /// Typed Array using type parameter: e.g. `array(of: String.self)`.
    ///
    /// - parameter type: Type conforming to `ScalarConstructible`.
    ///
    /// - returns: Array of `Type`.
    public func array<Type: ScalarConstructible>(of type: Type.Type = Type.self) -> [Type] {
        return sequence?.compactMap { $0.scalar.flatMap(type.construct) } ?? []
    }

    /// If the node is a `.sequence` or `.mapping`, set or get the specified `Node`.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(node: Node) -> Node? {
        get {
            switch self {
            case .scalar: return nil
            case let .mapping(mapping):
                return mapping[node]
            case let .sequence(sequence):
                guard let index = node.int, sequence.indices ~= index else { return nil }
                return sequence[index]
            }
        }
        set {
            guard let newValue = newValue else { return }
            switch self {
            case .scalar: return
            case .mapping(var mapping):
                mapping[node] = newValue
                self = .mapping(mapping)
            case .sequence(var sequence):
                guard let index = node.int, sequence.indices ~= index else { return}
                sequence[index] = newValue
                self = .sequence(sequence)
            }
        }
    }

    /// If the node is a `.sequence` or `.mapping`, set or get the specified parameter's `Node`
    /// representation.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(representable: NodeRepresentable) -> Node? {
        get {
            guard let node = try? representable.represented() else { return nil }
            return self[node]
        }
        set {
            guard let node = try? representable.represented() else { return }
            self[node] = newValue
        }
    }

    /// If the node is a `.sequence` or `.mapping`, set or get the specified string's `Node` representation.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(string: String) -> Node? {
        get {
            return self[Node(string, tag.copy(with: .implicit))]
        }
        set {
            self[Node(string, tag.copy(with: .implicit))] = newValue
        }
    }
}

// MARK: Hashable

extension Node: Hashable {
#if !swift(>=4.1.50)
    /// This `Node`'s Hashable `hashValue`.
    public var hashValue: Int {
        switch self {
        case let .scalar(scalar):
            return scalar.string.hashValue
        case let .mapping(mapping):
            return mapping.count
        case let .sequence(sequence):
            return sequence.count
        }
    }

    /// Returns true if both nodes are equal.
    ///
    /// - parameter lhs: The left hand side Node to compare.
    /// - parameter rhs: The right hand side Node to compare.
    ///
    /// - returns: True if both nodes are equal.
    public static func == (lhs: Node, rhs: Node) -> Bool {
        switch (lhs, rhs) {
        case let (.scalar(lhs), .scalar(rhs)):
            return lhs == rhs
        case let (.mapping(lhs), .mapping(rhs)):
            return lhs == rhs
        case let (.sequence(lhs), .sequence(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
#endif
}

// MARK: Comparable

extension Node: Comparable {
    /// Returns true if `lhs` is ordered before `rhs`.
    ///
    /// - parameter lhs: The left hand side Node to compare.
    /// - parameter rhs: The right hand side Node to compare.
    ///
    /// - returns: True if `lhs` is ordered before `rhs`.
    public static func < (lhs: Node, rhs: Node) -> Bool {
        switch (lhs, rhs) {
        case let (.scalar(lhs), .scalar(rhs)):
            return lhs < rhs
        case let (.mapping(lhs), .mapping(rhs)):
            return lhs < rhs
        case let (.sequence(lhs), .sequence(rhs)):
            return lhs < rhs
        default:
            return false
        }
    }
}

extension Array where Element: Comparable {
    static func < (lhs: Array, rhs: Array) -> Bool {
        for (lhs, rhs) in zip(lhs, rhs) {
            if lhs < rhs {
                return true
            } else if lhs > rhs {
                return false
            }
        }
        return lhs.count < rhs.count
    }
}

// MARK: - ExpressibleBy*Literal

extension Node: ExpressibleByArrayLiteral {
    /// Create a `Node.sequence` from an array literal of `Node`s.
    public init(arrayLiteral elements: Node...) {
        self = .sequence(.init(elements))
    }
}

extension Node: ExpressibleByDictionaryLiteral {
    /// Create a `Node.mapping` from a dictionary literal of `Node`s.
    public init(dictionaryLiteral elements: (Node, Node)...) {
        self = Node(elements)
    }
}

extension Node: ExpressibleByFloatLiteral {
    /// Create a `Node.scalar` from a float literal.
    public init(floatLiteral value: Double) {
        self.init(String(value), Tag(.float))
    }
}

extension Node: ExpressibleByIntegerLiteral {
    /// Create a `Node.scalar` from an integer literal.
    public init(integerLiteral value: Int) {
        self.init(String(value), Tag(.int))
    }
}

extension Node: ExpressibleByStringLiteral {
    /// Create a `Node.scalar` from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

// MARK: - internal

extension Node {
    // MARK: Internal convenience accessors

    var isMapping: Bool {
        if case .mapping = self {
            return true
        }
        return false
    }

    var isSequence: Bool {
        if case .sequence = self {
            return true
        }
        return false
    }
}
