//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import SwiftGenKit

/// Describes the Command-Line Interface for each parser subcommands
public struct ParserCLI {
  public let parserType: Parser.Type
  public let name: String
  public let templateFolder: String
  public let description: String
  public let pathDescription: String
}

extension ParserCLI {
  init(parserType: Parser.Type, name: String, description: String, pathDescription: String) {
    self.init(
      parserType: parserType,
      name: name,
      templateFolder: name,
      description: description,
      pathDescription: pathDescription
    )
  }
}

// MARK: - All Parser Commands

let allParserCommands: [ParserCLI] = [
  .init(
    parserType: Colors.Parser.self,
    name: "colors",
    description: "generate code for color palettes",
    pathDescription: "Colors.txt|.clr|.xml|.json file(s) to parse."
  ),
  .init(
    parserType: CoreData.Parser.self,
    name: "coredata",
    description: "generate code for your Core Data models",
    pathDescription: "Core Data models (.xcdatamodel or .xcdatamodeld) to parse."
  ),
  .init(
    parserType: Fonts.Parser.self,
    name: "fonts",
    description: "generate code for your fonts",
    pathDescription: "Directory(ies) to parse."
  ),
  .init(
    parserType: InterfaceBuilder.Parser.self,
    name: "ib",
    description: "generate code for your storyboard scenes and segues",
    pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard"
  ),
  .init(
    parserType: JSON.Parser.self,
    name: "json",
    description: "generate code for custom json configuration files",
    pathDescription: "JSON files (or directories that contain them) to parse."
  ),
  .init(
    parserType: Plist.Parser.self,
    name: "plist",
    description: "generate code for custom plist flies",
    pathDescription: "Plist files (or directories that contain them) to parse."
  ),
  .init(
    parserType: Strings.Parser.self,
    name: "strings",
    description: "generate code for your Localizable.strings file(s)",
    pathDescription: "Strings file(s) to parse."
  ),
  .init(
    parserType: AssetsCatalog.Parser.self,
    name: "xcassets",
    description: "generate code for items in your Assets Catalog(s)",
    pathDescription: "Asset Catalog file(s)."
  ),
  .init(
    parserType: Yaml.Parser.self,
    name: "yaml",
    description: "generate code for custom yaml configuration files",
    pathDescription: "YAML files (or directories that contain them) to parse."
  ),

  // Deprecated
  .init(
    parserType: InterfaceBuilder.Parser.self,
    name: "storyboards",
    templateFolder: "ib",
    description: "DEPRECATED, please use 'ib' instead",
    pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard"
  )
]
