//
//  Constructor.swift
//  Yams
//
//  Created by Norio Nomura on 12/21/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

public final class Constructor {
    public typealias Map = [Tag.Name: (Node) -> Any?]

    public init(_ map: Map) {
        methodMap = map
    }

    public func any(from node: Node) -> Any {
        if let method = methodMap[node.tag.name], let result = method(node) {
            return result
        }
        switch node {
        case .scalar:
            return String._construct(from: node)
        case .mapping:
            return [AnyHashable: Any]._construct_mapping(from: node)
        case .sequence:
            return [Any].construct_seq(from: node)
        }
    }

    private let methodMap: Map
}

extension Constructor {
    public static let `default` = Constructor(defaultMap)

    // We can not write extension of map because that is alias of specialized dictionary
    public static let defaultMap: Map = [
        // Failsafe Schema
        .map: [AnyHashable: Any].construct_mapping,
        .str: String.construct,
        .seq: [Any].construct_seq,
        // JSON Schema
        .bool: Bool.construct,
        .float: Double.construct,
        .null: NSNull.construct,
        .int: Int.construct,
        // http://yaml.org/type/index.html
        .binary: Data.construct,
        // .merge is supported in `[AnyHashable: Any].construct`.
        .omap: [Any].construct_omap,
        .pairs: [Any].construct_pairs,
        .set: Set<AnyHashable>.construct_set,
        .timestamp: Date.construct
        // .value is supported in `String.construct` and `[AnyHashable: Any].construct`.
    ]
}

// MARK: - ScalarConstructible
public protocol ScalarConstructible {
    // We don't use overloading `init?(_ node: Node)`
    // because that causes difficulties on using `init` as closure
    static func construct(from node: Node) -> Self?
}

extension Bool: ScalarConstructible {
    public static func construct(from node: Node) -> Bool? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        switch node.scalar!.string.lowercased() {
        case "true", "yes", "on":
            return true
        case "false", "no", "off":
            return false
        default:
            return nil
        }
    }
}

extension Data: ScalarConstructible {
    public static func construct(from node: Node) -> Data? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        let data = Data(base64Encoded: node.scalar!.string, options: .ignoreUnknownCharacters)
        return data
    }
}

extension Date: ScalarConstructible {
    public static func construct(from node: Node) -> Date? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        let scalar = node.scalar!.string

        let range = NSRange(location: 0, length: scalar.utf16.count)
        guard let result = timestampPattern.firstMatch(in: scalar, options: [], range: range),
            result.range.location != NSNotFound else {
                return nil
        }
        #if os(Linux) || swift(>=4.0)
            let components = (1..<result.numberOfRanges).map {
                scalar.substring(with: result.range(at: $0))
            }
        #else
            let components = (1..<result.numberOfRanges).map {
                scalar.substring(with: result.rangeAt($0))
            }
        #endif

        var datecomponents = DateComponents()
        datecomponents.calendar = Calendar(identifier: .gregorian)
        datecomponents.year = components[0].flatMap { Int($0) }
        datecomponents.month = components[1].flatMap { Int($0) }
        datecomponents.day = components[2].flatMap { Int($0) }
        datecomponents.hour = components[3].flatMap { Int($0) }
        datecomponents.minute = components[4].flatMap { Int($0) }
        datecomponents.second = components[5].flatMap { Int($0) }
        datecomponents.nanosecond = components[6].flatMap {
            let length = $0.characters.count
            let nanosecond: Int?
            if length < 9 {
                nanosecond = Int($0 + String(repeating: "0", count: 9 - length))
            } else {
#if swift(>=4.0)
                nanosecond = Int($0[..<$0.index($0.startIndex, offsetBy: 9)])
#else
                nanosecond = Int($0.substring(to: $0.index($0.startIndex, offsetBy: 9)))
#endif
            }
            return nanosecond
        }
        datecomponents.timeZone = {
            var seconds = 0
            if let hourInSecond = components[9].flatMap({ Int($0) }).map({ $0 * 60 * 60 }) {
                seconds += hourInSecond
            }
            if let minuteInSecond = components[10].flatMap({ Int($0) }).map({ $0 * 60 }) {
                seconds += minuteInSecond
            }
            if components[8] == "-" { // sign
                seconds *= -1
            }
            return TimeZone(secondsFromGMT: seconds)
        }()
        // Using `DateComponents.date` causes `NSUnimplemented()` crash on Linux at swift-3.0.2-RELEASE
        return NSCalendar(identifier: .gregorian)?.date(from: datecomponents)
    }

    private static let timestampPattern: NSRegularExpression = pattern([
        "^([0-9][0-9][0-9][0-9])",          // year
        "-([0-9][0-9]?)",                   // month
        "-([0-9][0-9]?)",                   // day
        "(?:(?:[Tt]|[ \\t]+)",
        "([0-9][0-9]?)",                    // hour
        ":([0-9][0-9])",                    // minute
        ":([0-9][0-9])",                    // second
        "(?:\\.([0-9]*))?",                 // fraction
        "(?:[ \\t]*(Z|([-+])([0-9][0-9]?)", // tz_sign, tz_hour
        "(?::([0-9][0-9]))?))?)?$"          // tz_minute
        ].joined()
    )
}

