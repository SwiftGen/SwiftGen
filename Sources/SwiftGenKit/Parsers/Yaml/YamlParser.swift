//
//  YamlParser.swift
//  SwiftGenKit
//
//  Created by John McIntosh on 1/17/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import Foundation
import PathKit
import Yams

public enum Yaml {
  public enum ParserError: Error, CustomStringConvertible {
    case directory
    case invalidFile

    public var description: String {
      switch self {
      case .directory:
        return "The input was a directory, but must be a specifc file."
      case .invalidFile:
        return "The file could not be parsed as a valid yaml or json file."
      }
    }
  }

  // MARK: Yaml File Parser

  public final class Parser: SwiftGenKit.Parser {
    var yamlMapping: [String: Any] = [:]
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    public func parse(path: Path) throws {
      guard path.isFile else {
        throw ParserError.directory
      }

      guard let string: String = try? path.read() else {
        throw ParserError.invalidFile
      }

      do {
        if let loadedMapping = try Yams.load(yaml: string) as? [String: Any] {
          yamlMapping = loadedMapping
        } else if let loadedSequence = try Yams.load(yaml: string) as? [Any] {
          yamlMapping = ["root_sequence": loadedSequence]
        } else if let loadedScalar = try Yams.load(yaml: string) {
          yamlMapping = ["root_scalar": loadedScalar]
        }
      } catch {
        throw ParserError.invalidFile
      }
    }
  }
}
