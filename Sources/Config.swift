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

enum ConfigError: Error {
  case missingEntry(key: String)
  case wrongType(key: String?)
}

struct ConfigEntry {
  enum Keys {
    static let sources = "sources"
    static let templatePath = "templatePath"
    static let templateName = "templateName"
    static let params = "params"
    static let output = "output"
  }

  let sources: [Path]
  let templatePath: String
  let templateName: String
  let parameters: [String: Any]
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
      throw ConfigError.wrongType(key: Keys.sources)
    }

    self.templatePath = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templatePath) ?? ""
    self.templateName = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templateName) ?? ""
    self.parameters = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]

    guard let output: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.output) else {
      throw ConfigError.missingEntry(key: Keys.output)
    }
    self.output = Path(output)
  }

  private static func getOptionalField<T>(yaml: [String: Any], key: String) throws -> T? {
    guard let value = yaml[key] else {
      return nil
    }
    guard let typedValue = value as? T else {
      throw ConfigError.wrongType(key: key)
    }
    return typedValue
  }

  static func parseCommandEntry(yaml: Any) throws -> [ConfigEntry] {
    if let e = yaml as? [String: Any] {
      return [try ConfigEntry(yaml: e)]
    } else if let e = yaml as? [[String: Any]] {
      return try e.map({ try ConfigEntry(yaml: $0) })
    } else {
      throw ConfigError.wrongType(key: nil)
    }
  }
}

struct Config {
  enum Keys {
    static let outputDir = "output_dir"
  }

  let outputDir: Path?
  let commands: [String: [ConfigEntry]]

  init(file: Path) throws {
    let content: String = try file.read()
    let anyConfig = try Yams.load(yaml: content)
    guard let config = anyConfig as? [String: Any] else {
      throw ConfigError.wrongType(key: nil)
    }
    self.outputDir = (config[Keys.outputDir] as? String).map({ Path($0) })
    var cmds: [String: [ConfigEntry]] = [:]
    for parserCmd in allParserCommands {
      if let cmdEntry = config[parserCmd.name] {
        cmds[parserCmd.name] = try ConfigEntry.parseCommandEntry(yaml: cmdEntry)
      }
    }
    self.commands = cmds
  }
}
