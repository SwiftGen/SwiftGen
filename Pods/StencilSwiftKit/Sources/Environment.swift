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

    registerFilter("basename", filter: Filters.Strings.basename)
    registerFilter("camelToSnakeCase", filter: Filters.Strings.camelToSnakeCase)
    registerFilter("contains", filter: Filters.Strings.contains)
    registerFilter("dirname", filter: Filters.Strings.dirname)
    registerFilter("escapeReservedKeywords", filter: Filters.Strings.escapeReservedKeywords)
    registerFilter("hasPrefix", filter: Filters.Strings.hasPrefix)
    registerFilter("hasSuffix", filter: Filters.Strings.hasSuffix)
    registerFilter("lowerFirstLetter", filter: Filters.Strings.lowerFirstLetter)
    registerFilter("lowerFirstWord", filter: Filters.Strings.lowerFirstWord)
    registerFilter("removeNewlines", filter: Filters.Strings.removeNewlines)
    registerFilter("replace", filter: Filters.Strings.replace)
    registerFilter("snakeToCamelCase", filter: Filters.Strings.snakeToCamelCase)
    registerFilter("swiftIdentifier", filter: Filters.Strings.swiftIdentifier)
    registerFilter("titlecase", filter: Filters.Strings.upperFirstLetter)
    registerFilter("upperFirstLetter", filter: Filters.Strings.upperFirstLetter)

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
