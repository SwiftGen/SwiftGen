//
// SwiftGen
// Copyright © 2020 SwiftGen
// MIT Licence
//

import AppKit
import Commander
import PathKit

enum TemplateCLI {
  static let list = command(
    Option<ParserCLI?>(
      "only",
      default: nil,
      flag: "l",
      description: "If specified, only list templates valid for that specific parser"
    ),
    OutputDestination.cliOption
  ) { parser, output in
    try ErrorPrettifier.execute {
      let parsersList = parser.map { [$0] } ?? ParserCLI.allCommands

      let lines = parsersList.map(templatesFormattedList(parser:))
      try output.write(content: lines.joined(separator: "\n"))
      try output.write(
        content: """
          ---
          You can also specify custom templates by path, using `templatePath` instead of `templateName`.
          For more information, see the documentation on GitHub or use `swiftgen template doc`.
          """
      )
    }
  }

  static let doc = command(
    Argument<ParserCLI?>("parser", description: "the name of the parser the template is for, like `strings`"),
    Argument<String?>("template", description: "the name of the template to find, like `swift5` or `flat-swift5`")
  ) { parser, template in
    var path = "templates/"
    if let parser = parser {
      path += "\(parser.name)/"

      // If we also have a template argument, ensure that is one of the bundled templates for that parser
      if let template = template {
        let list = templates(in: Path.bundledTemplates + parser.templateFolder).map(\.lastComponentWithoutExtension)
        guard list.contains(template) else {
          throw ArgumentParserError(
            """
            If provided, the 2nd argument must be the name of a bundled template for the given parser, i.e. one of:
            \(list.map { " - \($0)" }.joined(separator: "\n"))
            """
          )
        }
        path += "\(template).md"
      }
    }
    let url = gitHubDocURL(version: Version.swiftgen, path: path)
    logMessage(.info, "Opening documentation: \(url)")
    NSWorkspace.shared.open(url)
  }

  static let cat = pathCommandGenerator { (path: Path, output: OutputDestination) in
    let content: String = try path.read()
    try output.write(content: content)
  }

  static let which = pathCommandGenerator { (path: Path, output: OutputDestination) in
    try output.write(content: "\(path.description)\n")
  }
}

// MARK: Private Methods

private extension TemplateCLI {
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
    lines.append("  custom (deprecated):")
    lines.append(contentsOf: parserTemplates(in: Path.deprecatedAppSupportTemplates))
    lines.append("  bundled:")
    lines.append(contentsOf: parserTemplates(in: Path.bundledTemplates))
    return lines.joined(separator: "\n")
  }

  // Defines a 'generic' command for doing an operation on a named template. It'll receive the following
  // arguments from the user:
  // - 'parser'
  // - 'template'
  // These will then be converted into an actual template path, and passed to the result closure.
  static func pathCommandGenerator(execute: @escaping (Path, OutputDestination) throws -> Void) -> CommandType {
    command(
      Argument<ParserCLI>("parser", description: "the name of the parser the template is for, like `xcassets`"),
      Argument<String>("template", description: "the name of the template to find, like `swift5` or `flat-swift5`"),
      OutputDestination.cliOption
    ) { parser, templateName, output in
      try ErrorPrettifier.execute {
        let template = TemplateRef.name(templateName)
        let path = try template.resolvePath(forParser: parser)
        try execute(path, output)
      }
    }
  }
}

// MARK: Allow ParserCLI name as command line argument

extension ParserCLI: ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = ParserCLI.command(named: value) {
        self = value
      } else {
        throw ArgumentError.invalidType(value: value, type: "parser name", argument: nil)
      }
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}
