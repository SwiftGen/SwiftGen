//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

public class SetNode: NodeType {
  public let variableName: String
  public let nodes: [NodeType]

  public class func parse(parser: TokenParser, token: Token) throws -> NodeType {
    let comps = token.components()
    guard comps.count == 2 else {
      throw TemplateSyntaxError("'set' tag takes one argument, the name of the variable to set")
    }
    let variable = comps[1]

    let setNodes = try parser.parse(until(["endset"]))

    guard parser.nextToken() != nil else {
      throw TemplateSyntaxError("`endset` was not found.")
    }

    return SetNode(variableName: variable, nodes: setNodes)
  }

  public init(variableName: String, nodes: [NodeType]) {
    self.variableName = variableName
    self.nodes = nodes
  }

  public func render(context: Context) throws -> String {
    let result = try renderNodes(nodes, context)
    context[variableName] = result
    return ""
  }

}
