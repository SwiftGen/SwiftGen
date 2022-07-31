//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import SwiftGenKit

public struct ParserCLI {
  let parserType: Parser.Type
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

extension ParserCLI: Hashable {
  public static func == (lhs: ParserCLI, rhs: ParserCLI) -> Bool {
    lhs.name == rhs.name
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}

// MARK: - Helpers

public extension ParserCLI {
  static func command(named name: String) -> ParserCLI? {
    all.first { $0.name == name }
  }

  static let all = [
    AssetsCatalog.Parser.self.info,
    Colors.Parser.self.info,
    CoreData.Parser.self.info,
    Files.Parser.self.info,
    Fonts.Parser.self.info,
    InterfaceBuilder.Parser.self.info,
    JSON.Parser.self.info,
    Plist.Parser.self.info,
    Strings.Parser.self.info,
    Yaml.Parser.self.info,

    // Deprecated
    ParserCLI(
      parserType: InterfaceBuilder.Parser.self,
      name: "storyboards",
      templateFolder: "ib",
      description: "DEPRECATED, please use 'ib' instead.",
      pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard"
    )
  ]
}

// MARK: - Parser info

public protocol ParserWithInfo: Parser {
  static var info: ParserCLI { get }
}

extension AssetsCatalog.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: AssetsCatalog.Parser.self,
    name: "xcassets",
    description: "Generate code for items in your Assets Catalog(s).",
    pathDescription: "Asset Catalog file(s)."
  )
}

extension Colors.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Colors.Parser.self,
    name: "colors",
    description: "Generate code for color palettes.",
    pathDescription: "Colors.txt|.clr|.xml|.json file(s) to parse."
  )
}

extension CoreData.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: CoreData.Parser.self,
    name: "coredata",
    description: "Generate code for your Core Data models.",
    pathDescription: "Core Data models (.xcdatamodel or .xcdatamodeld) to parse."
  )
}

extension Files.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Files.Parser.self,
    name: "files",
    description: "Generate code for referencing specified files.",
    pathDescription: "Files and/or directories to recursively search."
  )
}

extension Fonts.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Fonts.Parser.self,
    name: "fonts",
    description: "Generate code for your fonts.",
    pathDescription: "Directory(ies) to parse."
  )
}

extension InterfaceBuilder.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: InterfaceBuilder.Parser.self,
    name: "ib",
    description: "Generate code for your storyboard scenes and segues.",
    pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard"
  )
}

extension JSON.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: JSON.Parser.self,
    name: "json",
    description: "generate code for custom json configuration files",
    pathDescription: "JSON files (or directories that contain them) to parse."
  )
}

extension Plist.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Plist.Parser.self,
    name: "plist",
    description: "Generate code for custom plist files.",
    pathDescription: "Plist files (or directories that contain them) to parse."
  )
}

extension Strings.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Strings.Parser.self,
    name: "strings",
    description: "Generate code for your Localizable.strings or Localizable.stringsdict file(s).",
    pathDescription: "Strings file(s) to parse."
  )
}

extension Yaml.Parser: ParserWithInfo {
  public static let info = ParserCLI(
    parserType: Yaml.Parser.self,
    name: "yaml",
    description: "Generate code for custom yaml configuration files.",
    pathDescription: "YAML files (or directories that contain them) to parse."
  )
}
