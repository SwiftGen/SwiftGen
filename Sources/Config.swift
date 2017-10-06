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

enum ConfigError: Error, CustomStringConvertible {
  case missingEntry(key: String)
  case wrongType(key: String?, expected: String, got: Any.Type)

  var description: String {
    switch self {
    case .missingEntry(let key):
      return "Missing entry for key \(key)"
    case .wrongType(let key, let expected, let got):
      return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)"
    }
  }
}

// MARK: - ConfigEntry

struct ConfigEntry {
  enum Keys {
    static let sources = "sources"
    static let templatePath = "templatePath"
    static let templateName = "templateName"
    static let params = "params"
    static let output = "output"
  }

  var sources: [Path]
  var templatePath: Path?
  var templateName: String?
  var parameters: [String: Any]
  var output: Path

  init(yaml: [String: Any]) throws {
    guard let srcs = yaml[Keys.sources] else {
      throw ConfigError.missingEntry(key: Keys.sources)
    }
    if let srcs = srcs as? String {
      self.sources = [Path(srcs)]
    } else if let srcs = srcs as? [String] {
      self.sources = srcs.map({ Path($0) })
    } else {
      throw ConfigError.wrongType(key: Keys.sources, expected: "Path or array of Paths", got: type(of: srcs))
    }

    self.templatePath = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templatePath)
    self.templateName = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templateName)
    self.parameters = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]

    guard let output: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.output) else {
      throw ConfigError.missingEntry(key: Keys.output)
    }
    self.output = Path(output)
  }

  mutating func makeRelativeTo(inputDir: Path?, outputDir: Path?) {
    if let inputDir = inputDir {
      self.sources = self.sources.map { $0.isRelative ? inputDir + $0 : $0 }
      if let tplPath = self.templatePath, tplPath.isRelative {
        self.templatePath = inputDir + tplPath
      }
    }
    if let outputDir = outputDir, self.output.isRelative {
      self.output = outputDir + self.output
    }
  }

  static func parseCommandEntry(yaml: Any) throws -> [ConfigEntry] {
    if let e = yaml as? [String: Any] {
      return [try ConfigEntry(yaml: e)]
    } else if let e = yaml as? [[String: Any]] {
      return try e.map({ try ConfigEntry(yaml: $0) })
    } else {
      throw ConfigError.wrongType(key: nil, expected: "Dictionary or Array", got: type(of: yaml))
    }
  }

  private static func getOptionalField<T>(yaml: [String: Any], key: String) throws -> T? {
    guard let value = yaml[key] else {
      return nil
    }
    guard let typedValue = value as? T else {
      throw ConfigError.wrongType(key: key, expected: String(describing: T.self), got: type(of: value))
    }
    return typedValue
  }
}

// MARK: - Config

struct Config {
  enum Keys {
    static let inputDir = "input_dir"
    static let outputDir = "output_dir"
  }

  let inputDir: Path?
  let outputDir: Path?
  let commands: [String: [ConfigEntry]]

  init(file: Path) throws {
    let content: String = try file.read()
    let anyConfig = try Yams.load(yaml: content)
    guard let config = anyConfig as? [String: Any] else {
      throw ConfigError.wrongType(key: nil, expected: "Dictionary", got: type(of: anyConfig))
    }
    self.inputDir = (config[Keys.inputDir] as? String).map({ Path($0) })
    self.outputDir = (config[Keys.outputDir] as? String).map({ Path($0) })
    var cmds: [String: [ConfigEntry]] = [:]
    for parserCmd in allParserCommands {
      if let cmdEntry = config[parserCmd.name] {
        do {
          cmds[parserCmd.name] = try ConfigEntry.parseCommandEntry(yaml: cmdEntry)
        } catch let e as ConfigError {
          // Prefix the name of the command for a better error message
          if case .missingEntry(let key) = e {
            throw ConfigError.missingEntry(key: "\(parserCmd.name).\(key)")
          }
          throw e
        }
      }
    }
    self.commands = cmds
  }
}
