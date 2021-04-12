//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import Foundation
import PathKit
import SwiftGenKit

// MARK: - Config

public struct Config {
  enum Keys: String {
    case inputDir = "input_dir"
    case outputDir = "output_dir"
  }

  public let inputDir: Path?
  public let outputDir: Path?
  public let commands: [(command: ParserCLI, entry: ConfigEntry)]
  public let sourcePath: Path
}

extension Config {
  public init(
    file: Path,
    env: [String: String] = ProcessInfo.processInfo.environment,
    logger: (LogLevel, String) -> Void = logMessage
  ) throws {
    if !file.exists {
      throw Config.Error.pathNotFound(path: file)
    }

    let anyConfig = try YAML.read(path: file, env: env)
    try self.init(yaml: anyConfig, sourcePath: file.parent(), logger: logger)
  }

  public init(
    content: String,
    env: [String: String],
    sourcePath: Path,
    logger: (LogLevel, String) -> Void
  ) throws {
    let anyConfig = try YAML.decode(string: content, env: env)
    try self.init(yaml: anyConfig, sourcePath: sourcePath, logger: logger)
  }

  private init(
    yaml: Any?,
    sourcePath: Path,
    logger: (LogLevel, String) -> Void
  ) throws {
    self.sourcePath = sourcePath

    guard let config = yaml as? [String: Any] else {
      throw Config.Error.wrongType(key: nil, expected: "Dictionary", got: type(of: yaml))
    }
    self.inputDir = (config[Keys.inputDir.rawValue] as? String).map { Path($0) }
    self.outputDir = (config[Keys.outputDir.rawValue] as? String).map { Path($0) }

    var cmds: [(ParserCLI, ConfigEntry)] = []
    var errors: [Error] = []
    for (cmdName, cmdEntry) in config.filter({ Keys(rawValue: $0.0) == nil }).sorted(by: { $0.0 < $1.0 }) {
      if let parserCmd = ParserCLI.command(named: cmdName) {
        do {
          cmds += try ConfigEntry.parseCommandEntry(
            yaml: cmdEntry,
            cmd: parserCmd.name,
            logger: logger
          )
            .map { (parserCmd, $0) }
        } catch let error as Config.Error {
          // Prefix the name of the command for a better error message
          errors.append(error.withKeyPrefixed(by: parserCmd.name))
        }
      } else {
        errors.append(Config.Error.unknownParser(name: cmdName))
      }
    }

    if errors.isEmpty {
      self.commands = cmds
    } else {
      throw Error.multipleErrors(errors)
    }
  }
}

// MARK: - Config.Error

extension Config {
  public enum Error: Swift.Error, CustomStringConvertible {
    case missingEntry(key: String)
    case multipleErrors([Swift.Error])
    case pathNotFound(path: Path)
    case unknownParser(name: String)
    case wrongType(key: String?, expected: String, got: Any.Type)

    public var description: String {
      switch self {
      case .missingEntry(let key):
        return "Missing entry for key \(key)."
      case .multipleErrors(let errors):
        return errors.map { String(describing: $0) }.joined(separator: "\n")
      case .pathNotFound(let path):
        return "File \(path) not found."
      case .unknownParser(let name):
        return "Parser `\(name)` does not exist."
      case .wrongType(let key, let expected, let got):
        return "Wrong type for key \(key ?? "root"): expected \(expected), got \(got)."
      }
    }

    func withKeyPrefixed(by prefix: String) -> Config.Error {
      switch self {
      case .missingEntry(let key):
        return Config.Error.missingEntry(key: "\(prefix).\(key)")
      case .wrongType(let key, let expected, let got):
        let fullKey = [prefix, key].compactMap({ $0 }).joined(separator: ".")
        return Config.Error.wrongType(key: fullKey, expected: expected, got: got)
      default:
        return self
      }
    }
  }
}
