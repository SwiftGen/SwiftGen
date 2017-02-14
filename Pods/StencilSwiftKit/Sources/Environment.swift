//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil

public extension Extension {
  public func registerStencilSwiftExtensions() {
    registerTag("set", parser: SetNode.parse)
    registerTag("macro", parser: MacroNode.parse)
    registerTag("call", parser: CallNode.parse)
    registerFilter("swiftIdentifier", filter: StringFilters.stringToSwiftIdentifier)
    registerFilter("join", filter: ArrayFilters.join)
    registerFilter("lowerFirstWord", filter: StringFilters.lowerFirstWord)
    registerFilter("snakeToCamelCase", filter: StringFilters.snakeToCamelCase)
    registerFilter("snakeToCamelCaseNoPrefix", filter: StringFilters.snakeToCamelCaseNoPrefix)
    registerFilter("titlecase", filter: StringFilters.titlecase)
    registerFilter("hexToInt", filter: NumFilters.hexToInt)
    registerFilter("int255toFloat", filter: NumFilters.int255toFloat)
    registerFilter("percent", filter: NumFilters.percent)
    registerFilter("escapeReservedKeywords", filter: StringFilters.escapeReservedKeywords)
  }
}

public func stencilSwiftEnvironment() -> Environment {
  let ext = Extension()
  ext.registerStencilSwiftExtensions()
	
  return Environment(extensions: [ext], templateClass: StencilSwiftTemplate.self)
}
