//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

// Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
public class CompactTemplate : Template {
  public override init(templateString: String) {
    let templateStringWithMarkedNewlines = templateString
      .stringByReplacingOccurrencesOfString("\n\n", withString: "\n\u{000b}\n")
      .stringByReplacingOccurrencesOfString("\n\n", withString: "\n\u{000b}\n")
    super.init(templateString: templateStringWithMarkedNewlines)
  }
  
  public override func render(context:Context? = nil) throws -> String {
    return try removeExtraLines(super.render(context))
  }
  
  // Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
  private func removeExtraLines(str: String) -> String {
    let extraLinesRE = try! NSRegularExpression(pattern: "\\n([ \\t]*\\n)+", options: [])
    let compact = extraLinesRE.stringByReplacingMatchesInString(str, options: [], range: NSRange(location: 0, length: str.utf16.count), withTemplate: "\n")
    let unmarkedNewlines = compact
      .stringByReplacingOccurrencesOfString("\n\u{000b}\n", withString: "\n\n")
      .stringByReplacingOccurrencesOfString("\n\u{000b}\n", withString: "\n\n")
    return unmarkedNewlines
  }
}

// Register Genum-specific tags & filters
public class GenumTemplate : CompactTemplate {
  public override init(templateString: String) {
    super.init(templateString: templateString)
    parser.registerTag("set", parser: SetNode.parse)
    parser.registerFilter("swiftIdentifier", filter: StringFilters.stringToSwiftIdentifier)
    parser.registerFilter("join", filter: ArrayFilters.join)
    parser.registerFilter("lowerFirstWord", filter: StringFilters.lowerFirstWord)
    parser.registerFilter("snakeToCamelCase", filter: StringFilters.snakeToCamelCase)
  }
}
