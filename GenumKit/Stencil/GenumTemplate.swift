//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

// Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
open class GenumTemplate: Template {
  public override init(templateString: String) {
    let templateStringWithMarkedNewlines = templateString
        .replacingOccurrences(of: "\n\n", with: "\n\u{000b}\n")
        .replacingOccurrences(of: "\n\n", with: "\n\u{000b}\n")
    super.init(templateString: templateStringWithMarkedNewlines)
  }

  open override func render(_ context: Context? = nil) throws -> String {
    return try removeExtraLines(from: super.render(context))
  }

  // Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
  private func removeExtraLines(from str: String) -> String {
    let extraLinesRE: NSRegularExpression = {
      do {
        return try NSRegularExpression(pattern: "\\n([ \\t]*\\n)+", options: [])
      } catch {
        fatalError("Regular Expression pattern error: \(error)")
      }
    }()
    let compact = extraLinesRE.stringByReplacingMatches(
      in: str,
      options: [],
      range: NSRange(location: 0, length: str.utf16.count),
      withTemplate: "\n"
    )
    let unmarkedNewlines = compact
      .replacingOccurrences(of: "\n\u{000b}\n", with: "\n\n")
      .replacingOccurrences(of: "\n\u{000b}\n", with: "\n\n")
    return unmarkedNewlines
  }
}

// Register Genum-specific tags & filters
open class GenumNamespace: Namespace {
  public override init() {
    super.init()
    self.registerTag("set", parser: SetNode.parse)
    self.registerFilter("swiftIdentifier", filter: StringFilters.stringToSwiftIdentifier)
    self.registerFilter("join", filter: ArrayFilters.join)
    self.registerFilter("lowerFirstWord", filter: StringFilters.lowerFirstWord)
    self.registerFilter("snakeToCamelCase", filter: StringFilters.snakeToCamelCase)
    self.registerFilter("snakeToCamelCaseNoPrefix", filter: StringFilters.snakeToCamelCaseNoPrefix)
    self.registerFilter("titlecase", filter: StringFilters.titlecase)
    self.registerFilter("hexToInt", filter: NumFilters.hexToInt)
    self.registerFilter("int255toFloat", filter: NumFilters.int255toFloat)
    self.registerFilter("percent", filter: NumFilters.percent)
    self.registerFilter("escapeReservedKeywords", filter: StringFilters.escapeReservedKeywords)
  }
}