extension Double: ScalarConstructible {
    public static func construct(from node: Node) -> Double? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        var scalar = node.scalar!.string
        switch scalar {
        case ".inf", ".Inf", ".INF", "+.inf", "+.Inf", "+.INF":
            return Double.infinity
        case "-.inf", "-.Inf", "-.INF":
            return -Double.infinity
        case ".nan", ".NaN", ".NAN":
            return Double.nan
        default:
            scalar = scalar.replacingOccurrences(of: "_", with: "")
            if scalar.contains(":") {
                return Double(sexagesimal: scalar)
            }
            return Double(scalar)
        }
    }
}

extension Int: ScalarConstructible {
    public static func construct(from node: Node) -> Int? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        var scalar = node.scalar!.string
        scalar = scalar.replacingOccurrences(of: "_", with: "")
        if scalar == "0" {
            return 0
        }
        if scalar.hasPrefix("0x") {
#if swift(>=4.0)
            let hexadecimal = scalar[scalar.index(scalar.startIndex, offsetBy: 2)...]
#else
            let hexadecimal = scalar.substring(from: scalar.index(scalar.startIndex, offsetBy: 2))
#endif
            return Int(hexadecimal, radix: 16)
        }
        if scalar.hasPrefix("0b") {
#if swift(>=4.0)
            let octal = scalar[scalar.index(scalar.startIndex, offsetBy: 2)...]
#else
            let octal = scalar.substring(from: scalar.index(scalar.startIndex, offsetBy: 2))
#endif
            return Int(octal, radix: 2)
        }
        if scalar.hasPrefix("0o") {
#if swift(>=4.0)
            let octal = scalar[scalar.index(scalar.startIndex, offsetBy: 2)...]
#else
            let octal = scalar.substring(from: scalar.index(scalar.startIndex, offsetBy: 2))
#endif
            return Int(octal, radix: 8)
        }
        if scalar.hasPrefix("0") {
#if swift(>=4.0)
            let octal = scalar[scalar.index(after: scalar.startIndex)...]
#else
            let octal = scalar.substring(from: scalar.index(after: scalar.startIndex))
#endif
            return Int(octal, radix: 8)
        }
        if scalar.contains(":") {
            return Int(sexagesimal: scalar)
        }
        return Int(scalar)
    }
}

extension String: ScalarConstructible {
    public static func construct(from node: Node) -> String? {
        return _construct(from: node)
    }

    fileprivate static func _construct(from node: Node) -> String {
        // This will happen while `Dictionary.flatten_mapping()` if `node.tag.name` was `.value`
        if case let .mapping(mapping) = node {
            for (key, value) in mapping where key.tag.name == .value {
                return _construct(from: value)
            }
        }
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        return node.scalar!.string
    }
}

// MARK: - Types that can't conform to ScalarConstructible
extension NSNull/*: ScalarConstructible*/ {
    public static func construct(from node: Node) -> NSNull? {
        assert(node.isScalar) // swiftlint:disable:next force_unwrapping
        switch node.scalar!.string {
        case "", "~", "null", "Null", "NULL":
            return NSNull()
        default:
            return nil
        }
    }
}

// MARK: mapping
extension Dictionary {
    public static func construct_mapping(from node: Node) -> [AnyHashable: Any]? {
        return _construct_mapping(from: node)
    }

    fileprivate static func _construct_mapping(from node: Node) -> [AnyHashable: Any] {
        assert(node.isMapping) // swiftlint:disable:next force_unwrapping
        let mapping = flatten_mapping(node).mapping!
        var dictionary = [AnyHashable: Any](minimumCapacity: mapping.count)
        mapping.forEach {
            // TODO: YAML supports keys other than str.
            dictionary[String._construct(from: $0.key)] = node.tag.constructor.any(from: $0.value)
        }
        return dictionary
    }

