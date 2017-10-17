//
//  Config.swift
//  swiftgen
//
//  Created by Olivier Halligon on 01/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit
import StencilSwiftKit
import SwiftGenKit
import Yams

// MARK: - Config

struct Config {
  enum Keys {
    static let inputDir = "input_dir"
    static let outputDir = "output_dir"
  }

  let inputDir: Path?
  let outputDir: Path?
  let commands: [String: [Config.Entry]]

  init(file: Path) throws {
    if !file.exists {
      throw Config.Error.pathNotFound(path: file)
    }
    let content: String = try file.read()
    let anyConfig = try Yams.load(yaml: content)
    guard let config = anyConfig as? [String: Any] else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: anyConfig))
    }
    self.inputDir = (config[Keys.inputDir] as? String).map({ Path($0) })
    self.outputDir = (config[Keys.outputDir] as? String).map({ Path($0) })
    var cmds: [String: [Config.Entry]] = [:]
    for parserCmd in allParserCommands {
      if let cmdEntry = config[parserCmd.name] {
        do {
          cmds[parserCmd.name] = try Config.Entry.parseCommandEntry(yaml: cmdEntry)
        } catch let e as Config.Error {
          // Prefix the name of the command for a better error message
          if case .missingEntry(let key) = e {
            throw Config.Error.missingEntry(key: "\(parserCmd.name).\(key)")
          }
          throw e
        }
      }
    }
    self.commands = cmds
  }

  // MARK: - Config.Entry

  struct Entry {
    enum Keys {
      static let paths = "paths"
      static let templateName = "templateName"
      static let templatePath = "templatePath"
      static let params = "params"
      static let output = "output"
    }

    var paths: [Path]
    var template: TemplateRef
    var parameters: [String: Any]
    var output: Path

    init(yaml: [String: Any]) throws {
      guard let srcs = yaml[Keys.paths] else {
        throw Config.Error.missingEntry(key: Keys.paths)
      }
      if let srcs = srcs as? String {
        self.paths = [Path(srcs)]
      } else if let srcs = srcs as? [String] {
        self.paths = srcs.map({ Path($0) })
      } else {
        throw Config.Error.wrongType(key: Keys.paths, expected: "Path or array of Paths", got: type(of: srcs))
      }

      let templateName: String? = try Config.Entry.getOptionalField(yaml: yaml, key: Keys.templateName)
      let templatePath: Path? = try Config.Entry.getOptionalField(yaml: yaml, key: Keys.templatePath)
      self.template = try TemplateRef(templateShortName: templateName ?? "", templateFullPath: templatePath)

      self.parameters = try Config.Entry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]

      guard let output: String = try Config.Entry.getOptionalField(yaml: yaml, key: Keys.output) else {
        throw Config.Error.missingEntry(key: Keys.output)
      }
      self.output = Path(output)
    }

    mutating func makeRelativeTo(inputDir: Path?, outputDir: Path?) {
      if let inputDir = inputDir {
        self.paths = self.paths.map { $0.isRelative ? inputDir + $0 : $0 }
      }
      if let outputDir = outputDir, self.output.isRelative {
        self.output = outputDir + self.output
      }
    }

    static func parseCommandEntry(yaml: Any) throws -> [Config.Entry] {
      if let e = yaml as? [String: Any] {
        return [try Config.Entry(yaml: e)]
      } else if let e = yaml as? [[String: Any]] {
        return try e.map({ try Config.Entry(yaml: $0) })
      } else {
        throw Config.Error.wrongType(key: nil, expected: "Dictionary or Array", got: type(of: yaml))
      }
    }

    private static func getOptionalField<T>(yaml: [String: Any], key: String) throws -> T? {
      guard let value = yaml[key] else {
        return nil
      }
      guard let typedValue = value as? T else {
        throw Config.Error.wrongType(key: key, expected: String(describing: T.self), got: type(of: value))
      }
      return typedValue
    }
  }
}

// MARK: - Config.Error

extension Config {
  enum Error: Swift.Error, CustomStringConvertible {
    case missingEntry(key: String)
    case wrongType(key: String?, expected: String, got: Any.Type)
    case pathNotFound(path: Path)

    var description: String {
      switch self {
      case .missingEntry(let key):
        return "Missing entry for key \(key)."
      case .wrongType(let key, let expected, let got):
        return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)."
      case .pathNotFound(let path):
        return "File \(path) not found."
      }
    }
  }
}
