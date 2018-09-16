//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil

class SetNode: NodeType {
  enum Content {
    case nodes([NodeType])
    case reference(resolvable: Resolvable)
  }

  let variableName: String
  let content: Content
  let token: Token?

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count <= 3 else {
      throw TemplateSyntaxError("""
        'set' tag takes at least one argument (the name of the variable to set) \
        and optionally the value expression.
        """)
    }

    let variable = components[1]
    if components.count == 3 {
      // we have a value expression, no nodes
      let resolvable = try parser.compileResolvable(components[2], containedIn: token)
      return SetNode(variableName: variable, content: .reference(resolvable: resolvable))
    } else {
      // no value expression, parse until an `endset` node
      let setNodes = try parser.parse(until(["endset"]))

      guard parser.nextToken() != nil else {
        throw TemplateSyntaxError("`endset` was not found.")
      }

      return SetNode(variableName: variable, content: .nodes(setNodes), token: token)
    }
  }

  init(variableName: String, content: Content, token: Token? = nil) {
    self.variableName = variableName
    self.content = content
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    switch content {
    case .nodes(let nodes):
      let result = try renderNodes(nodes, context)
      context[variableName] = result
    case .reference(let value):
      context[variableName] = try value.resolve(context)
    }

    return ""
  }
}
