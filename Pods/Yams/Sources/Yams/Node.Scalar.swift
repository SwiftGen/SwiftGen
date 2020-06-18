//
//  Node.Scalar.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

// MARK: Node+Scalar

extension Node {
    /// Scalar node.
    public struct Scalar {
        /// This node's string value.
        public var string: String {
            didSet {
                tag = .implicit
            }
        }
        /// This node's tag (its type).
        public var tag: Tag
        /// The style to be used when emitting this node.
        public var style: Style
        /// The location for this node.
        public var mark: Mark?

        /// The style to use when emitting a `Scalar`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any = 0
            /// The plain scalar style.
            case plain

            /// The single-quoted scalar style.
            case singleQuoted
            /// The double-quoted scalar style.
            case doubleQuoted

            /// The literal scalar style.
            case literal
            /// The folded scalar style.
            case folded
        }

        /// Create a `Node.Scalar` using the specified parameters.
        ///
        /// - parameter string: The string to generate this scalar.
        /// - parameter tag:    This scalar's `Tag`.
        /// - parameter style:  The style to use when emitting this `Scalar`.
        /// - parameter mark:   This scalar's `Mark`.
        public init(_ string: String, _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.string = string
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

    /// Get or set the `Node.Scalar` value if this node is a `Node.scalar`.
    public var scalar: Scalar? {
        get {
            if case let .scalar(scalar) = self {
                return scalar
            }
            return nil
        }
        set {
            if let newValue = newValue {
                self = .scalar(newValue)
            }
        }
    }
}

extension Node.Scalar: Comparable {
    /// :nodoc:
    public static func < (lhs: Node.Scalar, rhs: Node.Scalar) -> Bool {
        return lhs.string < rhs.string
    }
}

extension Node.Scalar: Equatable {
    /// :nodoc:
    public static func == (lhs: Node.Scalar, rhs: Node.Scalar) -> Bool {
        return lhs.string == rhs.string && lhs.resolvedTag == rhs.resolvedTag
    }
}

#if swift(>=4.1.50)
extension Node.Scalar: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
        hasher.combine(resolvedTag)
    }
}
#endif

extension Node.Scalar: TagResolvable {
    static let defaultTagName = Tag.Name.str
    func resolveTag(using resolver: Resolver) -> Tag.Name {
        return tag.name == .implicit ? resolver.resolveTag(from: string) : tag.name
    }
}
