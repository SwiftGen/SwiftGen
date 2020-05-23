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
      description: "If specified, only list templates valid for that specific subcommand",
      validator: isSubcommandName
    ),
    OutputDestination.cliOption
  ) { onlySubcommand, output in
    try ErrorPrettifier.execute {
      let commandsList = onlySubcommand.isEmpty
        ? ParserCLI.allCommands
        : [ParserCLI.command(named: onlySubcommand)].compactMap { $0 }

      let lines = commandsList.map(templatesList(subcommand:))
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
  static func templatesList(subcommand: ParserCLI) -> String {
    func templates(in path: Path) -> [String] {
      guard let files = try? path.children() else { return [] }
      return files.lazy
        .filter { $0.extension == "stencil" }
        .sorted()
        .map { "   - \($0.lastComponentWithoutExtension)" }
    }

    var lines = ["\(subcommand.name):"]
    lines.append("  custom:")
    lines.append(contentsOf: templates(in: Path.appSupportTemplates + subcommand.templateFolder))
    lines.append("  bundled:")
    lines.append(contentsOf: templates(in: Path.bundledTemplates + subcommand.templateFolder))
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
  // - 'subcommand'
  // - 'template'
  // These will then be converted into an actual template path, and passed to the result closure.
  static func pathCommandGenerator(execute: @escaping (Path, OutputDestination) throws -> Void) -> CommandType {
    command(
      Argument<String>("subcommand", description: "the name of the subcommand for the template, like `colors`"),
      Argument<String>("template", description: "the name of the template to find, like `swift5` or `flat-swift5`"),
      OutputDestination.cliOption
    ) { subcommandName, templateName, output in
      try ErrorPrettifier.execute {
        guard let subcommand = ParserCLI.command(named: subcommandName) else { return }
        let template = TemplateRef.name(templateName)
        let path = try template.resolvePath(forSubcommand: subcommand.templateFolder)
        try execute(path, output)
      }
    }
  }
}
