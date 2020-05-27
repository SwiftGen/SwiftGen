//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import PathKit

enum TemplatesCLI {
  static let list = command(
    Option<String>(
      "only",
      default: "",
      flag: "l",
      description: "If specified, only list templates valid for that specific parser",
      validator: isSubcommandName
    ),
    OutputDestination.cliOption
  ) { parserName, output in
    try ErrorPrettifier.execute {
      let parsersList = parserName.isEmpty
        ? ParserCLI.allCommands
        : [ParserCLI.command(named: parserName)].compactMap { $0 }

      let lines = parsersList.map(templatesFormattedList(parser:))
      try output.write(content: lines.joined(separator: "\n"))
      try output.write(
        content: """
          ---
          You can add custom templates in \(Path.appSupportTemplates).
          You can also specify templates by path using `templatePath` instead of `templateName`.
          For more information, see the documentation on GitHub.
          """
      )
    }
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

private extension TemplatesCLI {
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
    lines.append("  custom:")
    lines.append(contentsOf: parserTemplates(in: Path.appSupportTemplates))
    lines.append("  bundled:")
    lines.append(contentsOf: parserTemplates(in: Path.bundledTemplates))
    return lines.joined(separator: "\n")
  }

  static func isSubcommandName(name: String) throws -> String {
    guard ParserCLI.allCommands.contains(where: { $0.name == name }) else {
      throw ArgumentError.invalidType(value: name, type: "subcommand", argument: "--only")
    }
    return name
  }

  // Defines a 'generic' command for doing an operation on a named template. It'll receive the following
  // arguments from the user:
  // - 'parser'
  // - 'template'
  // These will then be converted into an actual template path, and passed to the result closure.
  static func pathCommandGenerator(execute: @escaping (Path, OutputDestination) throws -> Void) -> CommandType {
    command(
      Argument<String>("parser", description: "the name of the parser the template is for, like `xcassets`"),
      Argument<String>("template", description: "the name of the template to find, like `swift5` or `flat-swift5`"),
      OutputDestination.cliOption
    ) { parserName, templateName, output in
      try ErrorPrettifier.execute {
        guard let parser = ParserCLI.command(named: parserName) else { return }
        let template = TemplateRef.name(templateName)
        let path = try template.resolvePath(forParser: parser)
        try execute(path, output)
      }
    }
  }
}
