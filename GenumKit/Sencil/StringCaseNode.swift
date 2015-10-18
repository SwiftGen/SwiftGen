//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class StringCaseNode : NodeType {
  public let variable: Variable
  
  public class func parse_lowerFirstWord(parser: TokenParser, token: Token) throws -> NodeType {
    let comps = token.components()
    guard comps.count == 2 else {
      throw TemplateSyntaxError("'lowerFirstWord' tag takes one argument, the variable for which to change the case")
    }
    return StringCaseNode(variable: comps[1])
  }
  
  public init(variable: String) {
    self.variable = Variable(variable)
  }
  
  public func render(context: Context) throws -> String {
    guard let value = variable.resolve(context) else {
      throw TemplateSyntaxError("Variable \(variable) not found in context")
    }
    guard let string = value as? String else {
      throw TemplateSyntaxError("Variable \(variable) is not a string")
    }
    
    let cs = NSCharacterSet.uppercaseLetterCharacterSet()
    let scalars = string.unicodeScalars
    let start = scalars.startIndex
    var idx = start
    while cs.longCharacterIsMember(scalars[idx].value) && idx < scalars.endIndex {
      idx = idx.successor()
    }
    if idx != start.successor() {
      idx = idx.predecessor()
    }
    let transformed = String(scalars[start..<idx]).lowercaseString + String(scalars[idx..<scalars.endIndex])
    return transformed
  }
}
