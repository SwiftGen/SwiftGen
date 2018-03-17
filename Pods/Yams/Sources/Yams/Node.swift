//
//  Node.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

public enum Node {
    case scalar(Scalar)
    case mapping(Mapping)
    case sequence(Sequence)
}

extension Node {
    public init(_ string: String, _ tag: Tag = .implicit, _ style: Scalar.Style = .any) {
        self = .scalar(.init(string, tag, style))
    }

    public init(_ pairs: [(Node, Node)], _ tag: Tag = .implicit, _ style: Mapping.Style = .any) {
        self = .mapping(.init(pairs, tag, style))
    }

    public init(_ nodes: [Node], _ tag: Tag = .implicit, _ style: Sequence.Style = .any) {
        self = .sequence(.init(nodes, tag, style))
    }
}

extension Node {
    /// Accessing this property causes the tag to be resolved by tag.resolver.
    public var tag: Tag {
        switch self {
        case let .scalar(scalar): return scalar.resolvedTag
        case let .mapping(mapping): return mapping.resolvedTag
        case let .sequence(sequence): return sequence.resolvedTag
        }
    }

    public var mark: Mark? {
        switch self {
        case let .scalar(scalar): return scalar.mark
        case let .mapping(mapping): return mapping.mark
        case let .sequence(sequence): return sequence.mark
        }
    }

    // MARK: typed accessor properties
    public var any: Any {
        return tag.constructor.any(from: self)
    }

    public var string: String? {
        return String.construct(from: self)
    }

    public var bool: Bool? {
        return scalar.flatMap(Bool.construct)
    }

    public var float: Double? {
        return scalar.flatMap(Double.construct)
    }

    public var null: NSNull? {
        return scalar.flatMap(NSNull.construct)
    }

    public var int: Int? {
        return scalar.flatMap(Int.construct)
    }

    public var binary: Data? {
        return scalar.flatMap(Data.construct)
    }

    public var timestamp: Date? {
        return scalar.flatMap(Date.construct)
    }

    // MARK: Typed accessor methods

    /// - Returns: Array of `Node`
    public func array() -> [Node] {
        return sequence.map(Array.init) ?? []
    }

    /// Typed Array using type parameter: e.g. `array(of: String.self)`
    ///
    /// - Parameter type: Type conforms to ScalarConstructible
    /// - Returns: Array of `Type`
    public func array<Type: ScalarConstructible>(of type: Type.Type = Type.self) -> [Type] {
        return sequence?.compactMap { $0.scalar.flatMap(type.construct) } ?? []
    }

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
}

extension Node: Comparable {
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
    public init(arrayLiteral elements: Node...) {
        self = .sequence(.init(elements))
    }
}

extension Node: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Node, Node)...) {
        self = Node(elements)
    }
}

extension Node: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(String(value), Tag(.float))
    }
}

extension Node: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(String(value), Tag(.int))
    }
}

extension Node: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

// MARK: - internal

extension Node {
    // MARK: Internal convenience accessors
    var isScalar: Bool {
        if case .scalar = self {
            return true
        }
        return false
    }

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
