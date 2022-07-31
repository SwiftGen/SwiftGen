//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands.Template {
  struct List: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "List bundled and custom templates.")

    @Option(
      name: [.customLong("only"), .customShort("l")],
      help: .init("If specified, only list templates valid for that specific parser", valueName: "parser")
    )
    var parser: ParserCLI?

    @OptionGroup
    var output: Commands.OutputDestination

    func run() throws {
      let parsersList = parser.map { [$0] } ?? ParserCLI.all.sorted { $0.name < $1.name }

      let lines = parsersList.map(templatesFormattedList(parser:))
      try output.destination.write(content: lines.joined(separator: "\n"))
      try output.destination.write(
        content: """
        ---
        You can also specify custom templates by path, using `templatePath` instead of `templateName`.
        For more information, see the documentation on GitHub or use `swiftgen template doc`.
        """
      )
    }
  }
}

// MARK: - Helpers

private extension Commands.Template {
  static func templates(in path: Path) -> [Path] {
    guard let files = try? path.children() else { return [] }
    return files
      .filter { $0.extension == "stencil" }
      .sorted()
  }

  static func templatesFormattedList(parser: ParserCLI) -> String {
    func parserTemplates(in path: Path) -> [String] {
      templates(in: path + parser.templateFolder).map { "   - \($0.lastComponentWithoutExtension)" }
    }

    var lines = ["\(parser.name):"]
    let customTemplates = parserTemplates(in: Path.deprecatedAppSupportTemplates)
    if !customTemplates.isEmpty {
      lines.append("  custom (deprecated):")
      lines.append(contentsOf: customTemplates)
      lines.append("  bundled:")
    }
    lines.append(contentsOf: parserTemplates(in: Path.bundledTemplates))
    return lines.joined(separator: "\n")
  }
}
