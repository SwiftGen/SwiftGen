//
//  Resolver.swift
//  Yams
//
//  Created by Norio Nomura on 12/15/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

/// Class used to resolve nodes to tags based on customizable rules.
public final class Resolver {
    /// Rule describing how to resolve tags from regex patterns.
    public struct Rule {
        /// The tag name this rule applies to.
        public let tag: Tag.Name
        fileprivate let regexp: NSRegularExpression
        /// The regex pattern used to resolve this rule.
        public var pattern: String { return regexp.pattern }

        /// Create a rule with the specified tag name and regex pattern.
        ///
        /// - parameter tag: The tag name this rule should apply to.
        /// - parameter pattern: The regex pattern used to resolve this rule.
        ///
        /// - throws: Throws an error if the regular expression pattern is invalid.
        public init(_ tag: Tag.Name, _ pattern: String) throws {
            self.tag = tag
            self.regexp = try .init(pattern: pattern, options: [])
        }
    }

    /// The rules used by this resolver to resolve nodes to tags.
    public let rules: [Rule]

    internal init(_ rules: [Rule] = []) { self.rules = rules }

    /// Resolve a tag name from a given node.
    ///
    /// - parameter node: Node whose tag should be resolved.
    ///
    /// - returns: The resolved tag name.
    public func resolveTag(of node: Node) -> Tag.Name {
        switch node {
        case let .scalar(scalar):
            return resolveTag(of: scalar)
        case let .mapping(mapping):
            return resolveTag(of: mapping)
        case let .sequence(sequence):
            return resolveTag(of: sequence)
        }
    }

    /// Returns a Resolver constructed by appending rule.
    public func appending(_ rule: Rule) -> Resolver {
        return .init(rules + [rule])
    }

    /// Returns a Resolver constructed by appending pattern for tag.
    public func appending(_ tag: Tag.Name, _ pattern: String) throws -> Resolver {
        return appending(try Rule(tag, pattern))
    }

    /// Returns a Resolver constructed by replacing rule.
    public func replacing(_ rule: Rule) -> Resolver {
        return .init(rules.map { $0.tag == rule.tag ? rule : $0 })
    }

    /// Returns a Resolver constructed by replacing pattern for tag.
    public func replacing(_ tag: Tag.Name, with pattern: String) throws -> Resolver {
        return .init(try rules.map { $0.tag == tag ? try Rule($0.tag, pattern) : $0 })
    }

    /// Returns a Resolver constructed by removing pattern for tag.
    public func removing(_ tag: Tag.Name) -> Resolver {
        return .init(rules.filter({ $0.tag != tag }))
    }

    // MARK: - internal

    func resolveTag<T>(of value: T) -> Tag.Name where T: TagResolvable {
        return value.resolveTag(using: self)
    }

    func resolveTag(from string: String) -> Tag.Name {
        for rule in rules where rule.regexp.matches(in: string) {
            return rule.tag
        }
        return .str
    }
}

// MARK: Defaults

extension Resolver {
    /// Resolver with no rules.
    public static let basic = Resolver()
    /// Resolver with a default set of rules.
    public static let `default` = Resolver([.bool, .int, .float, .merge, .null, .timestamp, .value])
}

// MARK: Default Resolver Rules

extension Resolver.Rule {
    // swiftlint:disable force_try

    /// Default bool resolver rule.
    public static let bool = try! Resolver.Rule(.bool, """
        ^(?:yes|Yes|YES|no|No|NO\
        |true|True|TRUE|false|False|FALSE\
        |on|On|ON|off|Off|OFF)$
        """)

    /// Default int resolver rule.
    public static let int = try! Resolver.Rule(.int, """
        ^(?:[-+]?0b[0-1_]+\
        |[-+]?0o?[0-7_]+\
        |[-+]?(?:0|[1-9][0-9_]*)\
        |[-+]?0x[0-9a-fA-F_]+\
        |[-+]?[1-9][0-9_]*(?::[0-5]?[0-9])+)$
        """)

    /// Default float resolver rule.
    public static let float = try! Resolver.Rule(.float, """
        ^(?:[-+]?(?:[0-9][0-9_]*)(?:\\.[0-9_]*)?(?:[eE][-+]?[0-9]+)?\
        |\\.[0-9_]+(?:[eE][-+][0-9]+)?\
        |[-+]?[0-9][0-9_]*(?::[0-5]?[0-9])+\\.[0-9_]*\
        |[-+]?\\.(?:inf|Inf|INF)\
        |\\.(?:nan|NaN|NAN))$
        """)

    /// Default merge resolver rule.
    public static let merge = try! Resolver.Rule(.merge, "^(?:<<)$")

    /// Default null resolver rule.
    public static let null = try! Resolver.Rule(.null, """
        ^(?:~\
        |null|Null|NULL\
        |)$
        """)

    /// Default timestamp resolver rule.
    public static let timestamp = try! Resolver.Rule(.timestamp, """
        ^(?:[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\
        |[0-9][0-9][0-9][0-9]-[0-9][0-9]?-[0-9][0-9]?\
        (?:[Tt]|[ \\t]+)[0-9][0-9]?\
        :[0-9][0-9]:[0-9][0-9](?:\\.[0-9]*)?\
        (?:[ \\t]*(?:Z|[-+][0-9][0-9]?(?::[0-9][0-9])?))?)$
        """)

    /// Default value resolver rule.
    public static let value = try! Resolver.Rule(.value, "^(?:=)$")

    // swiftlint:enable force_try
}

func pattern(_ string: String) -> NSRegularExpression {
    do {
        return try .init(pattern: string, options: [])
    } catch {
        fatalError("unreachable")
    }
}

private extension NSRegularExpression {
    func matches(in string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            return match.range.location != NSNotFound
        }
        return false
    }
}
