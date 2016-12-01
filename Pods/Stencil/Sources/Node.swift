import Foundation


public struct TemplateSyntaxError : Error, Equatable, CustomStringConvertible {
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
  func render(_ context:Context) throws -> String
}


/// Render the collection of nodes in the given context
public func renderNodes(_ nodes:[NodeType], _ context:Context) throws -> String {
  return try nodes.map { try $0.render(context) }.joined(separator: "")
}

open class SimpleNode : NodeType {
  let handler:(Context) throws -> String

  public init(handler:@escaping (Context) throws -> String) {
    self.handler = handler
  }

  open func render(_ context: Context) throws -> String {
    return try handler(context)
  }
}


open class TextNode : NodeType {
  open let text:String

  public init(text:String) {
    self.text = text
  }

  open func render(_ context:Context) throws -> String {
    return self.text
  }
}


public protocol Resolvable {
  func resolve(_ context: Context) throws -> Any?
}


open class VariableNode : NodeType {
  open let variable: Resolvable

  public init(variable: Resolvable) {
    self.variable = variable
  }

  public init(variable: String) {
    self.variable = Variable(variable)
  }

  open func render(_ context: Context) throws -> String {
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
