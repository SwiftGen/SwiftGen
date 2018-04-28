//
//  Constructor.swift
//  Yams
//
//  Created by Norio Nomura on 12/21/16.
//  Copyright (c) 2016 Yams. All rights reserved.
//

import Foundation

public final class Constructor {
    public typealias ScalarMap = [Tag.Name: (Node.Scalar) -> Any?]
    public typealias MappingMap = [Tag.Name: (Node.Mapping) -> Any?]
    public typealias SequenceMap = [Tag.Name: (Node.Sequence) -> Any?]

    public init(_ scalarMap: ScalarMap = defaultScalarMap,
                _ mappingMap: MappingMap = defaultMappingMap,
                _ sequenceMap: SequenceMap = defaultSequenceMap) {
        self.scalarMap = scalarMap
        self.mappingMap = mappingMap
        self.sequenceMap = sequenceMap
    }

    public func any(from node: Node) -> Any {
        switch node {
        case .scalar(let scalar):
            if let method = scalarMap[node.tag.name], let result = method(scalar) {
                return result
            }
            return String.construct(from: scalar)!
        case .mapping(let mapping):
            if let method = mappingMap[node.tag.name], let result = method(mapping) {
                return result
            }
            return [AnyHashable: Any]._construct_mapping(from: mapping)
        case .sequence(let sequence):
            if let method = sequenceMap[node.tag.name], let result = method(sequence) {
                return result
            }
            return [Any].construct_seq(from: sequence)
        }
    }

    private let scalarMap: ScalarMap
    private let mappingMap: MappingMap
    private let sequenceMap: SequenceMap
}

extension Constructor {
    public static let `default` = Constructor()

    // We can not write extension of map because that is alias of specialized dictionary
    public static let defaultScalarMap: ScalarMap = [
        // Failsafe Schema
        .str: String.construct,
        // JSON Schema
        .bool: Bool.construct,
        .float: Double.construct,
        .null: NSNull.construct,
        .int: Int.construct,
        // http://yaml.org/type/index.html
        .binary: Data.construct,
        .timestamp: Date.construct
    ]

    public static let defaultMappingMap: MappingMap = [
        .map: [AnyHashable: Any].construct_mapping,
        // http://yaml.org/type/index.html
        .set: Set<AnyHashable>.construct_set
        // .merge is supported in `[AnyHashable: Any].construct_mapping`.
        // .value is supported in `String.construct` and `[AnyHashable: Any].construct_mapping`.
    ]

    public static let defaultSequenceMap: SequenceMap = [
        .seq: [Any].construct_seq,
        // http://yaml.org/type/index.html
        .omap: [Any].construct_omap,
        .pairs: [Any].construct_pairs
    ]
}

// MARK: - ScalarConstructible
public protocol ScalarConstructible {
    // We don't use overloading `init?(_ scalar: Node.Scalar)`
    // because that causes difficulties on using `init` as closure
    static func construct(from scalar: Node.Scalar) -> Self?
}

extension Bool: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> Bool? {
        switch scalar.string.lowercased() {
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
    public static func construct(from scalar: Node.Scalar) -> Data? {
        return Data(base64Encoded: scalar.string, options: .ignoreUnknownCharacters)
    }
}

extension Date: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> Date? {
        let range = NSRange(location: 0, length: scalar.string.utf16.count)
        guard let result = timestampPattern.firstMatch(in: scalar.string, options: [], range: range),
            result.range.location != NSNotFound else {
                return nil
        }
        let components = (1..<result.numberOfRanges).map {
            scalar.string.substring(with: result.range(at: $0))
        }

