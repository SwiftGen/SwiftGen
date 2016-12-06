//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let allSubcommands = ["colors", "images", "storyboards", "strings", "fonts"]

let templatesListCommand = command(
  Option<String>("only", "", flag: "l",
  description: "If specified, only list templates valid for that specific subcommand") {
    guard allSubcommands.contains($0) else {
      throw ArgumentError.invalidType(value: $0, type: "subcommand", argument: "--only")
    }
    return $0
  },
  outputOption
) { onlySubcommand, output in
  let customTemplates = (try? appSupportTemplatesPath.children()) ?? []
  let bundledTemplates = (try? bundledTemplatesPath.children()) ?? []
  var outputLines = [String]()

  let printTemplates = { (prefix: String, list: [Path]) in
    for file in list where file.lastComponent.hasPrefix("\(prefix)-") && file.extension == "stencil" {
      let basename = file.lastComponentWithoutExtension
      let idx = basename.index(basename.startIndex, offsetBy: prefix.characters.count+1)
      let name = basename[idx..<basename.endIndex]
      outputLines.append("   - \(name)")
    }
  }

  let subcommandsToList = onlySubcommand.isEmpty ? allSubcommands : [onlySubcommand]
  for prefix in subcommandsToList {
    outputLines.append("\(prefix):")
    outputLines.append("  custom:")
    printTemplates(prefix, customTemplates)
    outputLines.append("  bundled:")
    printTemplates(prefix, bundledTemplates)
  }

  outputLines.append("---")
  outputLines.append("You can add custom templates in \(appSupportTemplatesPath).")
  outputLines.append("Simply name them 'subcmd-customname.stencil' where subcmd is one of the swiftgen subcommand,")
  outputLines.append("namely " + allSubcommands.map({"\($0)-xxx.stencil"}).joined(separator: ", ") + ".")
  outputLines.append("")

  output.write(content: outputLines.joined(separator: "\n"))
}

private func templatePathCommandGenerator(execute: @escaping (Path, OutputDestination) throws -> ()) -> CommandType {
  return command(
    Argument<String>("name",
      description: "the name of the template to find, like `colors` for the default one" +
      " or `colors-rawValue' for a specific one"),
    outputOption
  ) { name, output in
    do {
      let (prefix, shortName): (String, String)
      if let hyphenPos = name.characters.index(of: "-") {
        prefix = String(name.characters[name.characters.startIndex..<hyphenPos])
        shortName = String(name.characters[name.characters.index(after: hyphenPos)..<name.characters.endIndex])
      } else {
        prefix = name
        shortName = "default"
      }
      let path = try findTemplate(prefix: prefix, templateShortName: shortName, templateFullPath: "")
      try execute(path, output)
    } catch {
      printError(string: "error: failed to read template: \(error)")
    }
  }
}

let templatesCatCommand = templatePathCommandGenerator { (path: Path, output: OutputDestination) in
  let content: String = try path.read()
  output.write(content: content)
}

let templatesWhichCommand = templatePathCommandGenerator { (path: Path, output: OutputDestination) in
  output.write(content: "\(path.description)\n")
}
