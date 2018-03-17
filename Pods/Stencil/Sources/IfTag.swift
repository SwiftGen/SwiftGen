enum Operator {
  case infix(String, Int, InfixOperator.Type)
  case prefix(String, Int, PrefixOperator.Type)

  var name: String {
    switch self {
    case .infix(let name, _, _):
      return name
    case .prefix(let name, _, _):
      return name
    }
  }
}


let operators: [Operator] = [
  .infix("in", 5, InExpression.self),
  .infix("or", 6, OrExpression.self),
  .infix("and", 7, AndExpression.self),
  .prefix("not", 8, NotExpression.self),
  .infix("==", 10, EqualityExpression.self),
  .infix("!=", 10, InequalityExpression.self),
  .infix(">", 10, MoreThanExpression.self),
  .infix(">=", 10, MoreThanEqualExpression.self),
  .infix("<", 10, LessThanExpression.self),
  .infix("<=", 10, LessThanEqualExpression.self),
]


func findOperator(name: String) -> Operator? {
  for op in operators {
    if op.name == name {
      return op
    }
  }

  return nil
}


enum IfToken {
  case infix(name: String, bindingPower: Int, op: InfixOperator.Type)
  case prefix(name: String, bindingPower: Int, op: PrefixOperator.Type)
  case variable(Resolvable)
  case end

  var bindingPower: Int {
    switch self {
    case .infix(_, let bindingPower, _):
      return bindingPower
    case .prefix(_, let bindingPower, _):
      return bindingPower
    case .variable(_):
      return 0
    case .end:
        return 0
    }
  }

  func nullDenotation(parser: IfExpressionParser) throws -> Expression {
    switch self {
    case .infix(let name, _, _):
      throw TemplateSyntaxError("'if' expression error: infix operator '\(name)' doesn't have a left hand side")
    case .prefix(_, let bindingPower, let op):
      let expression = try parser.expression(bindingPower: bindingPower)
      return op.init(expression: expression)
    case .variable(let variable):
      return VariableExpression(variable: variable)
    case .end:
      throw TemplateSyntaxError("'if' expression error: end")
    }
  }

  func leftDenotation(left: Expression, parser: IfExpressionParser) throws -> Expression {
    switch self {
    case .infix(_, let bindingPower, let op):
      let right = try parser.expression(bindingPower: bindingPower)
      return op.init(lhs: left, rhs: right)
    case .prefix(let name, _, _):
      throw TemplateSyntaxError("'if' expression error: prefix operator '\(name)' was called with a left hand side")
    case .variable(let variable):
      throw TemplateSyntaxError("'if' expression error: variable '\(variable)' was called with a left hand side")
    case .end:
      throw TemplateSyntaxError("'if' expression error: end")
    }
  }

  var isEnd: Bool {
    switch self {
    case .end:
      return true
    default:
      return false
    }
  }
}


final class IfExpressionParser {
  let tokens: [IfToken]
  var position: Int = 0

  init(components: [String], tokenParser: TokenParser) throws {
    self.tokens = try components.map { component in
      if let op = findOperator(name: component) {
        switch op {
        case .infix(let name, let bindingPower, let cls):
          return .infix(name: name, bindingPower: bindingPower, op: cls)
        case .prefix(let name, let bindingPower, let cls):
          return .prefix(name: name, bindingPower: bindingPower, op: cls)
        }
      }

      return .variable(try tokenParser.compileFilter(component))
    }
  }

  var currentToken: IfToken {
    if tokens.count > position {
      return tokens[position]
    }

    return .end
  }

  var nextToken: IfToken {
    position += 1
    return currentToken
  }

  func parse() throws -> Expression {
    let expression = try self.expression()

    if !currentToken.isEnd {
      throw TemplateSyntaxError("'if' expression error: dangling token")
    }

    return expression
  }

  func expression(bindingPower: Int = 0) throws -> Expression {
    var token = currentToken
    position += 1

    var left = try token.nullDenotation(parser: self)

    while bindingPower < currentToken.bindingPower {
      token = currentToken
      position += 1
      left = try token.leftDenotation(left: left, parser: self)
    }

    return left
  }
}


func parseExpression(components: [String], tokenParser: TokenParser) throws -> Expression {
  let parser = try IfExpressionParser(components: components, tokenParser: tokenParser)
  return try parser.parse()
}


/// Represents an if condition and the associated nodes when the condition
/// evaluates
final class IfCondition {
  let expression: Expression?
  let nodes: [NodeType]

  init(expression: Expression?, nodes: [NodeType]) {
    self.expression = expression
    self.nodes = nodes
  }

  func render(_ context: Context) throws -> String {
    return try context.push {
      return try renderNodes(nodes, context)
    }
  }
}


class IfNode : NodeType {
  let conditions: [IfCondition]

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    var components = token.components()
    components.removeFirst()

    let expression = try parseExpression(components: components, tokenParser: parser)
    let nodes = try parser.parse(until(["endif", "elif", "else"]))
    var conditions: [IfCondition] = [
      IfCondition(expression: expression, nodes: nodes)
    ]

    var token = parser.nextToken()
    while let current = token, current.contents.hasPrefix("elif") {
      var components = current.components()
      components.removeFirst()
      let expression = try parseExpression(components: components, tokenParser: parser)

      let nodes = try parser.parse(until(["endif", "elif", "else"]))
      token = parser.nextToken()
      conditions.append(IfCondition(expression: expression, nodes: nodes))
    }

    if let current = token, current.contents == "else" {
      conditions.append(IfCondition(expression: nil, nodes: try parser.parse(until(["endif"]))))
      token = parser.nextToken()
    }

    guard let current = token, current.contents == "endif" else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    return IfNode(conditions: conditions)
  }

  class func parse_ifnot(_ parser: TokenParser, token: Token) throws -> NodeType {
    var components = token.components()
    guard components.count == 2 else {
      throw TemplateSyntaxError("'ifnot' statements should use the following 'ifnot condition' `\(token.contents)`.")
    }
    components.removeFirst()
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    falseNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      trueNodes = try parser.parse(until(["endif"]))
      _ = parser.nextToken()
    }

    let expression = try parseExpression(components: components, tokenParser: parser)
    return IfNode(conditions: [
      IfCondition(expression: expression, nodes: trueNodes),
      IfCondition(expression: nil, nodes: falseNodes),
    ])
  }

  init(conditions: [IfCondition]) {
    self.conditions = conditions
  }

  func render(_ context: Context) throws -> String {
    for condition in conditions {
      if let expression = condition.expression {
        let truthy = try expression.evaluate(context: context)

        if truthy {
          return try condition.render(context)
        }
      } else {
        return try condition.render(context)
      }
    }

    return ""
  }
}
