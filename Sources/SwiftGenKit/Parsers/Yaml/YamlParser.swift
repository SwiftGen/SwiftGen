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
    case invalidFile(path: Path, reason: String)

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "Unable to parse file at \(path). \(reason)"
      }
    }
  }

  // MARK: Yaml File Parser

  public final class Parser: SwiftGenKit.Parser {
    var files: [File] = []
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler
    }

    enum SupportedTypes {
      static let json = "json"
      static let yaml = "yaml"
      static let yml = "yml"
      static let all = [json, yaml, yml]

      static func supports(extension: String) -> Bool {
        return all.contains { $0.caseInsensitiveCompare(`extension`) == .orderedSame }
      }
    }

    public func parse(path: Path) throws {
      if path.isFile {
        let parentDir = path.absolute().parent()
        files.append(try File(path: path, relativeTo: parentDir))
      } else {
        let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
        let parentDir = path.absolute()

        for file in dirChildren where SupportedTypes.supports(extension: file.extension ?? "") {
          files.append(try File(path: file, relativeTo: parentDir))
        }
      }
    }
  }
}
