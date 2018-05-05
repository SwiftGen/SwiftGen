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

// Note: there's a bug in SPM which causes compilation to fail because of the compilation order.
// Once it is fixed, we should move `ConfigEntry` back into an extension of `Config`.
// https://bugs.swift.org/browse/SR-5734

struct ConfigEntry {
  enum Keys {
    static let outputs = "outputs"
    static let params = "params"
    static let paths = "paths"

    // deprecated
    static let output = "output"
  }

  var outputs: [ConfigEntryOutput]
  var parameters: [String: Any]
  var paths: [Path]

  mutating func makeRelativeTo(inputDir: Path?, outputDir: Path?) {
    if let inputDir = inputDir {
      self.paths = self.paths.map { $0.isRelative ? inputDir + $0 : $0 }
    }
    self.outputs = self.outputs.map {
      var output = $0
      output.makeRelativeTo(outputDir: outputDir)
      return output
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

    if let data = yaml[Keys.outputs] {
      do {
        outputs = try ConfigEntryOutput.parseCommandOutput(yaml: data)
      } catch let error as Config.Error {
        throw error.withKeyPrefixed(by: Keys.outputs)
      }
    } else if yaml[Keys.output] != nil {
      // The config still contains the old style where all properties command properties
      // are at the same level
      outputs = try ConfigEntryOutput.parseCommandOutput(yaml: yaml)
    } else {
      throw Config.Error.missingEntry(key: Keys.outputs)
    }

    self.parameters = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]
  }

  static func parseCommandEntry(yaml: Any) throws -> [ConfigEntry] {
    if let entry = yaml as? [String: Any] {
      return [try ConfigEntry(yaml: entry)]
    } else if let entries = yaml as? [[String: Any]] {
      return try entries.map { try ConfigEntry(yaml: $0) }
    } else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary or Array", got: type(of: yaml))
    }
  }

  static func getOptionalField<T>(yaml: [String: Any], key: String) throws -> T? {
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
  func commandLine(forCommand cmd: String) -> [String] {
    let params = Parameters.flatten(dictionary: self.parameters)
    let paramsList = params.isEmpty ? "" : (" " + params.map { "--param \($0)" }.joined(separator: " "))
    let inputPaths = self.paths.map { $0.string }.joined(separator: " ")

    return outputs.map {
      let flags = $0.commandLineFlags()
      return "swiftgen \(cmd) \(flags.templateFlag)\(paramsList) \(flags.outputFlag) \(inputPaths)"
    }
  }
}
