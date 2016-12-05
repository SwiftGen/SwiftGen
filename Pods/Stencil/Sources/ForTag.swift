class ForNode : NodeType {
  let resolvable: Resolvable
  let loopVariable:String
  let nodes:[NodeType]
  let emptyNodes: [NodeType]

  class func parse(_ parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()

    guard components.count == 4 && components[2] == "in" else {
      throw TemplateSyntaxError("'for' statements should use the following 'for x in y' `\(token.contents)`.")
    }

    let loopVariable = components[1]
    let variable = components[3]

    var emptyNodes = [NodeType]()

    let forNodes = try parser.parse(until(["endfor", "empty"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endfor` was not found.")
    }

    if token.contents == "empty" {
      emptyNodes = try parser.parse(until(["endfor"]))
      _ = parser.nextToken()
    }

    let filter = try parser.compileFilter(variable)
    return ForNode(resolvable: filter, loopVariable: loopVariable, nodes: forNodes, emptyNodes:emptyNodes)
  }

  init(resolvable: Resolvable, loopVariable:String, nodes:[NodeType], emptyNodes:[NodeType]) {
    self.resolvable = resolvable
    self.loopVariable = loopVariable
    self.nodes = nodes
    self.emptyNodes = emptyNodes
  }

  func render(_ context: Context) throws -> String {
    let values = try resolvable.resolve(context)

    if let values = values as? [Any] , values.count > 0 {
      let count = values.count
      return try values.enumerated().map { index, item in
        let forContext: [String: Any] = [
          "first": index == 0,
          "last": index == (count - 1),
          "counter": index + 1,
        ]

        return try context.push(dictionary: [loopVariable: item, "forloop": forContext]) {
          try renderNodes(nodes, context)
        }
      }.joined(separator: "")
    }

    return try context.push {
      try renderNodes(emptyNodes, context)
    }
  }
}
