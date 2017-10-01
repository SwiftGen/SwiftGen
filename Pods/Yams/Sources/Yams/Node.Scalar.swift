//
//  Node.Scalar.swift
//  Yams
//
//  Created by Norio Nomura on 2/24/17.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

extension Node {
    public struct Scalar {
        public var string: String {
            didSet {
                tag = .implicit
            }
        }
        public var tag: Tag
        public var style: Style
        public var mark: Mark?

        public enum Style: UInt32 { // swiftlint:disable:this nesting
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

        public init(_ string: String, _ tag: Tag = .implicit, _ style: Style = .any, _ mark: Mark? = nil) {
            self.string = string
            self.tag = tag
            self.style = style
            self.mark = mark
        }
    }

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
    public static func < (lhs: Node.Scalar, rhs: Node.Scalar) -> Bool {
        return lhs.string < rhs.string
    }
}

extension Node.Scalar: Equatable {
    public static func == (lhs: Node.Scalar, rhs: Node.Scalar) -> Bool {
        return lhs.string == rhs.string && lhs.resolvedTag == rhs.resolvedTag
    }
}

extension Node.Scalar: TagResolvable {
    static let defaultTagName = Tag.Name.str
    func resolveTag(using resolver: Resolver) -> Tag.Name {
        return tag.name == .implicit ? resolver.resolveTag(from: string) : tag.name
    }
}
