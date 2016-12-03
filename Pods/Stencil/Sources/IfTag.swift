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
  case variable(Variable)
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

  init(components: [String]) {
    self.tokens = components.map { component in
      if let op = findOperator(name: component) {
        switch op {
        case .infix(let name, let bindingPower, let cls):
          return .infix(name: name, bindingPower: bindingPower, op: cls)
        case .prefix(let name, let bindingPower, let cls):
          return .prefix(name: name, bindingPower: bindingPower, op: cls)
        }
      }

      return .variable(Variable(component))
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


func parseExpression(components: [String]) throws -> Expression {
  let parser = IfExpressionParser(components: components)
  return try parser.parse()
}


class IfNode : NodeType {
  let expression: Expression
  let trueNodes: [NodeType]
  let falseNodes: [NodeType]

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    var components = token.components()
    components.removeFirst()
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    trueNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      falseNodes = try parser.parse(until(["endif"]))
      _ = parser.nextToken()
    }

    let expression = try parseExpression(components: components)
    return IfNode(expression: expression, trueNodes: trueNodes, falseNodes: falseNodes)
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

    let expression = try parseExpression(components: components)
    return IfNode(expression: expression, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  init(expression: Expression, trueNodes: [NodeType], falseNodes: [NodeType]) {
    self.expression = expression
    self.trueNodes = trueNodes
    self.falseNodes = falseNodes
  }

  func render(_ context: Context) throws -> String {
    let truthy = try expression.evaluate(context: context)

    return try context.push {
      if truthy {
        return try renderNodes(trueNodes, context)
      } else {
        return try renderNodes(falseNodes, context)
      }
    }
  }
}
