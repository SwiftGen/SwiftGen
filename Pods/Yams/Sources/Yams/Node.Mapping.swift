//
//  Node.Mapping.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

extension Node {
    public struct Mapping {
        fileprivate var pairs: [Pair<Node>]
        public var tag: Tag
        public var style: Style
        public var mark: Mark?

        public enum Style: UInt32 { // swiftlint:disable:this nesting
            /// Let the emitter choose the style.
            case any
            /// The block mapping style.
            case block
            /// The flow mapping style.
            case flow
        }

        public init(_ pairs: [(Node, Node)], _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.pairs = pairs.map { Pair($0.0, $0.1) }
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

    public var mapping: Mapping? {
        get {
            if case let .mapping(mapping) = self {
                return mapping
            }
            return nil
        }
        set {
            if let newValue = newValue {
                self = .mapping(newValue)
            }
        }
    }
}

extension Node.Mapping: Comparable {
    public static func < (lhs: Node.Mapping, rhs: Node.Mapping) -> Bool {
        return lhs.pairs < rhs.pairs
    }
}

extension Node.Mapping: Equatable {
    public static func == (lhs: Node.Mapping, rhs: Node.Mapping) -> Bool {
        return lhs.pairs == rhs.pairs && lhs.resolvedTag == rhs.resolvedTag
    }
}

extension Node.Mapping: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Node, Node)...) {
        self.init(elements)
    }
}

extension Node.Mapping: MutableCollection {
    public typealias Element = (key: Node, value: Node)

    // Sequence
    public func makeIterator() -> Array<Element>.Iterator {
        let iterator = pairs.map(Pair.toTuple).makeIterator()
        return iterator
    }

    // Collection
    public typealias Index = Array<Element>.Index

    public var startIndex: Int {
        return pairs.startIndex
    }

    public var endIndex: Int {
        return pairs.endIndex
    }

    public func index(after index: Int) -> Int {
        return pairs.index(after:index)
    }

    public subscript(index: Int) -> Element {
        get {
            return (key: pairs[index].key, value: pairs[index].value)
        }
        // MutableCollection
        set {
            pairs[index] = Pair(newValue.key, newValue.value)
        }
    }
}

extension Node.Mapping: TagResolvable {
    static let defaultTagName = Tag.Name.map
}

extension Node.Mapping {
    public var keys: LazyMapCollection<Node.Mapping, Node> {
        return lazy.map { $0.key }
    }

    public var values: LazyMapCollection<Node.Mapping, Node> {
        return lazy.map { $0.value }
    }

    public subscript(string: String) -> Node? {
        get {
            return self[Node(string)]
        }
        set {
            self[Node(string)] = newValue
        }
    }

    public subscript(node: Node) -> Node? {
        get {
            let v = pairs.reversed().first(where: { $0.key == node })
            return v?.value
        }
        set {
            if let newValue = newValue {
                if let index = index(forKey: node) {
                    pairs[index] = Pair(pairs[index].key, newValue)
                } else {
                    pairs.append(Pair(node, newValue))
                }
            } else {
                if let index = index(forKey: node) {
                    pairs.remove(at: index)
                }
            }
        }
    }

    public func index(forKey key: Node) -> Int? {
        return pairs.reversed().index(where: { $0.key == key }).map({ pairs.index(before: $0.base) })
    }
}

private struct Pair<Value: Comparable & Equatable>: Comparable, Equatable {
    let key: Value
    let value: Value

    init(_ key: Value, _ value: Value) {
        self.key = key
        self.value = value
    }

    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }

    static func < (lhs: Pair<Value>, rhs: Pair<Value>) -> Bool {
        return lhs.key < rhs.key
    }

    static func toTuple(pair: Pair) -> (key: Value, value: Value) {
        return (key: pair.key, value: pair.value)
    }
}