        var datecomponents = DateComponents()
        datecomponents.calendar = Calendar(identifier: .gregorian)
        datecomponents.year = components[0].flatMap { Int($0) }
        datecomponents.month = components[1].flatMap { Int($0) }
        datecomponents.day = components[2].flatMap { Int($0) }
        datecomponents.hour = components[3].flatMap { Int($0) }
        datecomponents.minute = components[4].flatMap { Int($0) }
        datecomponents.second = components[5].flatMap { Int($0) }
        datecomponents.nanosecond = components[6].flatMap {
            let length = $0.count
            let nanosecond: Int?
            if length < 9 {
                nanosecond = Int($0 + String(repeating: "0", count: 9 - length))
            } else {
                nanosecond = Int($0[..<$0.index($0.startIndex, offsetBy: 9)])
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

extension Double: ScalarConstructible {}
extension Float: ScalarConstructible {}

extension ScalarConstructible where Self: FloatingPoint & SexagesimalConvertible {
    public static func construct(from scalar: Node.Scalar) -> Self? {
        switch scalar.string {
        case ".inf", ".Inf", ".INF", "+.inf", "+.Inf", "+.INF":
            return .infinity
        case "-.inf", "-.Inf", "-.INF":
            return -Self.infinity
        case ".nan", ".NaN", ".NAN":
            return .nan
        default:
            let string = scalar.string.replacingOccurrences(of: "_", with: "")
            if string.contains(":") {
                return Self(sexagesimal: string)
            }
            return .create(from: string)
        }
    }
}

private extension FixedWidthInteger where Self: SexagesimalConvertible {
    static func _construct(from scalar: Node.Scalar) -> Self? {
        let scalarWithSign = scalar.string.replacingOccurrences(of: "_", with: "")

        if scalarWithSign == "0" {
            return 0
        }

        let negative = scalarWithSign.hasPrefix("-")

        guard isSigned || !negative else { return nil }

        let signPrefix = negative ? "-" : ""
        let hasSign = negative || scalarWithSign.hasPrefix("+")

        let prefixToRadix: [(String, Int)] = [
            ("0x", 16),
            ("0b", 2),
            ("0o", 8),
            ("0", 8)
        ]

        let scalar = scalarWithSign.substring(from: hasSign ? 1 : 0)
        for (prefix, radix) in prefixToRadix where scalar.hasPrefix(prefix) {
            return Self(signPrefix + scalar.substring(from: prefix.count), radix: radix)
        }
        if scalar.contains(":") {
            return Self(sexagesimal: scalarWithSign)
        }
        return Self(scalarWithSign)
    }
}

extension Int: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> Int? {
        return _construct(from: scalar)
    }
}

extension UInt: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> UInt? {
        return _construct(from: scalar)
    }
}

extension String: ScalarConstructible {
    public static func construct(from scalar: Node.Scalar) -> String? {
        return scalar.string
    }

    public static func construct(from node: Node) -> String? {
        // This will happen while `Dictionary.flatten_mapping()` if `node.tag.name` was `.value`
        if case let .mapping(mapping) = node {
            for (key, value) in mapping where key.tag.name == .value {
                return construct(from: value)
            }
        }

        guard let string = node.scalar?.string else { return nil }
        return string
    }
}

// MARK: - Types that can't conform to ScalarConstructible
extension NSNull/*: ScalarConstructible*/ {
    public static func construct(from scalar: Node.Scalar) -> NSNull? {
        switch scalar.string {
        case "", "~", "null", "Null", "NULL":
            return NSNull()
        default:
            return nil
        }
    }
}

// MARK: mapping
extension Dictionary {
    public static func construct_mapping(from mapping: Node.Mapping) -> [AnyHashable: Any]? {
        return _construct_mapping(from: mapping)
    }
}

private extension Dictionary {
    static func _construct_mapping(from mapping: Node.Mapping) -> [AnyHashable: Any] {
        let mapping = flatten_mapping(mapping)
        var dictionary = [AnyHashable: Any](minimumCapacity: mapping.count)
        mapping.forEach {
            // TODO: YAML supports keys other than str.
            dictionary[String.construct(from: $0.key)!] = mapping.tag.constructor.any(from: $0.value)
        }
        return dictionary
    }

