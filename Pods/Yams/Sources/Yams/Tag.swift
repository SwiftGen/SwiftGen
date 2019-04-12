//
//  Tag.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
import CYaml
#endif

/// Tags describe the the _type_ of a Node.
public final class Tag {
    /// Tag name.
    public struct Name: RawRepresentable {
        /// This `Tag.Name`'s raw string value.
        public let rawValue: String
        /// Create a `Tag.Name` with a raw string value.
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    /// Shorthand accessor for `Tag(.implicit)`.
    public static var implicit: Tag {
        return Tag(.implicit)
    }

    /// Create a `Tag` with the specified name, resolver and constructor.
    ///
    /// - parameter name:        Tag name.
    /// - parameter resolver:    `Resolver` this tag should use, `.default` if omitted.
    /// - parameter constructor: `Constructor` this tag should use, `.default` if omitted.
    public init(_ name: Name,
                _ resolver: Resolver = .default,
                _ constructor: Constructor = .default) {
        self.resolver = resolver
        self.constructor = constructor
        self.name = name
    }

    /// Lens returning a copy of the current `Tag` with the specified overridden changes.
    ///
    /// - note: Omitting or passing nil for a parameter will preserve the current `Tag`'s value in the copy.
    ///
    /// - parameter name:        Overridden tag name.
    /// - parameter resolver:    Overridden resolver.
    /// - parameter constructor: Overridden constructor.
    ///
    /// - returns: A copy of the current `Tag` with the specified overridden changes.
    public func copy(with name: Name? = nil, resolver: Resolver? = nil, constructor: Constructor? = nil) -> Tag {
        return .init(name ?? self.name, resolver ?? self.resolver, constructor ?? self.constructor)
    }

    // internal
    let constructor: Constructor
    var name: Name

    func resolved<T>(with value: T) -> Tag where T: TagResolvable {
        if name == .implicit {
            name = resolver.resolveTag(of: value)
        } else if name == .nonSpecific {
            name = T.defaultTagName
        }
        return self
    }

    // private
    private let resolver: Resolver
}

extension Tag: CustomStringConvertible {
    /// A textual representation of this tag.
    public var description: String {
        return name.rawValue
    }
}

extension Tag: Hashable {
#if swift(>=4.1.50)
    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
#else
    /// :nodoc:
    public var hashValue: Int {
        return name.hashValue
    }
#endif

    /// :nodoc:
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Tag.Name: ExpressibleByStringLiteral {
    /// :nodoc:
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension Tag.Name: Hashable {
#if !swift(>=4.1.50)
    /// :nodoc:
    public var hashValue: Int {
        return rawValue.hashValue
    }

    /// :nodoc:
    public static func == (lhs: Tag.Name, rhs: Tag.Name) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
#endif
}

// http://www.yaml.org/spec/1.2/spec.html#Schema
extension Tag.Name {
    // Special
    /// Tag should be resolved by value.
    public static let implicit: Tag.Name = ""
    /// Tag should not be resolved by value, and be resolved as .str, .seq or .map.
    public static let nonSpecific: Tag.Name = "!"

    // Failsafe Schema
    /// "tag:yaml.org,2002:str" <http://yaml.org/type/str.html>
    public static let str: Tag.Name = "tag:yaml.org,2002:str"
    /// "tag:yaml.org,2002:seq" <http://yaml.org/type/seq.html>
    public static let seq: Tag.Name  = "tag:yaml.org,2002:seq"
    /// "tag:yaml.org,2002:map" <http://yaml.org/type/map.html>
    public static let map: Tag.Name  = "tag:yaml.org,2002:map"
    // JSON Schema
    /// "tag:yaml.org,2002:bool" <http://yaml.org/type/bool.html>
    public static let bool: Tag.Name  = "tag:yaml.org,2002:bool"
    /// "tag:yaml.org,2002:float" <http://yaml.org/type/float.html>
    public static let float: Tag.Name  =  "tag:yaml.org,2002:float"
    /// "tag:yaml.org,2002:null" <http://yaml.org/type/null.html>
    public static let null: Tag.Name  = "tag:yaml.org,2002:null"
    /// "tag:yaml.org,2002:int" <http://yaml.org/type/int.html>
    public static let int: Tag.Name  = "tag:yaml.org,2002:int"
    // http://yaml.org/type/index.html
    /// "tag:yaml.org,2002:binary" <http://yaml.org/type/binary.html>
    public static let binary: Tag.Name  = "tag:yaml.org,2002:binary"
    /// "tag:yaml.org,2002:merge" <http://yaml.org/type/merge.html>
    public static let merge: Tag.Name  = "tag:yaml.org,2002:merge"
    /// "tag:yaml.org,2002:omap" <http://yaml.org/type/omap.html>
    public static let omap: Tag.Name  = "tag:yaml.org,2002:omap"
    /// "tag:yaml.org,2002:pairs" <http://yaml.org/type/pairs.html>
    public static let pairs: Tag.Name  = "tag:yaml.org,2002:pairs"
    /// "tag:yaml.org,2002:set". <http://yaml.org/type/set.html>
    public static let set: Tag.Name  = "tag:yaml.org,2002:set"
    /// "tag:yaml.org,2002:timestamp" <http://yaml.org/type/timestamp.html>
    public static let timestamp: Tag.Name  = "tag:yaml.org,2002:timestamp"
    /// "tag:yaml.org,2002:value" <http://yaml.org/type/value.html>
    public static let value: Tag.Name  = "tag:yaml.org,2002:value"
    /// "tag:yaml.org,2002:yaml" <http://yaml.org/type/yaml.html> We don't support this.
    public static let yaml: Tag.Name  = "tag:yaml.org,2002:yaml"
}

protocol TagResolvable {
    var tag: Tag { get }
    static var defaultTagName: Tag.Name { get }
    func resolveTag(using resolver: Resolver) -> Tag.Name
}

extension TagResolvable {
    var resolvedTag: Tag {
        return tag.resolved(with: self)
    }

    func resolveTag(using resolver: Resolver) -> Tag.Name {
        return tag.name == .implicit ? Self.defaultTagName : tag.name
    }
}
