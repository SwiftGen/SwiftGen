//
//  YamlError.swift
//  Yams
//
//  Created by JP Simard on 2016-11-19.
//  Copyright (c) 2016 Yams. All rights reserved.
//

#if SWIFT_PACKAGE
import CYaml
#endif
import Foundation

public enum YamlError: Swift.Error {
    // Used in `yaml_emitter_t` and `yaml_parser_t`
    /// `YAML_NO_ERROR`. No error is produced.
    case no
    // swiftlint:disable:previous identifier_name

    /// `YAML_MEMORY_ERROR`. Cannot allocate or reallocate a block of memory.
    case memory

    // Used in `yaml_parser_t`
    /// `YAML_READER_ERROR`. Cannot read or decode the input stream.
    /// - Parameters:
    ///   - problem: Error description.
    ///   - byteOffset: The byte about which the problem occured.
    ///   - value: The problematic value (-1 is none).
    ///   - yaml: YAML String which the problem occured while reading.
    case reader(problem: String, byteOffset: Int, value: Int32, yaml: String)

    // line and column start from 1, column is counted by unicodeScalars
    /// `YAML_SCANNER_ERROR`. Cannot scan the input stream.
    /// - Parameters:
    ///   - context: Error context.
    ///   - problem: Error description.
    ///   - mark: Problem position.
    ///   - yaml: YAML String which the problem occured while scanning.
    case scanner(context: Context?, problem: String, Mark, yaml: String)

    /// `YAML_PARSER_ERROR`. Cannot parse the input stream.
    /// - Parameters:
    ///   - context: Error context.
    ///   - problem: Error description.
    ///   - mark: Problem position.
    ///   - yaml: YAML String which the problem occured while parsing.
    case parser(context: Context?, problem: String, Mark, yaml: String)

    /// `YAML_COMPOSER_ERROR`. Cannot compose a YAML document.
    /// - Parameters:
    ///   - context: Error context.
    ///   - problem: Error description.
    ///   - mark: Problem position.
    ///   - yaml: YAML String which the problem occured while composing.
    case composer(context: Context?, problem: String, Mark, yaml: String)

    // Used in `yaml_emitter_t`
    /// `YAML_WRITER_ERROR`. Cannot write to the output stream.
    /// - Parameter problem: Error description.
    case writer(problem: String)

    /// `YAML_EMITTER_ERROR`. Cannot emit a YAML stream.
    /// - Parameter problem: Error description.
    case emitter(problem: String)

    /// Used in `NodeRepresentable`
    /// - Parameter problem: Error description.
    case representer(problem: String)

    /// The error context
    public struct Context: CustomStringConvertible {
        /// error context
        public let text: String
        /// context position
        public let mark: Mark
        /// A textual representation of this instance.
        public var description: String {
            return text + " in line \(mark.line), column \(mark.column)\n"
        }
    }
}

extension YamlError {
    init(from parser: yaml_parser_t, with yaml: String) {
        func context(from parser: yaml_parser_t) -> Context? {
            guard let context = parser.context else { return nil }
            return Context(
                text: String(cString: context),
                mark: Mark(line: parser.context_mark.line + 1, column: parser.context_mark.column + 1)
            )
        }

        func problemMark(from parser: yaml_parser_t) -> Mark {
            return Mark(line: parser.problem_mark.line + 1, column: parser.problem_mark.column + 1)
        }

        switch parser.error {
        case YAML_MEMORY_ERROR:
            self = .memory
        case YAML_READER_ERROR:
            self = .reader(problem: String(cString: parser.problem),
                           byteOffset: parser.problem_offset,
                           value: parser.problem_value,
                           yaml: yaml)
        case YAML_SCANNER_ERROR:
            self = .scanner(context: context(from: parser),
                            problem: String(cString: parser.problem), problemMark(from: parser),
                            yaml: yaml)
        case YAML_PARSER_ERROR:
            self = .parser(context: context(from: parser),
                           problem: String(cString: parser.problem), problemMark(from: parser),
                           yaml: yaml)
        case YAML_COMPOSER_ERROR:
            self = .composer(context: context(from: parser),
                             problem: String(cString: parser.problem), problemMark(from: parser),
                             yaml: yaml)
        default:
            fatalError("Parser has unknown error: \(parser.error)!")
        }
    }

    init(from emitter: yaml_emitter_t) {
        switch emitter.error {
        case YAML_MEMORY_ERROR:
            self = .memory
        case YAML_EMITTER_ERROR:
            self = .emitter(problem: String(cString: emitter.problem))
        default:
            fatalError("Emitter has unknown error: \(emitter.error)!")
        }
    }
}

extension YamlError: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        switch self {
        case .no:
            return "No error is produced"
        case .memory:
            return "Memory error"
        case let .reader(problem, byteOffset, value, yaml):
            guard let (mark, contents) = markAndSnippet(from: yaml, byteOffset)
                else { return "\(problem) at byte offset: \(byteOffset), value: \(value)" }
            return "\(mark): error: reader: \(problem):\n" + contents.endingWithNewLine
                + String(repeating: " ", count: mark.column - 1) + "^"
        case let .scanner(context, problem, mark, yaml):
            return "\(mark): error: scanner: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .parser(context, problem, mark, yaml):
            return "\(mark): error: parser: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .composer(context, problem, mark, yaml):
            return "\(mark): error: composer: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .writer(problem), let .emitter(problem), let .representer(problem):
            return problem
        }
    }
}

extension YamlError {
    private func markAndSnippet(from yaml: String, _ byteOffset: Int) -> (Mark, String)? {
        #if USE_UTF8
            guard let (line, column, contents) = yaml.utf8LineNumberColumnAndContents(at: byteOffset)
                else { return nil }
        #else
            guard let (line, column, contents) = yaml.utf16LineNumberColumnAndContents(at: byteOffset / 2)
                else { return nil }
        #endif
        return (Mark(line: line + 1, column: column + 1), contents)
    }
}