    private static func flatten_mapping(_ mapping: Node.Mapping) -> Node.Mapping {
        var pairs = Array(mapping)
        var merge = [(key: Node, value: Node)]()
        var index = pairs.startIndex
        while index < pairs.count {
            let pair = pairs[index]
            if pair.key.tag.name == .merge {
                pairs.remove(at: index)
                switch pair.value {
                case .mapping(let mapping):
                    merge.append(contentsOf: flatten_mapping(mapping))
                case let .sequence(sequence):
                    let submerge = sequence
                        .compactMap { $0.mapping.map(flatten_mapping) }
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
        return Node.Mapping(merge + pairs, mapping.tag, mapping.style)
    }
}

extension Set {
    public static func construct_set(from mapping: Node.Mapping) -> Set<AnyHashable>? {
        // TODO: YAML supports Hashable elements other than str.
        return Set<AnyHashable>(mapping.map({ String.construct(from: $0.key)! as AnyHashable }))
        // Explicitly declaring the generic parameter as `<AnyHashable>` above is required,
        // because this is inside extension of `Set` and Swift 3.0.2 can't infer the type without that.
    }
}

// MARK: sequence
extension Array {
    public static func construct_seq(from sequence: Node.Sequence) -> [Any] {
        return sequence.map(sequence.tag.constructor.any)
    }

    public static func construct_omap(from sequence: Node.Sequence) -> [(Any, Any)] {
        // Note: we do not check for duplicate keys.
        return sequence.compactMap { subnode -> (Any, Any)? in
            // TODO: Should raise error if subnode is not mapping or mapping.count != 1
            guard let (key, value) = subnode.mapping?.first else { return nil }
            return (sequence.tag.constructor.any(from: key), sequence.tag.constructor.any(from: value))
        }
    }

    public static func construct_pairs(from sequence: Node.Sequence) -> [(Any, Any)] {
        // Note: we do not check for duplicate keys.
        return sequence.compactMap { subnode -> (Any, Any)? in
            // TODO: Should raise error if subnode is not mapping or mapping.count != 1
            guard let (key, value) = subnode.mapping?.first else { return nil }
            return (sequence.tag.constructor.any(from: key), sequence.tag.constructor.any(from: value))
        }
    }
}

private extension String {
    func substring(with range: NSRange) -> Substring? {
        guard range.location != NSNotFound else { return nil }
        let utf16lowerBound = utf16.index(utf16.startIndex, offsetBy: range.location)
        let utf16upperBound = utf16.index(utf16lowerBound, offsetBy: range.length)
        guard let lowerBound = utf16lowerBound.samePosition(in: self),
            let upperBound = utf16upperBound.samePosition(in: self) else {
                fatalError("unreachable")
        }
        return self[lowerBound..<upperBound]
    }
}

private extension String {
    func substring(from offset: Int) -> Substring {
        let index = self.index(startIndex, offsetBy: offset)
        return self[index...]
    }
}

// MARK: - SexagesimalConvertible
public protocol SexagesimalConvertible: ExpressibleByIntegerLiteral {
    static func create(from string: String) -> Self?
    static func * (lhs: Self, rhs: Self) -> Self
    static func + (lhs: Self, rhs: Self) -> Self
}

private extension SexagesimalConvertible {
    init(sexagesimal value: String) {
        self = value.sexagesimal()
    }
}

extension SexagesimalConvertible where Self: LosslessStringConvertible {
    public static func create(from string: String) -> Self? {
        return Self(string)
    }
}

extension SexagesimalConvertible where Self: FixedWidthInteger {
    public static func create(from string: String) -> Self? {
        return Self(string, radix: 10)
    }
}

extension Double: SexagesimalConvertible {}
extension Float: SexagesimalConvertible {}
extension Int: SexagesimalConvertible {}
extension UInt: SexagesimalConvertible {}

private extension String {
    func sexagesimal<T>() -> T where T: SexagesimalConvertible {
        assert(contains(":"))
        var scalar = self

        let sign: T
        if scalar.hasPrefix("-") {
            sign = -1
            scalar = String(scalar.substring(from: 1))
        } else if scalar.hasPrefix("+") {
            scalar = String(scalar.substring(from: 1))
            sign = 1
        } else {
            sign = 1
        }
        let digits = scalar.components(separatedBy: ":").compactMap(T.create).reversed()
        let (_, value) = digits.reduce((1, 0) as (T, T)) { baseAndValue, digit in
            let value = baseAndValue.1 + (digit * baseAndValue.0)
            let base = baseAndValue.0 * 60
            return (base, value)
        }
        return sign * value
    }
}

private extension Substring {
#if os(Linux)
    func hasPrefix(_ prefix: String) -> Bool {
        return String(self).hasPrefix(prefix)
    }

    func components(separatedBy separator: String) -> [String] {
        return String(self).components(separatedBy: separator)
    }
#endif

    func substring(from offset: Int) -> Substring {
        if offset == 0 { return self }
        let index = self.index(startIndex, offsetBy: offset)
        return self[index...]
    }
}

// MARK: - Unavailable

extension Constructor {
    @available(*, unavailable, message: "Use `Constructor.ScalarMap` instead")
    public typealias Map = [Tag.Name: (Node) -> Any?]

    @available(*, unavailable, message: "Use `Constructor.defaultScalarMap` instead")
    public static let defaultMap: ScalarMap = [:]
}

extension ScalarConstructible {
    @available(*, unavailable, message: "Use `construct(from scalar: Node.Scalar)` instead")
    static func construct(from scalar: Node) -> Self? { return nil }
}

// swiftlint:disable:this file_length
