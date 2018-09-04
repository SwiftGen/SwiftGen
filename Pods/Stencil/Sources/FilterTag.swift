class FilterNode : NodeType {
  let resolvable: Resolvable
  let nodes: [NodeType]
  let token: Token?

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let bits = token.components()

    guard bits.count == 2 else {
      throw TemplateSyntaxError("'filter' tag takes one argument, the filter expression")
    }

    let blocks = try parser.parse(until(["endfilter"]))

    guard parser.nextToken() != nil else {
      throw TemplateSyntaxError("`endfilter` was not found.")
    }

    let resolvable = try parser.compileFilter("filter_value|\(bits[1])", containedIn: token)
    return FilterNode(nodes: blocks, resolvable: resolvable, token: token)
  }

  init(nodes: [NodeType], resolvable: Resolvable, token: Token) {
    self.nodes = nodes
    self.resolvable = resolvable
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    let value = try renderNodes(nodes, context)

    return try context.push(dictionary: ["filter_value": value]) {
      return try VariableNode(variable: resolvable, token: token).render(context)
    }
  }
}

