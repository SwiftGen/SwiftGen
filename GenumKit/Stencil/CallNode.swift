//
// GenumKit
// Copyright (c) 2016 Olivier Halligon
// MIT Licence
//

import Stencil

struct CallableBlock {
  let parameters: [String]
  let nodes: [NodeType]

  func context(_ context: Context, arguments: [Variable]) throws -> [String: Any] {
    var result = [String: Any]()

    for (parameter, argument) in zip(parameters, arguments) {
      result[parameter] = try argument.resolve(context)
    }

    return result
  }
}

open class DefineNode: NodeType {
  open let variableName: String
  open let parameters: [String]
  open let nodes: [NodeType]

  open class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count >= 2 else {
      throw TemplateSyntaxError("'define' tag takes at least one argument, the name of the variable to set")
    }
    let variable = components[1]
    let parameters = Array(components.dropFirst(2))

    let setNodes = try parser.parse(until(["enddefine"]))
    guard parser.nextToken() != nil else {
      throw TemplateSyntaxError("`enddefine` was not found.")
    }

    return DefineNode(variableName: variable, parameters: parameters, nodes: setNodes)
  }

  public init(variableName: String, parameters: [String], nodes: [NodeType]) {
    self.variableName = variableName
    self.parameters = parameters
    self.nodes = nodes
  }

  open func render(_ context: Context) throws -> String {
    let result = CallableBlock(parameters: parameters, nodes: nodes)
    context[variableName] = result
    return ""
  }
}

open class CallNode: NodeType {
  open let variableName: String
  open let arguments: [Variable]

  open class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count >= 2 else {
      throw TemplateSyntaxError("'call' tag takes at least one argument, the name of the block to call")
    }
    let variable = components[1]
    let arguments = Array(components.dropFirst(2)).map { Variable($0) }

    return CallNode(variableName: variable, arguments: arguments)
  }

  public init(variableName: String, arguments: [Variable]) {
    self.variableName = variableName
    self.arguments = arguments
  }

  open func render(_ context: Context) throws -> String {
    guard let block = context[variableName] as? CallableBlock else {
      throw TemplateSyntaxError("Call to undefined block '\(variableName)'.")
    }
    guard block.parameters.count == arguments.count else {
      throw TemplateSyntaxError("Block '\(variableName)' accepts \(block.parameters.count) parameters, " +
        "\(arguments.count) given.")
    }
    let blockContext = try block.context(context, arguments: arguments)

    return try context.push(dictionary: ["args": blockContext]) {
      try renderNodes(block.nodes, context)
    }
  }
}
