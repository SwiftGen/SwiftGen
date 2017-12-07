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
import Foundation

public extension Node {
    /// initialize `Node` with instance of `NodeRepresentable`
    /// - Parameter representable: instance of `NodeRepresentable`
    /// - Throws: `YamlError`
    public init<T: NodeRepresentable>(_ representable: T) throws {
        self = try representable.represented()
    }
}

// MARK: - NodeRepresentable
/// Type is representabe as `Node`
public protocol NodeRepresentable {
    func represented() throws -> Node
}

extension Node: NodeRepresentable {
    public func represented() throws -> Node {
        return self
    }
}

extension Array: NodeRepresentable {
    public func represented() throws -> Node {
        let nodes = try map(represent)
        return Node(nodes, Tag(.seq))
    }
}

extension Dictionary: NodeRepresentable {
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
/// Type is representabe as `Node.scalar`
public protocol ScalarRepresentable: NodeRepresentable {}

extension Bool: ScalarRepresentable {
    public func represented() throws -> Node {
        return Node(self ? "true" : "false", Tag(.bool))
    }
}

extension Data: ScalarRepresentable {
    public func represented() throws -> Node {
        return Node(base64EncodedString(), Tag(.binary))
    }
}

extension Date: ScalarRepresentable {
    public func represented() throws -> Node {
        return Node(iso8601String, Tag(.timestamp))
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

    fileprivate var iso8601StringWithFullNanosecond: String {
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
    public func represented() throws -> Node {
        return Node(doubleFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-"), Tag(.float))
    }
}

extension Float: ScalarRepresentable {
    public func represented() throws -> Node {
        return Node(floatFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-"), Tag(.float))
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
    public func represented() throws -> Node {
        return Node(String(describing: self), Tag(.int))
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
    public func represented() throws -> Node {
        return Node(description)
    }
}

extension URL: ScalarRepresentable {
    public func represented() throws -> Node {
        return Node(absoluteString)
    }
}

/// MARK: - ScalarRepresentableCustomizedForCodable

public protocol ScalarRepresentableCustomizedForCodable: ScalarRepresentable {
    func representedForCodable() -> Node
}

extension Date: ScalarRepresentableCustomizedForCodable {
    public func representedForCodable() -> Node {
        return Node(iso8601StringWithFullNanosecond, Tag(.timestamp))
    }
}

extension Double: ScalarRepresentableCustomizedForCodable {}
extension Float: ScalarRepresentableCustomizedForCodable {}

extension FloatingPoint where Self: CVarArg {
    public func representedForCodable() -> Node {
        return Node(formattedStringForCodable, Tag(.float))
    }

    private var formattedStringForCodable: String {
        // Since `NumberFormatter` creates a string with insufficient precision for Decode,
        // it uses with `String(format:...)`
#if os(Linux)
        let DBL_DECIMAL_DIG = 17
#endif
        let string = String(format: "%.*g", DBL_DECIMAL_DIG, self)
        // "%*.g" does not use scientific notation if the exponent is less than –4.
        // So fallback to using `NumberFormatter` if string does not uses scientific notation.
        guard string.lazy.suffix(5).contains("e") else {
            return doubleFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-")
        }
        return string
    }
}
