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

public class VariableNode : NodeType {
  public let variable:Variable

  public init(variable:Variable) {
    self.variable = variable
  }

  public init(variable:String) {
    self.variable = Variable(variable)
  }

  public func render(context:Context) throws -> String {
    let result:AnyObject? = variable.resolve(context)

    if let result = result as? String {
      return result
    } else if let result = result as? NSObject {
      return result.description
    }

    return ""
  }
}

public class NowNode : NodeType {
  public let format:Variable

  public class func parse(parser:TokenParser, token:Token) -> NodeType {
    var format:Variable?

    let components = token.components()
    if components.count == 2 {
      format = Variable(components[1])
    }

    return NowNode(format:format)
  }

  public init(format:Variable?) {
    if let format = format {
      self.format = format
    } else {
      self.format = Variable("\"yyyy-MM-dd 'at' HH:mm\"")
    }
  }

  public func render(context: Context) throws -> String {
    let date = NSDate()
    let format: AnyObject? = self.format.resolve(context)
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

public class ForNode : NodeType {
  let variable:Variable
  let loopVariable:String
  let nodes:[NodeType]

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()

    if components.count == 4 && components[2] == "in" {
      let loopVariable = components[1]
      let variable = components[3]

      var emptyNodes = [NodeType]()

      let forNodes = try parser.parse(until(["endfor", "empty"]))

      if let token = parser.nextToken() {
        if token.contents == "empty" {
          emptyNodes = try parser.parse(until(["endfor"]))
          parser.nextToken()
        }
      } else {
        throw TemplateSyntaxError("`endfor` was not found.")
      }

      return ForNode(variable: variable, loopVariable: loopVariable, nodes: forNodes, emptyNodes:emptyNodes)
    }

    throw TemplateSyntaxError("'for' statements should use the following 'for x in y' `\(token.contents)`.")
  }

  public init(variable:String, loopVariable:String, nodes:[NodeType], emptyNodes:[NodeType]) {
    self.variable = Variable(variable)
    self.loopVariable = loopVariable
    self.nodes = nodes
  }

  public func render(context: Context) throws -> String {
    if let values = variable.resolve(context) as? [AnyObject] {
      return try values.map { item in
        context.push()
        context[loopVariable] = item
        let result = try renderNodes(nodes, context)
        context.pop()
        return result
      }.joinWithSeparator("")
    }

    return ""
  }
}

public class IfNode : NodeType {
  public let variable:Variable
  public let trueNodes:[NodeType]
  public let falseNodes:[NodeType]

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let variable = token.components()[1]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    trueNodes = try parser.parse(until(["endif", "else"]))

    if let token = parser.nextToken() {
      if token.contents == "else" {
        falseNodes = try parser.parse(until(["endif"]))
        parser.nextToken()
      }
    } else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    return IfNode(variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public class func parse_ifnot(parser:TokenParser, token:Token) throws -> NodeType {
    let variable = token.components()[1]
    var trueNodes = [NodeType]()
    var falseNodes = [NodeType]()

    falseNodes = try parser.parse(until(["endif", "else"]))

    if let token = parser.nextToken() {
      if token.contents == "else" {
        trueNodes = try parser.parse(until(["endif"]))
        parser.nextToken()
      }
    } else {
      throw TemplateSyntaxError("`endif` was not found.")
    }

    return IfNode(variable: variable, trueNodes: trueNodes, falseNodes: falseNodes)
  }

  public init(variable:String, trueNodes:[NodeType], falseNodes:[NodeType]) {
    self.variable = Variable(variable)
    self.trueNodes = trueNodes
    self.falseNodes = falseNodes
  }

  public func render(context: Context) throws -> String {
    let result: AnyObject? = variable.resolve(context)
    var truthy = false

    if let result = result as? [AnyObject] {
      if result.count > 0 {
        truthy = true
      }
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
