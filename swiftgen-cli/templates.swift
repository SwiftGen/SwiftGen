//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit
import GenumKit

let allSubcommands = ["colors", "images", "storyboards", "strings"]

let templatesCommand = command(
  Option<String>("only", "", flag: "l", description: "If specified, only list templates valid for that specific subcommand") {
    guard allSubcommands.contains($0) else { throw ArgumentError.InvalidType(value: $0, type: "subcommand", argument: "--only") }
    return $0
  }
) { onlySubcommand in
  let customTemplates = try! appSupportTemplatesPath.children()
  let bundledTemplates = try! bundledTemplatesPath.children()
  
  let printTemplates = { (prefix: String, list: [Path]) in
    for file in list where file.lastComponent.hasPrefix("\(prefix)-") && file.`extension` == "stencil" {
      let basename = file.lastComponentWithoutExtension
      let idx = basename.startIndex.advancedBy(prefix.characters.count+1)
      let name = basename[idx..<basename.endIndex]
      print("   - \(name)")
    }
  }
  
  let subcommandsToList = onlySubcommand.isEmpty ? allSubcommands : [onlySubcommand]
  for prefix in subcommandsToList {
    print("\(prefix):")
    print("  custom:")
    printTemplates(prefix, customTemplates)
    print("  bundled:")
    printTemplates(prefix, bundledTemplates)
  }
  
  print("---")
  print("You can add custom templates in ~/Library/Application Support/SwiftGen/templates.")
  print("Simply name them 'subcmd-customname.stencil' where subcmd is one of the swiftgen subcommand,")
  print("namely " + allSubcommands.map({"\($0)-xxx.stencil"}).joinWithSeparator(", ") + ".")
}
