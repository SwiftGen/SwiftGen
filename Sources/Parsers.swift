//
//  Parsers.swift
//  SwiftGen
//
//  Created by David Jennes on 08/06/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import Commander
import SwiftGenKit

let allParsers: [Parser.Type] = [
  AssetsCatalogParser.self,
  ColorsParser.self,
  FontsParser.self,
  StoryboardParser.self,
  StringsParser.self
]

let allParserCommands = allParsers.map({ ParserCommand(parserType: $0) })
