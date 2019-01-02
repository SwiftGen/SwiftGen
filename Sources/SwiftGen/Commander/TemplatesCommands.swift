//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Commander
import PathKit

let allSubcommands = allParserCommands.map { $0.name }

private func isSubcommandName(name: String) throws -> String {
  guard allSubcommands.contains(name) else {
    throw ArgumentError.invalidType(value: name, type: "subcommand", argument: "--only")
  }
  return name
}

let templatesListCommand = command(
  Option<String>("only",
                 default: "",
                 flag: "l",
                 description: "If specified, only list templates valid for that specific subcommand",
                 validator: isSubcommandName),
  outputOption
) { onlySubcommand, output in
  try ErrorPrettifier.execute {
    var outputLines = [String]()

    let printTemplates = { (subcommand: String, path: Path) in
      guard let files = try? (path + subcommand).children() else { return }

      for file in files where file.extension == "stencil" {
        let basename = file.lastComponentWithoutExtension
        outputLines.append("   - \(basename)")
      }
    }

    let list = onlySubcommand.isEmpty ? allParserCommands : allParserCommands.filter { $0.name == onlySubcommand }
    for subcommand in list {
      outputLines.append("\(subcommand.name):")
      outputLines.append("  custom:")
      printTemplates(subcommand.templateFolder, appSupportTemplatesPath)
      outputLines.append("  bundled:")
      printTemplates(subcommand.templateFolder, bundledTemplatesPath)
    }

    outputLines.append("---")
    outputLines.append("You can add custom templates in \(appSupportTemplatesPath).")
    outputLines.append("You can also specify templates by path using `templatePath` instead of `templateName`.")
    outputLines.append("For more information, see the documentation on GitHub.")
    outputLines.append("")

    try output.write(content: outputLines.joined(separator: "\n"))
  }
}

// Defines a 'generic' command for doing an operation on a named template. It'll receive the following
// arguments from the user:
// - 'subcommand'
// - 'template'
// These will then be converted into an actual template path, and passed to the result closure.
private func templatePathCommandGenerator(execute: @escaping (Path, OutputDestination) throws -> Void) -> CommandType {
  return command(
    Argument<String>(
      "subcommand",
      description: "the name of the subcommand for the template, like `colors`"),
    Argument<String>(
      "template",
      description: "the name of the template to find, like `swift3` or `dot-syntax`"),
    outputOption
  ) { subcommandName, templateName, output in
    try ErrorPrettifier.execute {
      guard let subcommand = allParserCommands.first(where: { $0.name == subcommandName }) else { return }
      let template = TemplateRef.name(templateName)
      let path = try template.resolvePath(forSubcommand: subcommand.templateFolder)
      try execute(path, output)
    }
  }
}

let templatesCatCommand = templatePathCommandGenerator { (path: Path, output: OutputDestination) in
  let content: String = try path.read()
  try output.write(content: content)
}

let templatesWhichCommand = templatePathCommandGenerator { (path: Path, output: OutputDestination) in
  try output.write(content: "\(path.description)\n")
}
