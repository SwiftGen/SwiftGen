//
//  Node.Mapping.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

extension Node {
    /// A mapping is the YAML equivalent of a `Dictionary`.
    public struct Mapping {
        private var pairs: [Pair<Node>]
        /// This mapping's `Tag`.
        public var tag: Tag
        /// The style to use when emitting this `Mapping`.
        public var style: Style
        /// This mapping's `Mark`.
        public var mark: Mark?

        /// The style to use when emitting a `Mapping`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any
            /// The block mapping style.
            case block
            /// The flow mapping style.
            case flow
        }

        /// Create a `Node.Mapping` using the specified parameters.
        ///
        /// - parameter pairs: The array of `(Node, Node)` tuples to generate this mapping.
        /// - parameter tag:   This mapping's `Tag`.
        /// - parameter style: The style to use when emitting this `Mapping`.
        /// - parameter mark:  This mapping's `Mark`.
        public init(_ pairs: [(Node, Node)], _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.pairs = pairs.map { Pair($0.0, $0.1) }
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

    /// Get or set the `Node.Mapping` value if this node is a `Node.mapping`.
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
    /// :nodoc:
    public static func < (lhs: Node.Mapping, rhs: Node.Mapping) -> Bool {
        return lhs.pairs < rhs.pairs
    }
}

extension Node.Mapping: Equatable {
    /// :nodoc:
    public static func == (lhs: Node.Mapping, rhs: Node.Mapping) -> Bool {
        return lhs.pairs == rhs.pairs && lhs.resolvedTag == rhs.resolvedTag
    }
}

#if swift(>=4.1.50)
extension Node.Mapping: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pairs)
        hasher.combine(resolvedTag)
    }
}
#endif

extension Node.Mapping: ExpressibleByDictionaryLiteral {
    /// :nodoc:
    public init(dictionaryLiteral elements: (Node, Node)...) {
        self.init(elements)
    }
}

// MARK: - MutableCollection Conformance

extension Node.Mapping: MutableCollection {
    /// :nodoc:
    public typealias Element = (key: Node, value: Node)

    // MARK: Sequence

    /// :nodoc:
    public func makeIterator() -> Array<Element>.Iterator {
        return pairs.map(Pair.toTuple).makeIterator()
    }

    // MARK: Collection

    /// The index type for this mapping.
    public typealias Index = Array<Element>.Index

    /// :nodoc:
    public var startIndex: Index {
        return pairs.startIndex
    }

    /// :nodoc:
    public var endIndex: Index {
        return pairs.endIndex
    }

    /// :nodoc:
    public func index(after index: Index) -> Index {
        return pairs.index(after: index)
    }

    /// :nodoc:
    public subscript(index: Index) -> Element {
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

// MARK: - Merge support

extension Node.Mapping {
    func flatten() -> Node.Mapping {
        var pairs = Array(self)
        var merge = [(key: Node, value: Node)]()
        var index = pairs.startIndex
        while index < pairs.count {
            let pair = pairs[index]
            if pair.key.tag.name == .merge {
                pairs.remove(at: index)
                switch pair.value {
                case .mapping(let mapping):
                    merge.append(contentsOf: mapping.flatten())
                case let .sequence(sequence):
                    let submerge = sequence
                        .compactMap { $0.mapping.map { $0.flatten() } }
                        .reversed()
                    submerge.forEach {
                        merge.append(contentsOf: $0)
                    }
                default:
                    break // TODO: Should raise error on other than mapping or sequence
                }
            } else if pair.key.tag.name == .value {
                pair.key.tag.name = .str
                index += 1
            } else {
                index += 1
            }
        }
        return Node.Mapping(merge + pairs, tag, style)
    }
}

// MARK: - Dictionary-like APIs

extension Node.Mapping {
    /// This mapping's keys. Similar to `Dictionary.keys`.
    public var keys: LazyMapCollection<Node.Mapping, Node> {
        return lazy.map { $0.key }
    }

    /// This mapping's values. Similar to `Dictionary.values`.
    public var values: LazyMapCollection<Node.Mapping, Node> {
        return lazy.map { $0.value }
    }

    /// Set or get the `Node` for the specified string's `Node` representation.
    public subscript(string: String) -> Node? {
        get {
            return self[Node(string, tag.copy(with: .implicit))]
        }
        set {
            self[Node(string, tag.copy(with: .implicit))] = newValue
        }
    }

    /// Set or get the specified `Node`.
    public subscript(node: Node) -> Node? {
        get {
            return pairs.reversed().first(where: { $0.key == node })?.value
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

    /// Get the index of the specified `Node`, if it exists in the mapping.
    public func index(forKey key: Node) -> Index? {
    #if swift(>=5.0)
        return pairs.reversed().firstIndex(where: { $0.key == key }).map({ pairs.index(before: $0.base) })
    #else
        return pairs.reversed().index(where: { $0.key == key }).map({ pairs.index(before: $0.base) })
    #endif
    }
}

private struct Pair<Value: Comparable & Equatable>: Comparable, Equatable {
    let key: Value
    let value: Value

    init(_ key: Value, _ value: Value) {
        self.key = key
        self.value = value
    }

#if !swift(>=4.1.50)
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
#endif

    static func < (lhs: Pair<Value>, rhs: Pair<Value>) -> Bool {
        return lhs.key < rhs.key
    }

    static func toTuple(pair: Pair) -> (key: Value, value: Value) {
        return (key: pair.key, value: pair.value)
    }
}

#if swift(>=4.1.50)
extension Pair: Hashable where Value: Hashable {}
#endif
