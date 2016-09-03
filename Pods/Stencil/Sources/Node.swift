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
