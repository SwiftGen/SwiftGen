//
//  Node.Sequence.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

extension Node {
    public struct Sequence {
        fileprivate var nodes: [Node]
        public var tag: Tag
        public var style: Style
        public var mark: Mark?

        public enum Style: UInt32 { // swiftlint:disable:this nesting
            /// Let the emitter choose the style.
            case any
            /// The block sequence style.
            case block
            /// The flow sequence style.
            case flow
        }

        public init(_ nodes: [Node], _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.nodes = nodes
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

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
    public static func < (lhs: Node.Sequence, rhs: Node.Sequence) -> Bool {
        return lhs.nodes < rhs.nodes
    }
}

extension Node.Sequence: Equatable {
    public static func == (lhs: Node.Sequence, rhs: Node.Sequence) -> Bool {
        return lhs.nodes == rhs.nodes && lhs.resolvedTag == rhs.resolvedTag
    }
}

extension Node.Sequence: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Node...) {
        self.init(elements)
    }
}

extension Node.Sequence: MutableCollection {
    // Sequence
    public func makeIterator() -> Array<Node>.Iterator {
        return nodes.makeIterator()
    }

    // Collection
    public typealias Index = Array<Node>.Index

    public var startIndex: Index {
        return nodes.startIndex
    }

    public var endIndex: Index {
        return nodes.endIndex
    }

    public func index(after index: Index) -> Index {
        return nodes.index(after: index)
    }

    public subscript(index: Index) -> Node {
        get {
            return nodes[index]
        }
        // MutableCollection
        set {
            nodes[index] = newValue
        }
    }

    public subscript(bounds: Range<Index>) -> Array<Node>.SubSequence {
        get {
            return nodes[bounds]
        }
        // MutableCollection
        set {
            nodes[bounds] = newValue
        }
    }

    public var indices: Array<Node>.Indices {
        return nodes.indices
    }
}

extension Node.Sequence: RandomAccessCollection {
    // BidirectionalCollection
    public func index(before index: Index) -> Index {
        return nodes.index(before: index)
    }

    // RandomAccessCollection
    public func index(_ index: Index, offsetBy num: Int) -> Index {
        return nodes.index(index, offsetBy: num)
    }

    public func distance(from start: Index, to end: Int) -> Index {
        return nodes.distance(from: start, to: end)
    }
}

extension Node.Sequence: RangeReplaceableCollection {
    public init() {
        self.init([])
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
        where C : Collection, C.Iterator.Element == Node {
            nodes.replaceSubrange(subrange, with: newElements)
    }
}

extension Node.Sequence: TagResolvable {
    static let defaultTagName = Tag.Name.seq
}
