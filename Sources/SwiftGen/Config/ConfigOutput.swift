//
//  ConfigOutput.swift
//  swiftgen
//
//  Created by David Jennes on 05/05/2018.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

import PathKit

// MARK: - Config.Entry.Output

struct ConfigEntryOutput {
  enum Keys {
    static let templateName = "templateName"
    static let templatePath = "templatePath"
    static let output = "output"
  }

  var output: Path
  var template: TemplateRef

  mutating func makeRelativeTo(outputDir: Path?) {
    if let outputDir = outputDir, self.output.isRelative {
      self.output = outputDir + self.output
    }
  }
}

extension ConfigEntryOutput {
  init(yaml: [String: Any]) throws {
    let templateName: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templateName) ?? ""
    let templatePath: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.templatePath) ?? ""
    self.template = try TemplateRef(templateShortName: templateName, templateFullPath: templatePath)

    guard let output: String = try ConfigEntry.getOptionalField(yaml: yaml, key: Keys.output) else {
      throw Config.Error.missingEntry(key: Keys.output)
    }
    self.output = Path(output)
  }

  static func parseCommandOutput(yaml: Any) throws -> [ConfigEntryOutput] {
    if let entry = yaml as? [String: Any] {
      return [try ConfigEntryOutput(yaml: entry)]
    } else if let entry = yaml as? [[String: Any]] {
      return try entry.map({ try ConfigEntryOutput(yaml: $0) })
    } else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary or Array", got: type(of: yaml))
    }
  }
}

/// Convert to CommandLine-equivalent string (for verbose mode, printing linting info, …)
///
extension ConfigEntryOutput {
  func commandLineFlags() -> (templateFlag: String, outputFlag: String) {
    let tplFlag: String = {
      switch self.template {
      case .name(let name): return "-t \(name)"
      case .path(let path): return "-p \(path.string)"
      }
    }()

    return (templateFlag: tplFlag, outputFlag: "-o \(self.output)")
  }
}