    private static func flatten_mapping(_ node: Node) -> Node {
        assert(node.isMapping) // swiftlint:disable:next force_unwrapping
        let mapping = node.mapping!
        var pairs = Array(mapping)
        var merge = [(key: Node, value: Node)]()
        var index = pairs.startIndex
        while index < pairs.count {
            let pair = pairs[index]
            if pair.key.tag.name == .merge {
                pairs.remove(at: index)
                switch pair.value {
                case .mapping:
                    let flattened_node = flatten_mapping(pair.value)
                    if let mapping = flattened_node.mapping {
                        merge.append(contentsOf: mapping)
                    }
                case let .sequence(sequence):
                    let submerge = sequence
                        .filter { $0.isMapping } // TODO: Should raise error on other than mapping
                        .flatMap { flatten_mapping($0).mapping }
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
        return Node(merge + pairs, node.tag, mapping.style)
    }
}

extension Set {
    public static func construct_set(from node: Node) -> Set<AnyHashable>? {
        // TODO: YAML supports Hashable elements other than str.
        assert(node.isMapping) // swiftlint:disable:next force_unwrapping
        return Set<AnyHashable>(node.mapping!.map({ String._construct(from: $0.key) as AnyHashable }))
        // Explicitly declaring the generic parameter as `<AnyHashable>` above is required,
        // because this is inside extension of `Set` and Swift 3.0.2 can't infer the type without that.
    }
}

// MARK: sequence
extension Array {
    public static func construct_seq(from node: Node) -> [Any] {
        // swiftlint:disable:next force_unwrapping
        return node.sequence!.map(node.tag.constructor.any)
    }

    public static func construct_omap(from node: Node) -> [(Any, Any)] {
        // Note: we do not check for duplicate keys.
        assert(node.isSequence) // swiftlint:disable:next force_unwrapping
        return node.sequence!.flatMap { subnode -> (Any, Any)? in
            // TODO: Should raise error if subnode is not mapping or mapping.count != 1
            guard let (key, value) = subnode.mapping?.first else { return nil }
            return (node.tag.constructor.any(from: key), node.tag.constructor.any(from: value))
        }
    }

    public static func construct_pairs(from node: Node) -> [(Any, Any)] {
        // Note: we do not check for duplicate keys.
        assert(node.isSequence) // swiftlint:disable:next force_unwrapping
        return node.sequence!.flatMap { subnode -> (Any, Any)? in
            // TODO: Should raise error if subnode is not mapping or mapping.count != 1
            guard let (key, value) = subnode.mapping?.first else { return nil }
            return (node.tag.constructor.any(from: key), node.tag.constructor.any(from: value))
        }
    }
}

fileprivate extension String {
    func substring(with range: NSRange) -> String? {
        guard range.location != NSNotFound else { return nil }
        let utf16lowerBound = utf16.index(utf16.startIndex, offsetBy: range.location)
        let utf16upperBound = utf16.index(utf16lowerBound, offsetBy: range.length)
        guard let lowerBound = utf16lowerBound.samePosition(in: self),
            let upperBound = utf16upperBound.samePosition(in: self) else {
                fatalError("unreachable")
        }
#if swift(>=4.0)
        return String(self[lowerBound..<upperBound])
#else
        return substring(with: lowerBound..<upperBound)
#endif
    }
}

// MARK: - SexagesimalConvertible
fileprivate protocol SexagesimalConvertible: ExpressibleByIntegerLiteral {
    init?(_ value: String)
    static func * (lhs: Self, rhs: Self) -> Self
    static func *= (lhs: inout Self, rhs: Self)
    static func += (lhs: inout Self, rhs: Self)
}

extension SexagesimalConvertible {
    fileprivate init(sexagesimal value: String) {
        self = value.sexagesimal()
    }
}

extension Double: SexagesimalConvertible {}
extension Int: SexagesimalConvertible {
    fileprivate init?(_ value: String) {
        self.init(value, radix: 10)
    }
}

fileprivate extension String {
    func sexagesimal<T>() -> T where T: SexagesimalConvertible {
        assert(contains(":"))
        var scalar = self

        var sign: T = 1
        if scalar.hasPrefix("-") {
            sign = -1
#if swift(>=4.0)
            scalar = String(scalar[scalar.index(after: scalar.startIndex)...])
#else
            scalar = scalar.substring(from: scalar.index(after: scalar.startIndex))
#endif
        } else if scalar.hasPrefix("+") {
#if swift(>=4.0)
            scalar = String(scalar[scalar.index(after: scalar.startIndex)...])
#else
            scalar = scalar.substring(from: scalar.index(after: scalar.startIndex))
#endif
        }
        let digits = scalar.components(separatedBy: ":").flatMap({ T($0) }).reversed()
        var base: T = 1
        var value: T = 0
        digits.forEach {
            value += $0 * base
            base *= 60
        }
        return sign * value
    }
}
