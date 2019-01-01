//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
import enum StencilSwiftKit.Parameters

// MARK: - Config.Entry.Output

struct ConfigEntryOutput {
  enum Keys {
    static let output = "output"
    static let params = "params"
    static let templateName = "templateName"
    static let templatePath = "templatePath"
  }

  var output: Path
  var parameters: [String: Any]
  var template: TemplateRef

  mutating func makingRelativeTo(outputDir: Path?) {
    if let outputDir = outputDir, self.output.isRelative {
      self.output = outputDir + self.output
    }
  }
}

extension ConfigEntryOutput {
  init(yaml: [String: Any], logger: (LogLevel, String) -> Void) throws {
    guard let output: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.output) else {
      throw Config.Error.missingEntry(key: Keys.output)
    }
    self.output = Path(output)

    self.parameters = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.params) ?? [:]

    let templateName: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templateName) ?? ""
    let templatePath: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templatePath) ?? ""
    self.template = try TemplateRef(templateShortName: templateName, templateFullPath: templatePath)
  }

  static func parseCommandOutput(yaml: Any, logger: (LogLevel, String) -> Void) throws -> [ConfigEntryOutput] {
    return try ConfigEntry.parseValueOrArray(yaml: yaml) {
      try ConfigEntryOutput(yaml: $0, logger: logger)
    }
  }
}

/// Convert to CommandLine-equivalent string (for verbose mode, printing linting info, …)
///
extension ConfigEntryOutput {
  func commandLine(forCommand cmd: String, inputs: [Path], filter: String?) -> String {
    let tplFlag: String = {
      switch self.template {
      case .name(let name): return "-t \(name)"
      case .path(let path): return "-p \(path.string)"
      }
    }()
    let filterFlag = filter.map { "--filter \($0)" } ?? ""
    let params = Parameters.flatten(dictionary: self.parameters)

    return [
      "swiftgen",
      cmd,
      tplFlag,
      params.map { "--param \($0)" }.joined(separator: " "),
      "-o \(self.output)",
      filterFlag,
      inputs.map { $0.string }.joined(separator: " ")
    ].filter { !$0.isEmpty }.joined(separator: " ")
  }
}
