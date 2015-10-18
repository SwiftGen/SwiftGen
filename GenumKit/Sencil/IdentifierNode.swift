//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class IdentifierNode : NodeType {
  public let variable: Variable
  public let excludeChars: String
  public let replaceWithUnderscores: Bool
  
  public class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let comps = token.components()
    let (EXCLUDE, UNDERSCORE) = ("exclude", "_")
    
    let variable: String
    let excludes: String
    let underscores: Bool
    
    switch comps.count {
    case 2:
      // "identifier var"
      variable = comps[1]
      excludes = ""
      underscores = false
    case 3 where comps[3] == UNDERSCORE:
      // "identifier var _"
      variable = comps[1]
      excludes = ""
      underscores = true
    case 4 where comps[2] == EXCLUDE:
      // "identifier var exclude str"
      variable = comps[1]
      excludes = comps[3]
      underscores = false
    case 5 where comps[2] == EXCLUDE && comps[4] == UNDERSCORE:
      // "identifier var exclude str _"
      variable = comps[1]
      excludes = comps[3]
      underscores = true
    default:
      throw TemplateSyntaxError("'identifier' statements should use the following 'identifier var [exclude chars] [_]' `\(token.contents)`.")
    }
    
    return IdentifierNode(variable: variable, excludeChars: excludes, useUnderscores: underscores)
  }
  
  public init(variable: String, excludeChars: String, useUnderscores: Bool) {
    self.variable = Variable(variable)
    self.excludeChars = excludeChars
    self.replaceWithUnderscores = useUnderscores
  }
  
  public func render(context: Context) throws -> String {
    guard let value = variable.resolve(context) else {
      throw TemplateSyntaxError("Variable \(variable) not found in context")
    }
    guard let string = value as? String else {
      throw TemplateSyntaxError("Variable \(variable) is not a string")
    }
    
    return string.asSwiftIdentifier(forbiddenChars: excludeChars, replaceWithUnderscores: replaceWithUnderscores)
  }
}

