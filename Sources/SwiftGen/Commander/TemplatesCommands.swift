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
      let list = onlySubcommand.isEmpty
        ? ParserCLI.allCommands
        : [ParserCLI.command(named: onlySubcommand)].compactMap { $0 }
      var outputLines: [String] = []
      for subcommand in list {
        outputLines.append(templatesList(subcommand: subcommand))
      }

      outputLines.append(
        """
          ---
          You can add custom templates in \(Path.appSupportTemplates).
          You can also specify templates by path using `templatePath` instead of `templateName`.
          For more information, see the documentation on GitHub.
          """
      )

      try output.write(content: outputLines.joined(separator: "\n"))
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
    func templates(for subcommand: String, in path: Path) -> String {
      guard let files = try? (path + subcommand).children() else { return "" }
      let list = files
        .filter { $0.extension == "stencil" }
        .map { "   - \($0.lastComponentWithoutExtension)" }
      return list.joined(separator: "\n")
    }

    return """
      \(subcommand.name):
      custom:
      \(templates(for: subcommand.templateFolder, in: Path.appSupportTemplates))
      bundled:
      \(templates(for: subcommand.templateFolder, in: Path.bundledTemplates))
      """
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
    return command(
      Argument<String>("subcommand", description: "the name of the subcommand for the template, like `colors`"),
      Argument<String>("template", description: "the name of the template to find, like `swift3` or `dot-syntax`"),
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
