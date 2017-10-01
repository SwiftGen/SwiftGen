//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

enum RemoveNewlinesModes: String {
    case all, leading
}

enum SwiftIdentifierModes: String {
    case normal, pretty
}

extension Filters.Strings {
    fileprivate static let reservedKeywords = [
        "associatedtype", "class", "deinit", "enum", "extension",
        "fileprivate", "func", "import", "init", "inout", "internal",
        "let", "open", "operator", "private", "protocol", "public",
        "static", "struct", "subscript", "typealias", "var", "break",
        "case", "continue", "default", "defer", "do", "else",
        "fallthrough", "for", "guard", "if", "in", "repeat", "return",
        "switch", "where", "while", "as", "Any", "catch", "false", "is",
        "nil", "rethrows", "super", "self", "Self", "throw", "throws",
        "true", "try", "_", "#available", "#colorLiteral", "#column",
        "#else", "#elseif", "#endif", "#file", "#fileLiteral",
        "#function", "#if", "#imageLiteral", "#line", "#selector",
        "#sourceLocation", "associativity", "convenience", "dynamic",
        "didSet", "final", "get", "infix", "indirect", "lazy", "left",
        "mutating", "none", "nonmutating", "optional", "override",
        "postfix", "precedence", "prefix", "Protocol", "required",
        "right", "set", "Type", "unowned", "weak", "willSet"
    ]

    static func escapeReservedKeywords(value: Any?) throws -> Any? {
        let string = try Filters.parseString(from: value)
        return escapeReservedKeywords(in: string)
    }

    /// Replaces in the given string the given substring with the replacement
    /// "people picker", replacing "picker" with "life" gives "people life"
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting two arguments: substring, replacement
    /// - Returns: the results string
    /// - Throws: FilterError.invalidInputType if the value parameter or argunemts aren't string
    static func replace(_ value: Any?, arguments: [Any?]) throws -> Any? {
        let source = try Filters.parseString(from: value)
        let substring = try Filters.parseStringArgument(from: arguments, at: 0)
        let replacement = try Filters.parseStringArgument(from: arguments, at: 1)
        return source.replacingOccurrences(of: substring, with: replacement)
    }

    /// Converts an arbitrary string to a valid swift identifier. Takes an optional Mode argument:
    ///   - normal (default): uppercase the first character, prefix with an underscore if starting
    ///     with a number, replace invalid characters by underscores
    ///   - leading: same as the above, but apply the snaceToCamelCase filter first for a nicer
    ///     identifier
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting zero or one mode argument
    /// - Returns: the identifier string
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func swiftIdentifier(_ value: Any?, arguments: [Any?]) throws -> Any? {
        var string = try Filters.parseString(from: value)
        let mode = try Filters.parseEnum(from: arguments, default: SwiftIdentifierModes.normal)

        switch mode {
        case .normal:
            return SwiftIdentifier.identifier(from: string, replaceWithUnderscores: true)
        case .pretty:
            string = SwiftIdentifier.identifier(from: string, replaceWithUnderscores: true)
            string = try snakeToCamelCase(string, stripLeading: true)
            return SwiftIdentifier.prefixWithUnderscoreIfNeeded(string: string)
        }
    }

    /// Converts a file path to just the filename, stripping any path components before it.
    ///
    /// - Parameter value: the value to be processed
    /// - Returns: the basename of the path
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func basename(_ value: Any?) throws -> Any? {
        let string = try Filters.parseString(from: value)
        return (string as NSString).lastPathComponent
    }

    /// Converts a file path to just the path without the filename.
    ///
    /// - Parameter value: the value to be processed
    /// - Returns: the dirname of the path
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func dirname(_ value: Any?) throws -> Any? {
        let string = try Filters.parseString(from: value)
        return (string as NSString).deletingLastPathComponent
    }

    /// Removes newlines and other whitespace from a string. Takes an optional Mode argument:
    ///   - all (default): remove all newlines and whitespaces
    ///   - leading: remove newlines and only leading whitespaces
    ///
    /// - Parameters:
    ///   - value: the value to be processed
    ///   - arguments: the arguments to the function; expecting zero or one mode argument
    /// - Returns: the trimmed string
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string
    static func removeNewlines(_ value: Any?, arguments: [Any?]) throws -> Any? {
        let string = try Filters.parseString(from: value)
        let mode = try Filters.parseEnum(from: arguments, default: RemoveNewlinesModes.all)

        switch mode {
        case .all:
            return string
                .components(separatedBy: .whitespacesAndNewlines)
                .joined()
        case .leading:
            return string
                .components(separatedBy: .newlines)
                .map(removeLeadingWhitespaces(from:))
                .joined()
                .trimmingCharacters(in: .whitespaces)
        }
    }

    // MARK: - Private

    private static func removeLeadingWhitespaces(from string: String) -> String {
        let chars = string.unicodeScalars.drop { CharacterSet.whitespaces.contains($0) }
        return String(chars)
    }

    /// Checks if the string is one of the reserved keywords and if so, escapes it using backticks
    ///
    /// - Parameter in: the string to possibly escape
    /// - Returns: if the string is a reserved keyword, the escaped string, otherwise the original one
    private static func escapeReservedKeywords(in string: String) -> String {
        guard reservedKeywords.contains(string) else {
            return string
        }
        return "`\(string)`"
    }
}
