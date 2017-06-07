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
    registerTag("map", parser: MapNode.parse)

    registerFilter("camelToSnakeCase", filter: Filters.Strings.camelToSnakeCase)
    registerFilter("escapeReservedKeywords", filter: Filters.Strings.escapeReservedKeywords)
    registerFilter("lowerFirstWord", filter: Filters.Strings.lowerFirstWord)
    registerFilter("removeNewlines", filter: Filters.Strings.removeNewlines)
    registerFilter("snakeToCamelCase", filter: Filters.Strings.snakeToCamelCase)
    registerFilter("swiftIdentifier", filter: Filters.Strings.swiftIdentifier)
    registerFilter("titlecase", filter: Filters.Strings.titlecase)

    registerFilter("hexToInt", filter: Filters.Numbers.hexToInt)
    registerFilter("int255toFloat", filter: Filters.Numbers.int255toFloat)
    registerFilter("percent", filter: Filters.Numbers.percent)
  }
}

public func stencilSwiftEnvironment() -> Environment {
  let ext = Extension()
  ext.registerStencilSwiftExtensions()

  return Environment(extensions: [ext], templateClass: StencilSwiftTemplate.self)
}
