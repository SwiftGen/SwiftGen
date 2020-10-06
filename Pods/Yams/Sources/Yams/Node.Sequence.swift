//
//  Node.Sequence.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

// MARK: Node+Sequence

extension Node {
    /// Sequence node.
    public struct Sequence {
        private var nodes: [Node]
        /// This node's tag (its type).
        public var tag: Tag
        /// The style to be used when emitting this node.
        public var style: Style
        /// The location for this node.
        public var mark: Mark?

        /// The style to use when emitting a `Sequence`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any
            /// The block sequence style.
            case block
            /// The flow sequence style.
            case flow
        }

        /// Create a `Node.Sequence` using the specified parameters.
        ///
        /// - parameter nodes: The array of nodes to generate this sequence.
        /// - parameter tag:   This sequence's `Tag`.
        /// - parameter style: The style to use when emitting this `Sequence`.
        /// - parameter mark:  This sequence's `Mark`.
        public init(_ nodes: [Node], _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.nodes = nodes
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

    /// Get or set the `Node.Sequence` value if this node is a `Node.sequence`.
    public var sequence: Sequence? {
        get {
            if case let .sequence(sequence) = self {
                return sequence
            }
            return nil
        }
        set {
            if let newValue = newValue {
                self = .sequence(newValue)
            }
        }
    }
}

// MARK: - Node.Sequence

extension Node.Sequence: Comparable {
    /// :nodoc:
    public static func < (lhs: Node.Sequence, rhs: Node.Sequence) -> Bool {
        return lhs.nodes < rhs.nodes
    }
}

extension Node.Sequence: Equatable {
    /// :nodoc:
    public static func == (lhs: Node.Sequence, rhs: Node.Sequence) -> Bool {
        return lhs.nodes == rhs.nodes && lhs.resolvedTag == rhs.resolvedTag
    }
}

extension Node.Sequence: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(nodes)
        hasher.combine(resolvedTag)
    }
}

extension Node.Sequence: ExpressibleByArrayLiteral {
    /// :nodoc:
    public init(arrayLiteral elements: Node...) {
        self.init(elements)
    }
}

extension Node.Sequence: MutableCollection {
    // Sequence
    /// :nodoc:
    public func makeIterator() -> Array<Node>.Iterator {
        return nodes.makeIterator()
    }

    // Collection
    /// :nodoc:
    public typealias Index = Array<Node>.Index

    /// :nodoc:
    public var startIndex: Index {
        return nodes.startIndex
    }

    /// :nodoc:
    public var endIndex: Index {
        return nodes.endIndex
    }

    /// :nodoc:
    public func index(after index: Index) -> Index {
        return nodes.index(after: index)
    }

    /// :nodoc:
    public subscript(index: Index) -> Node {
        get {
            return nodes[index]
        }
        // MutableCollection
        set {
            nodes[index] = newValue
        }
    }

    /// :nodoc:
    public subscript(bounds: Range<Index>) -> Array<Node>.SubSequence {
        get {
            return nodes[bounds]
        }
        // MutableCollection
        set {
            nodes[bounds] = newValue
        }
    }

    /// :nodoc:
    public var indices: Array<Node>.Indices {
        return nodes.indices
    }
}

extension Node.Sequence: RandomAccessCollection {
    // BidirectionalCollection
    /// :nodoc:
    public func index(before index: Index) -> Index {
        return nodes.index(before: index)
    }

    // RandomAccessCollection
    /// :nodoc:
    public func index(_ index: Index, offsetBy num: Int) -> Index {
        return nodes.index(index, offsetBy: num)
    }

    /// :nodoc:
    public func distance(from start: Index, to end: Int) -> Index {
        return nodes.distance(from: start, to: end)
    }
}

extension Node.Sequence: RangeReplaceableCollection {
    /// :nodoc:
    public init() {
        self.init([])
    }

    /// :nodoc:
    public mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C)
        where C: Collection, C.Iterator.Element == Node {
            nodes.replaceSubrange(subrange, with: newElements)
    }
}

extension Node.Sequence: TagResolvable {
    static let defaultTagName = Tag.Name.seq
}
