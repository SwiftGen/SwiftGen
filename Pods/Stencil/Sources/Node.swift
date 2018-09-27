import Foundation

public protocol NodeType {
  /// Render the node in the given context
  func render(_ context:Context) throws -> String

  /// Reference to this node's token
  var token: Token? { get }
}


/// Render the collection of nodes in the given context
public func renderNodes(_ nodes:[NodeType], _ context:Context) throws -> String {
  return try nodes.map {
    do {
      return try $0.render(context)
    } catch {
      throw error.withToken($0.token)
    }
    }.joined(separator: "")
}

public class SimpleNode : NodeType {
  public let handler:(Context) throws -> String
  public let token: Token?

  public init(token: Token, handler: @escaping (Context) throws -> String) {
    self.token = token
    self.handler = handler
  }

  public func render(_ context: Context) throws -> String {
    return try handler(context)
  }
}


public class TextNode : NodeType {
  public let text:String
  public let token: Token?

  public init(text:String) {
    self.text = text
    self.token = nil
  }

  public func render(_ context:Context) throws -> String {
    return self.text
  }
}


public protocol Resolvable {
  func resolve(_ context: Context) throws -> Any?
}


public class VariableNode : NodeType {
  public let variable: Resolvable
  public var token: Token?
  let condition: Expression?
  let elseExpression: Resolvable?

  class func parse(_ parser:TokenParser, token:Token) throws -> NodeType {
    var components = token.components()

    func hasToken(_ token: String, at index: Int) -> Bool {
      return components.count > (index + 1) && components[index] == token
    }

    let condition: Expression?
    let elseExpression: Resolvable?

    if hasToken("if", at: 1) {
      let components = components.suffix(from: 2)
      if let elseIndex = components.index(of: "else") {
        condition = try parseExpression(components: Array(components.prefix(upTo: elseIndex)), tokenParser: parser, token: token)
        let elseToken = components.suffix(from: elseIndex.advanced(by: 1)).joined(separator: " ")
        elseExpression = try parser.compileResolvable(elseToken, containedIn: token)
      } else {
        condition = try parseExpression(components: Array(components), tokenParser: parser, token: token)
        elseExpression = nil
      }
    } else {
      condition = nil
      elseExpression = nil
    }

    let filter = try parser.compileResolvable(components[0], containedIn: token)
    return VariableNode(variable: filter, token: token, condition: condition, elseExpression: elseExpression)
  }

  public init(variable: Resolvable, token: Token? = nil) {
    self.variable = variable
    self.token = token
    self.condition = nil
    self.elseExpression = nil
  }

  init(variable: Resolvable, token: Token? = nil, condition: Expression?, elseExpression: Resolvable?) {
    self.variable = variable
    self.token = token
    self.condition = condition
    self.elseExpression = elseExpression
  }

  public init(variable: String, token: Token? = nil) {
    self.variable = Variable(variable)
    self.token = token
    self.condition = nil
    self.elseExpression = nil
  }

  public func render(_ context: Context) throws -> String {
    if let condition = self.condition, try condition.evaluate(context: context) == false {
      return try elseExpression?.resolve(context).map(stringify) ?? ""
    }

    let result = try variable.resolve(context)
    return stringify(result)
  }
}


func stringify(_ result: Any?) -> String {
  if let result = result as? String {
    return result
  } else if let array = result as? [Any?] {
    return unwrap(array).description
  } else if let result = result as? CustomStringConvertible {
    return result.description
  } else if let result = result as? NSObject {
    return result.description
  }

  return ""
}

func unwrap(_ array: [Any?]) -> [Any] {
  return array.map { (item: Any?) -> Any in
    if let item = item {
      if let items = item as? [Any?] {
        return unwrap(items)
      } else {
        return item
      }
    }
    else { return item as Any }
  }
}
