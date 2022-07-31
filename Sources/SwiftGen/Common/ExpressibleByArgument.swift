//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Path: ExpressibleByArgument, Decodable {
  public init?(argument: String) {
    self.init(argument)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let decodedString = try container.decode(String.self)
    self.init(decodedString)
  }
}

extension ParserCLI: ExpressibleByArgument {
  public init?(argument: String) {
    guard let existing = Self.command(named: argument) else { return nil }
    self = existing
  }
}

extension CommandLogLevel: EnumerableFlag {
  public static let allCases: [CommandLogLevel] = [.quiet, .default, .verbose]

  public static func name(for value: Self) -> NameSpecification {
    switch value {
    case .quiet, .verbose:
      return .shortAndLong
    case .default:
      return .customLong("normal")
    }
  }

  public static func help(for value: CommandLogLevel) -> ArgumentHelp? {
    switch value {
    case .quiet:
      return "Hide all non error logs."
    case .verbose:
      return "Print each command being executed."
    case .default:
      return "Normal output."
    }
  }
}
