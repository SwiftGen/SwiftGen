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

  public init(variable: Resolvable, token: Token? = nil) {
    self.variable = variable
    self.token = token
  }

  public init(variable: String, token: Token? = nil) {
    self.variable = Variable(variable)
    self.token = token
  }

  public func render(_ context: Context) throws -> String {
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
