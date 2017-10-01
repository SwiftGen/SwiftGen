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
public protocol NodeRepresentable {
    func represented() throws -> Node
}

extension Node: NodeRepresentable {
    public func represented() throws -> Node {
        return self
    }
}

extension Bool: NodeRepresentable {
    public func represented() throws -> Node {
        return Node(self ? "true" : "false", Tag(.bool))
    }
}

extension Data: NodeRepresentable {
    public func represented() throws -> Node {
        return Node(base64EncodedString(), Tag(.binary))
    }
}

extension Date: NodeRepresentable {
    public func represented() throws -> Node {
        return Node(iso8601string, Tag(.timestamp))
    }

    private var iso8601string: String {
        let calendar = Calendar(identifier: .gregorian)
        let nanosecond = calendar.component(.nanosecond, from: self)
        #if os(Linux)
            // swift-corelibs-foundation has bug with nanosecond.
            // https://bugs.swift.org/browse/SR-3158
            return iso8601Formatter.string(from: self)
        #else
            if nanosecond != 0 {
                return iso8601FormatterWithNanoseconds.string(from: self)
                    .trimmingCharacters(in: characterSetZero) + "Z"
            } else {
                return iso8601Formatter.string(from: self)
            }
        #endif
    }
}

private let characterSetZero = CharacterSet(charactersIn: "0")

private let iso8601Formatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier :"en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

private let iso8601FormatterWithNanoseconds: DateFormatter = {
    var formatter = DateFormatter()
    formatter.locale = Locale(identifier :"en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSSSS"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

extension Double: NodeRepresentable {
    public func represented() throws -> Node {
        return Node(doubleFormatter.string(for: self)!.replacingOccurrences(of: "+-", with: "-"), Tag(.float))
    }
}

extension Float: NodeRepresentable {
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
//extension Float80: NodeRepresentable {}

#if swift(>=4.0)
extension BinaryInteger {
    public func represented() throws -> Node {
        return Node(String(describing: self), Tag(.int))
    }
}
#else
extension Integer {
    public func represented() throws -> Node {
        return Node(String(describing: self), Tag(.int))
    }
}
#endif

extension Int: NodeRepresentable {}
extension Int16: NodeRepresentable {}
extension Int32: NodeRepresentable {}
extension Int64: NodeRepresentable {}
extension Int8: NodeRepresentable {}
extension UInt: NodeRepresentable {}
extension UInt16: NodeRepresentable {}
extension UInt32: NodeRepresentable {}
extension UInt64: NodeRepresentable {}
extension UInt8: NodeRepresentable {}

private func represent(_ value: Any) throws -> Node {
    if let string = value as? String {
        return Node(string)
    } else if let representable = value as? NodeRepresentable {
        return try representable.represented()
    }
    throw YamlError.representer(problem: "Fail to represent \(value)")
}

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
