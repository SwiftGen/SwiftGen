//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class GenumTemplate : Template {
  public override init(templateString: String) {
    super.init(templateString: templateString)
    parser.registerTag("identifier", parser: IdentifierNode.parse)
    parser.registerTag("set", parser: SetNode.parse)
    parser.registerTag("lowerFirstWord", parser: StringCaseNode.parse_lowerFirstWord)
  }
}
