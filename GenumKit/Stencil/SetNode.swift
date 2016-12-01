//
// GenumKit
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Stencil

open class SetNode: NodeType {
  open let variableName: String
  open let nodes: [NodeType]

  open class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
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

  open func render(_ context: Context) throws -> String {
    let result = try renderNodes(nodes, context)
    context[variableName] = result
    return ""
  }

}
