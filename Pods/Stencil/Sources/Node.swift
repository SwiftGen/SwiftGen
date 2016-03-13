import Foundation

public struct TemplateSyntaxError : ErrorType, Equatable, CustomStringConvertible {
  public let description:String

  public init(_ description:String) {
    self.description = description
  }
}

public func ==(lhs:TemplateSyntaxError, rhs:TemplateSyntaxError) -> Bool {
  return lhs.description == rhs.description
}

public protocol NodeType {
  /// Render the node in the given context
  func render(context:Context) throws -> String
}

/// Render the collection of nodes in the given context
public func renderNodes(nodes:[NodeType], _ context:Context) throws -> String {
  return try nodes.map { try $0.render(context) }.joinWithSeparator("")
}

public class SimpleNode : NodeType {
  let handler:Context throws -> String

  public init(handler:Context throws -> String) {
    self.handler = handler
  }

  public func render(context: Context) throws -> String {
    return try handler(context)
  }
}

public class TextNode : NodeType {
  public let text:String

  public init(text:String) {
    self.text = text
  }

  public func render(context:Context) throws -> String {
    return self.text
  }
}

public protocol Resolvable {
  func resolve(context: Context) throws -> Any?
}

public class VariableNode : NodeType {
  public let variable: Resolvable

  public init(variable: Resolvable) {
    self.variable = variable
  }

  public init(variable: String) {
    self.variable = Variable(variable)
  }

  public func render(context: Context) throws -> String {
    let result = try variable.resolve(context)

    if let result = result as? String {
      return result
    } else if let result = result as? CustomStringConvertible {
      return result.description
    } else if let result = result as? NSObject {
      return result.description
    }

    return ""
  }
}


#if !os(Linux)
public class NowNode : NodeType {
  public let format:Variable

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    var format:Variable?

    let components = token.components()
    guard components.count <= 2 else {
      throw TemplateSyntaxError("'now' tags may only have one argument: the format string `\(token.contents)`.")
    }
    if components.count == 2 {
      format = Variable(components[1])
    }

    return NowNode(format:format)
  }

  public init(format:Variable?) {
    self.format = format ?? Variable("\"yyyy-MM-dd 'at' HH:mm\"")
  }

  public func render(context: Context) throws -> String {
    let date = NSDate()
    let format = try self.format.resolve(context)
    var formatter:NSDateFormatter?

    if let format = format as? NSDateFormatter {
      formatter = format
    } else if let format = format as? String {
      formatter = NSDateFormatter()
      formatter!.dateFormat = format
    } else {
      return ""
    }

    return formatter!.stringFromDate(date)
  }
}
#endif


public class ForNode : NodeType {
  let variable:Variable
  let loopVariable:String
  let nodes:[NodeType]
  let emptyNodes: [NodeType]

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
      parser.nextToken()
    }

    return ForNode(variable: variable, loopVariable: loopVariable, nodes: forNodes, emptyNodes:emptyNodes)
  }

  public init(variable:String, loopVariable:String, nodes:[NodeType], emptyNodes:[NodeType]) {
    self.variable = Variable(variable)
    self.loopVariable = loopVariable
    self.nodes = nodes
    self.emptyNodes = emptyNodes
  }

  public func render(context: Context) throws -> String {
    let values = try variable.resolve(context)

    if let values = values as? [Any] where values.count > 0 {
      let count = values.count
      return try values.enumerate().map { index, item in
        let forContext: [String: Any] = [
          "first": index == 0,
          "last": index == (count - 1),
          "counter": index + 1,
        ]

        return try context.push([loopVariable: item, "forloop": forContext]) {
          try renderNodes(nodes, context)
        }
      }.joinWithSeparator("")
    }

    return try context.push {
      try renderNodes(emptyNodes, context)
    }
  }
}

public class IfNode : NodeType {
  public let variable:Variable
  public let trueNodes:[NodeType]
  public let falseNodes:[NodeType]

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 2 else {
      throw TemplateSyntaxError("'if' statements should use the following 'if condition' `\(token.contents)`.")
    }
    let variable = components[1]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    trueNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      falseNodes = try parser.parse(until(["endif"]))
      parser.nextToken()
    }

    return IfNode(variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public class func parse_ifnot(parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()
    guard components.count == 2 else {
      throw TemplateSyntaxError("'ifnot' statements should use the following 'if condition' `\(token.contents)`.")
    }
    let variable = components[1]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    falseNodes = try parser.parse(until(["endif", "else"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    if token.contents == "else" {
      trueNodes = try parser.parse(until(["endif"]))
      parser.nextToken()
    }

    return IfNode(variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public init(variable:String, trueNodes:[NodeType], falseNodes:[NodeType]) {
    self.variable = Variable(variable)
    self.trueNodes = trueNodes
    self.falseNodes = falseNodes
  }

  public func render(context: Context) throws -> String {
    let result = try variable.resolve(context)
    var truthy = false

    if let result = result as? [Any] {
      truthy = !result.isEmpty
    } else if let result = result as? [String:Any] {
      truthy = !result.isEmpty
    } else if result != nil {
      truthy = true
    }

    context.push()
    let output:String
    if truthy {
      output = try renderNodes(trueNodes, context)
    } else {
      output = try renderNodes(falseNodes, context)
    }
    context.pop()

    return output
  }
}
