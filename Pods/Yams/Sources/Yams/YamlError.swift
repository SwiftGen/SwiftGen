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

/// Errors thrown by Yams APIs.
public enum YamlError: Error {
    // Used in `yaml_emitter_t` and `yaml_parser_t`
    /// `YAML_NO_ERROR`. No error is produced.
    case no

    /// `YAML_MEMORY_ERROR`. Cannot allocate or reallocate a block of memory.
    case memory

    // Used in `yaml_parser_t`
    /// `YAML_READER_ERROR`. Cannot read or decode the input stream.
    ///
    /// - parameter problem: Error description.
    /// - parameter offset:  The offset from `yaml.startIndex` at which the problem occured.
    /// - parameter value:   The problematic value (-1 is none).
    /// - parameter yaml:    YAML String which the problem occured while reading.
    case reader(problem: String, offset: Int?, value: Int32, yaml: String)

    // line and column start from 1, column is counted by unicodeScalars
    /// `YAML_SCANNER_ERROR`. Cannot scan the input stream.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while scanning.
    case scanner(context: Context?, problem: String, Mark, yaml: String)

    /// `YAML_PARSER_ERROR`. Cannot parse the input stream.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while parsing.
    case parser(context: Context?, problem: String, Mark, yaml: String)

    /// `YAML_COMPOSER_ERROR`. Cannot compose a YAML document.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while composing.
    case composer(context: Context?, problem: String, Mark, yaml: String)

    // Used in `yaml_emitter_t`
    /// `YAML_WRITER_ERROR`. Cannot write to the output stream.
    ///
    /// - parameter problem: Error description.
    case writer(problem: String)

    /// `YAML_EMITTER_ERROR`. Cannot emit a YAML stream.
    ///
    /// - parameter problem: Error description.
    case emitter(problem: String)

    /// Used in `NodeRepresentable`.
    ///
    /// - parameter problem: Error description.
    case representer(problem: String)

    /// String data could not be decoded with the specified encoding.
    ///
    /// - parameter encoding: The string encoding used to decode the string data.
    case dataCouldNotBeDecoded(encoding: String.Encoding)

    /// The error context.
    public struct Context: CustomStringConvertible {
        /// Context text.
        public let text: String
        /// Context position.
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
            let index: String.Index?
            if parser.encoding == YAML_UTF8_ENCODING {
                index = yaml.utf8
                    .index(yaml.utf8.startIndex, offsetBy: parser.problem_offset, limitedBy: yaml.utf8.endIndex)?
                    .samePosition(in: yaml)
            } else {
                index = yaml.utf16
                    .index(yaml.utf16.startIndex, offsetBy: parser.problem_offset / 2, limitedBy: yaml.utf16.endIndex)?
                    .samePosition(in: yaml)
            }
            let offset = index.map { yaml.distance(from: yaml.startIndex, to: $0) }
            self = .reader(problem: String(cString: parser.problem),
                           offset: offset,
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
        case let .reader(problem, offset, value, yaml):
            guard let (line, column, contents) = offset.flatMap(yaml.lineNumberColumnAndContents(at:)) else {
                return "\(problem) at offset: \(String(describing: offset)), value: \(value)"
            }
            let mark = Mark(line: line + 1, column: column + 1)
            return "\(mark): error: reader: \(problem):\n" + contents.endingWithNewLine
                + String(repeating: " ", count: column) + "^"
        case let .scanner(context, problem, mark, yaml):
            return "\(mark): error: scanner: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .parser(context, problem, mark, yaml):
            return "\(mark): error: parser: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .composer(context, problem, mark, yaml):
            return "\(mark): error: composer: \(context?.description ?? "")\(problem):\n" + mark.snippet(from: yaml)
        case let .writer(problem), let .emitter(problem), let .representer(problem):
            return problem
        case .dataCouldNotBeDecoded(encoding: let encoding):
            return "String could not be decoded from data using '\(encoding)' encoding"
        }
    }
}
