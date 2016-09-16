public class ForNode : NodeType {
  let variable:ExpressionType
  let loopVariable:String
  let nodes:[NodeType]
  let emptyNodes: [NodeType]

  enum ExpressionType {
    case variable(Variable)
    case filterExpression(FilterExpression)
  }

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
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

    return ForNode(variable: variable, loopVariable: loopVariable, nodes: forNodes, emptyNodes:emptyNodes, parser: parser)
  }

  public init(variable:String, loopVariable:String, nodes:[NodeType], emptyNodes:[NodeType], parser: TokenParser) {
    if variable.containsString("|") {
      if let filter = try? FilterExpression(token: variable, parser: parser) {
        self.variable = .filterExpression(filter)
      } else {
        // Hack to get around the try? for now
        self.variable = .variable(Variable(variable))
      }
    } else {
      self.variable = .variable(Variable(variable))
    }
    self.loopVariable = loopVariable
    self.nodes = nodes
    self.emptyNodes = emptyNodes
  }

  public func render(context: Context) throws -> String {
    let values: Any?
    switch variable {
    case .variable(let variable):
      values = try variable.resolve(context)
    case .filterExpression(let expression):
      values = try expression.resolve(context)
    }

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
        }.joinWithSeparator("")
    }

    return try context.push {
      try renderNodes(emptyNodes, context)
    }
  }
}
