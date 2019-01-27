//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit

// MARK: - Config.Entry

// Note: there's a bug in SPM which causes compilation to fail because of the compilation order.
// Once it is fixed, we should move `ConfigEntry` back into an extension of `Config`.
// https://bugs.swift.org/browse/SR-5734

struct ConfigEntry {
  enum Keys {
    static let inputs = "inputs"
    static let filter = "filter"
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
  var outputs: [ConfigEntryOutput]

  mutating func makingRelativeTo(inputDir: Path?, outputDir: Path?) {
    if let inputDir = inputDir {
      self.inputs = self.inputs.map { $0.isRelative ? inputDir + $0 : $0 }
    }
    self.outputs = self.outputs.map {
      var output = $0
      output.makingRelativeTo(outputDir: outputDir)
      return output
    }
  }
}

extension ConfigEntry {
  init(yaml: [String: Any], cmd: String, logger: (LogLevel, String) -> Void) throws {
    if let inputs = yaml[Keys.inputs] {
      self.inputs = try ConfigEntry.parseValueOrArray(yaml: inputs, key: Keys.inputs) {
        Path($0)
      }
    } else if let inputs = yaml[Keys.paths] {
      // Legacy: remove this once we stop supporting the old paths key (replaced by inputs)
      logger(.warning, "\(cmd): `paths` is a deprecated in favour of `inputs`.")
      self.inputs = try ConfigEntry.parseValueOrArray(yaml: inputs, key: Keys.inputs) {
        Path($0)
      }
    } else {
      throw Config.Error.missingEntry(key: Keys.inputs)
    }

    filter = yaml[Keys.filter] as? String

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
    return try ConfigEntry.parseValueOrArray(yaml: yaml) {
      try ConfigEntry(yaml: $0, cmd: cmd, logger: logger)
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
    return outputs.map {
      $0.commandLine(forCommand: cmd, inputs: inputs, filter: filter)
    }
  }
}
