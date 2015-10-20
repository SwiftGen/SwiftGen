//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class GenumTemplate : Template {
  public override init(templateString: String) {
    let templateStringWithMarkedNewlines = templateString
      .stringByReplacingOccurrencesOfString("\n\n", withString: "\n\u{000b}\n")
      .stringByReplacingOccurrencesOfString("\n\n", withString: "\n\u{000b}\n")
    super.init(templateString: templateStringWithMarkedNewlines)
    parser.registerTag("identifier", parser: IdentifierNode.parse)
    parser.registerTag("set", parser: SetNode.parse)
    parser.registerTag("lowerFirstWord", parser: StringCaseNode.parse_lowerFirstWord)
  }
  
  // Workaround until Stencil fixes https://github.com/kylef/Stencil/issues/22
  public override func render(context:Context? = nil) throws -> String {
    return try removeExtraLines(super.render(context))
  }
  
  private func removeExtraLines(str: String) -> String {
    let extraLinesRE = try! NSRegularExpression(pattern: "\\n([ \\t]*\\n)+", options: [])
    let compact = extraLinesRE.stringByReplacingMatchesInString(str, options: [], range: NSRange(location: 0, length: str.utf16.count), withTemplate: "\n")
    let unmarkedNewlines = compact
      .stringByReplacingOccurrencesOfString("\n\u{000b}\n", withString: "\n\n")
      .stringByReplacingOccurrencesOfString("\n\u{000b}\n", withString: "\n\n")
    return unmarkedNewlines
  }
}
