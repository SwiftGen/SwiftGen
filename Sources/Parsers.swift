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

let assetCatalogCommand = ParserCommand(
  parser: AssetsCatalogParser.self,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let colorsCommand = ParserCommand(
  parser: ColorsParser.self,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let fontsCommand = ParserCommand(
  parser: FontsParser.self,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let storyboardsCommand = ParserCommand(
  parser: StoryboardParser.self,
  deprecatedOption1: Option<String>("sceneEnumName", "", flag: "e",
                                    description: "The name of the enum to generate for Scenes (DEPRECATED)"),
  deprecatedOption2: Option<String>("segueEnumName", "", flag: "g",
                                    description: "The name of the enum to generate for Segues (DEPRECATED)"),
  deprecatedHandler: storyboardsDeprecatedHandler
)

let stringsCommand = ParserCommand(
  parser: StringsParser.self,
  deprecatedOption: deprecatedEnumOption,
  deprecatedHandler: commonDeprecatedHandler
)

let parsers = [
  assetCatalogCommand,
  colorsCommand,
  fontsCommand,
  storyboardsCommand,
  stringsCommand
]
