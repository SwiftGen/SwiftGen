//
//  ConfigEntry.swift
//  swiftgen
//
//  Created by Olivier Halligon on 21/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit
import enum StencilSwiftKit.Parameters

// MARK: - Config.Entry

struct ConfigEntry {
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

  mutating func makeRelativeTo(inputDir: Path?, outputDir: Path?) {
    if let inputDir = inputDir {
      self.paths = self.paths.map { $0.isRelative ? inputDir + $0 : $0 }
    }
    if let outputDir = outputDir, self.output.isRelative {
      self.output = outputDir + self.output
    }
  }
}

extension ConfigEntry {
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

    let templateName: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templateName) ?? ""
    let templatePath: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templatePath) ?? ""
    self.template = try TemplateRef(templateShortName: templateName, templateFullPath: templatePath)

    self.parameters = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]

    guard let output: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.output) else {
      throw Config.Error.missingEntry(key: Keys.output)
    }
    self.output = Path(output)
  }

  static func parseCommandEntry(yaml: Any) throws -> [ConfigEntry] {
    if let entry = yaml as? [String: Any] {
      return [try ConfigEntry(yaml: entry)]
    } else if let entry = yaml as? [[String: Any]] {
      return try entry.map({ try ConfigEntry(yaml: $0) })
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

/// Convert to CommandLine-equivalent string (for verbose mode, printing linting info, …)
///
extension ConfigEntry {
  func commandLine(forCommand cmd: String) -> String {
    let tplFlag: String = {
      switch self.template {
      case .name(let name): return "-t \(name)"
      case .path(let path): return "-p \(path.string)"
      }
    }()
    let params = Parameters.flatten(dictionary: self.parameters)
    let paramsList = params.isEmpty ? "" : (" " + params.map { "--param \($0)" }.joined(separator: " "))
    let inputPaths = self.paths.map { $0.string }.joined(separator: " ")
    return "swiftgen \(cmd) \(tplFlag)\(paramsList) -o \(self.output) \(inputPaths)"
  }
}
