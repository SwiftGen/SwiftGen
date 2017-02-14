//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil

struct CallableBlock: NodeType {
  let parameters: [String]
  let nodes: [NodeType]

  func context(_ context: Context, arguments: [Variable]) throws -> [String: Any] {
    var result = [String: Any]()

    for (parameter, argument) in zip(parameters, arguments) {
      result[parameter] = try argument.resolve(context)
    }

    return result
  }

  func render(_ context: Context) throws -> String {
    throw TemplateSyntaxError("A callable block must be called using the 'call' tag.")
  }
}

class MacroNode: NodeType {
  let variableName: String
  let parameters: [String]
  let nodes: [NodeType]

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count >= 2 else {
      throw TemplateSyntaxError("'macro' tag takes at least one argument, the name of the variable to set.")
    }
    let variable = components[1]
    let parameters = Array(components.dropFirst(2))

    let setNodes = try parser.parse(until(["endmacro"]))
    guard parser.nextToken() != nil else {
      throw TemplateSyntaxError("`endmacro` was not found.")
    }

    return MacroNode(variableName: variable, parameters: parameters, nodes: setNodes)
  }

  init(variableName: String, parameters: [String], nodes: [NodeType]) {
    self.variableName = variableName
    self.parameters = parameters
    self.nodes = nodes
  }

  func render(_ context: Context) throws -> String {
    let result = CallableBlock(parameters: parameters, nodes: nodes)
    context[variableName] = result
    return ""
  }
}

class CallNode: NodeType {
  let variableName: String
  let arguments: [Variable]

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count >= 2 else {
      throw TemplateSyntaxError("'call' tag takes at least one argument, the name of the block to call.")
    }
    let variable = components[1]
    let arguments = Array(components.dropFirst(2)).map { Variable($0) }

    return CallNode(variableName: variable, arguments: arguments)
  }

  init(variableName: String, arguments: [Variable]) {
    self.variableName = variableName
    self.arguments = arguments
  }

  func render(_ context: Context) throws -> String {
    guard let block = context[variableName] as? CallableBlock else {
      throw TemplateSyntaxError("Call to undefined block '\(variableName)'.")
    }
    guard block.parameters.count == arguments.count else {
      throw TemplateSyntaxError("Block '\(variableName)' accepts \(block.parameters.count) parameters, " +
        "\(arguments.count) given.")
    }
    let blockContext = try block.context(context, arguments: arguments)

    return try context.push(dictionary: blockContext) {
      try renderNodes(block.nodes, context)
    }
  }
}
