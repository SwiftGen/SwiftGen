//
//  Representer.swift
//  Yams
//
//  Created by Norio Nomura on 1/8/17.
//  Copyright (c) 2017 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
import CYaml
#endif
import CoreFoundation
import Foundation

public extension Node {
    /// Initialize a `Node` with a value of `NodeRepresentable`.
    ///
    /// - parameter representable: Value of `NodeRepresentable` to represent as a `Node`.
    ///
    /// - throws: `YamlError`.
    public init<T: NodeRepresentable>(_ representable: T) throws {
        self = try representable.represented()
    }
}

// MARK: - NodeRepresentable
/// Type is representable as `Node`.
public protocol NodeRepresentable {
    /// This value's `Node` representation.
    func represented() throws -> Node
}

extension Node: NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Node {
        return self
    }
}

extension Array: NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Node {
        let nodes = try map(represent)
        return Node(nodes, Tag(.seq))
    }
}

extension Dictionary: NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Node {
        let pairs = try map { (key: try represent($0.0), value: try represent($0.1)) }
        return Node(pairs.sorted { $0.key < $1.key }, Tag(.map))
    }
}

private func represent(_ value: Any) throws -> Node {
    if let string = value as? String {
        return Node(string)
    } else if let representable = value as? NodeRepresentable {
        return try representable.represented()
    }
    throw YamlError.representer(problem: "Failed to represent \(value)")
}

// MARK: - ScalarRepresentable
/// Type is representable as `Node.scalar`.
public protocol ScalarRepresentable: NodeRepresentable {
    /// This value's `Node.scalar` representation.
    func represented() -> Node.Scalar
}

extension ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() throws -> Node {
        return .scalar(represented())
    }
}

extension Bool: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(self ? "true" : "false", Tag(.bool))
    }
}

extension Data: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(base64EncodedString(), Tag(.binary))
    }
}

extension Date: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(iso8601String, Tag(.timestamp))
    }

    private var iso8601String: String {
        let calendar = Calendar(identifier: .gregorian)
        let nanosecond = calendar.component(.nanosecond, from: self)
#if os(Linux)
        // swift-corelibs-foundation has bug with nanosecond.
        // https://bugs.swift.org/browse/SR-3158
        return iso8601Formatter.string(from: self)
#else
        if nanosecond != 0 {
            return iso8601WithFractionalSecondFormatter.string(from: self)
                .trimmingCharacters(in: characterSetZero) + "Z"
        } else {
            return iso8601Formatter.string(from: self)
        }
#endif
    }

    private var iso8601StringWithFullNanosecond: String {
        let calendar = Calendar(identifier: .gregorian)
        let nanosecond = calendar.component(.nanosecond, from: self)
        if nanosecond != 0 {
            return iso8601WithoutZFormatter.string(from: self) +
                String(format: ".%09d", nanosecond).trimmingCharacters(in: characterSetZero) + "Z"
        } else {
            return iso8601Formatter.string(from: self)
        }
    }
}

private let characterSetZero = CharacterSet(charactersIn: "0")

private let iso8601Formatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

private let iso8601WithoutZFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

// DateFormatter truncates Fractional Second to 10^-4
private let iso8601WithFractionalSecondFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSS"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

extension Double: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(doubleFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-"), Tag(.float))
    }
}

extension Float: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(floatFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-"), Tag(.float))
    }
}

private func numberFormatter(with significantDigits: Int) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.numberStyle = .scientific
    formatter.usesSignificantDigits = true
    formatter.maximumSignificantDigits = significantDigits
    formatter.positiveInfinitySymbol = ".inf"
    formatter.negativeInfinitySymbol = "-.inf"
    formatter.notANumberSymbol = ".nan"
    formatter.exponentSymbol = "e+"
    return formatter
}

private let doubleFormatter = numberFormatter(with: 15)
private let floatFormatter = numberFormatter(with: 7)

// TODO: Support `Float80`
//extension Float80: ScalarRepresentable {}

extension BinaryInteger {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(String(describing: self), Tag(.int))
    }
}

extension Int: ScalarRepresentable {}
extension Int16: ScalarRepresentable {}
extension Int32: ScalarRepresentable {}
extension Int64: ScalarRepresentable {}
extension Int8: ScalarRepresentable {}
extension UInt: ScalarRepresentable {}
extension UInt16: ScalarRepresentable {}
extension UInt32: ScalarRepresentable {}
extension UInt64: ScalarRepresentable {}
extension UInt8: ScalarRepresentable {}

extension Optional: NodeRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() throws -> Node {
        switch self {
        case let .some(wrapped):
            return try represent(wrapped)
        case .none:
            return Node("null", Tag(.null))
        }
    }
}

extension Decimal: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(description)
    }
}

extension URL: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(absoluteString)
    }
}

extension String: ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Node.Scalar {
        return .init(self)
    }
}

/// MARK: - ScalarRepresentableCustomizedForCodable

/// Types conforming to this protocol can be encoded by `YamlEncoder`.
public protocol YAMLEncodable: Encodable {
    /// Returns this value wrapped in a `Node`.
    func box() -> Node
}

extension YAMLEncodable where Self: ScalarRepresentable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Node {
        return .scalar(represented())
    }
}

extension Bool: YAMLEncodable {}
extension Data: YAMLEncodable {}
extension Decimal: YAMLEncodable {}
extension Int: YAMLEncodable {}
extension Int8: YAMLEncodable {}
extension Int16: YAMLEncodable {}
extension Int32: YAMLEncodable {}
extension Int64: YAMLEncodable {}
extension UInt: YAMLEncodable {}
extension UInt8: YAMLEncodable {}
extension UInt16: YAMLEncodable {}
extension UInt32: YAMLEncodable {}
extension UInt64: YAMLEncodable {}
extension URL: YAMLEncodable {}
extension String: YAMLEncodable {}

extension Date: YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Node {
        return Node(iso8601StringWithFullNanosecond, Tag(.timestamp))
    }
}

extension Double: YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Node {
        return Node(formattedStringForCodable, Tag(.float))
    }
}

extension Float: YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Node {
        return Node(formattedStringForCodable, Tag(.float))
    }
}

private extension FloatingPoint where Self: CVarArg {
    var formattedStringForCodable: String {
        // Since `NumberFormatter` creates a string with insufficient precision for Decode,
        // it uses with `String(format:...)`
        let string = String(format: "%.*g", DBL_DECIMAL_DIG, self)
        // "%*.g" does not use scientific notation if the exponent is less than –4.
        // So fallback to using `NumberFormatter` if string does not uses scientific notation.
        guard string.lazy.suffix(5).contains("e") else {
            return doubleFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-")
        }
        return string
    }
}

@available(*, unavailable, renamed: "YAMLEncodable")
typealias ScalarRepresentableCustomizedForCodable = YAMLEncodable

extension YAMLEncodable {
    @available(*, unavailable, renamed: "box()")
    func representedForCodable() -> Node { fatalError("unreachable") }
}
