//
//  Parsers.swift
//  SwiftGen
//
//  Created by David Jennes on 08/06/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Commander
import SwiftGenKit

let deprecatedEnumOption = Option<String>(
  "enumName", "", flag: "e", description: "The name of the enum to generate (DEPRECATED)"
)
let commonDeprecatedHandler: (String) throws -> Void = { deprecated in
  guard deprecated.isEmpty else {
    throw TemplateError.deprecated(option: "enumName", replacement: "Please use '--param enumName=...' instead.")
  }
}
let storyboardsDeprecatedHandler: (String, String) throws -> Void = { deprecated1, deprecated2 in
  guard deprecated1.isEmpty else {
    throw TemplateError.deprecated(option: "sceneEnumName",
                                   replacement: "Please use '--param sceneEnumName=...' instead.")
  }
  guard deprecated2.isEmpty else {
    throw TemplateError.deprecated(option: "segueEnumName",
                                   replacement: "Please use '--param segueEnumName=...' instead.")
  }
}

let assetCatalogCommand = parserCommand(
  name: "images",
  parser: AssetsCatalogParser.self,
  pathDescription: "Asset Catalog file(s).",
  pathValidator: dirsExist,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let colorsCommand = parserCommand(
  name: "colors",
  parser: ColorsParser.self,
  pathDescription: "Colors.txt|.clr|.xml|.json file(s) to parse.",
  pathValidator: filesExist,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let fontsCommand = parserCommand(
  name: "fonts",
  parser: FontsParser.self,
  pathDescription: "Directory(ies) to parse.",
  pathValidator: dirsExist,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let storyboardsCommand = parserCommand(
  name: "storyboards",
  parser: StoryboardParser.self,
  pathDescription: "Directory to scan for .storyboard files. Can also be a path to a single .storyboard",
  deprecatedOption1: Option<String>("sceneEnumName", "", flag: "e",
                                    description: "The name of the enum to generate for Scenes (DEPRECATED)"),
  deprecatedOption2: Option<String>("segueEnumName", "", flag: "g",
                                    description: "The name of the enum to generate for Segues (DEPRECATED)"),
  deprecatedHandler: storyboardsDeprecatedHandler
)

let stringsCommand = parserCommand(
  name: "strings",
  parser: StringsParser.self,
  pathDescription: "Strings file(s) to parse.",
  pathValidator: filesExist,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)
