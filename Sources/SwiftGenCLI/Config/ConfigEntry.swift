//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit

// MARK: - Config.Entry

// Note: there's a bug in SPM which causes compilation to fail because of the compilation order.
// Once it is fixed, we should move `ConfigEntry` back into an extension of `Config`.
// https://bugs.swift.org/browse/SR-5734

public struct ConfigEntry {
  enum Keys {
    static let inputs = "inputs"
    static let filter = "filter"
    static let options = "options"
    static let outputs = "outputs"

    // Legacy: remove this once we stop supporting the output key at subcommand level
    static let output = "output"
    static let params = "params"
    static let templateName = "templateName"
    static let templatePath = "templatePath"
    // Legacy: remove this once we stop supporting the old paths key (replaced by inputs)
    static let paths = "paths"
  }

  var inputs: [Path]
  var filter: String?
  var options: [String: Any]
  var outputs: [ConfigEntryOutput]

  mutating func makeRelativeTo(inputDir: Path?, outputDir: Path?) {
    if let inputDir = inputDir {
      self.inputs = self.inputs.map { $0.isRelative ? inputDir + $0 : $0 }
    }
    self.outputs = self.outputs.map { output in
      var result = output
      result.makingRelativeTo(outputDir: outputDir)
      return result
    }
  }
}

extension ConfigEntry {
  init(yaml: [String: Any], cmd: String, logger: (LogLevel, String) -> Void) throws {
    if let inputs = yaml[Keys.inputs] {
      self.inputs = try Self.parseValueOrArray(yaml: inputs, key: Keys.inputs, parseValue: Path.init(stringLiteral:))
    } else if let inputs = yaml[Keys.paths] {
      // Legacy: remove this once we stop supporting the old paths key (replaced by inputs)
      logger(.warning, "\(cmd): `paths` is a deprecated in favour of `inputs`.")
      self.inputs = try Self.parseValueOrArray(yaml: inputs, key: Keys.inputs, parseValue: Path.init(stringLiteral:))
    } else {
      throw Config.Error.missingEntry(key: Keys.inputs)
    }

    filter = yaml[Keys.filter] as? String
    options = try Self.getOptionalField(yaml: yaml, key: Keys.options) ?? [:]

    if let outputs = yaml[Keys.outputs] {
      do {
        self.outputs = try ConfigEntryOutput.parseCommandOutput(yaml: outputs, logger: logger)
      } catch let error as Config.Error {
        throw error.withKeyPrefixed(by: Keys.outputs)
      }
    } else if yaml[Keys.output] != nil {
      // Legacy: remove this once we stop supporting the output key at subcommand level
      // The config still contains the old style where all properties command properties
      // are at the same level
      self.outputs = try ConfigEntryOutput.parseCommandOutput(yaml: yaml, logger: logger)
    } else {
      throw Config.Error.missingEntry(key: Keys.outputs)
    }

    // Warn about deprecated parameters
    // Legacy: remove this once we stop supporting the output key at subcommand level
    for key in [Keys.output, Keys.params, Keys.templateName, Keys.templatePath] where yaml[key] != nil {
      logger(.warning, "\(cmd): `\(key)` is a deprecated in favour of `outputs.\(key)`.")
    }
  }

  static func parseCommandEntry(yaml: Any, cmd: String, logger: (LogLevel, String) -> Void) throws -> [ConfigEntry] {
    try parseValueOrArray(yaml: yaml) { yaml in
      try ConfigEntry(yaml: yaml, cmd: cmd, logger: logger)
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

  static func parseValueOrArray<T, U>(yaml: Any, key: String? = nil, parseValue: (T) throws -> U) throws -> [U] {
    if let value = yaml as? T {
      return [try parseValue(value)]
    } else if let value = yaml as? [T] {
      return try value.map { try parseValue($0) }
    } else {
      throw Config.Error.wrongType(key: key, expected: "\(T.self) or Array of \(T.self)", got: type(of: yaml))
    }
  }
}

/// Convert to CommandLine-equivalent string (for verbose mode, printing linting info, …)
///
extension ConfigEntry {
  func commandLine(forCommand cmd: String) -> [String] {
    outputs.map { output in
      output.commandLine(forCommand: cmd, inputs: inputs, filter: filter, options: options)
    }
  }
}
