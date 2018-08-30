class BlockContext {
  class var contextKey: String { return "block_context" }

  // contains mapping of block names to their nodes and templates where they are defined
  var blocks: [String: [BlockNode]]

  init(blocks: [String: BlockNode]) {
    self.blocks = [:]
    blocks.forEach { self.blocks[$0.key] = [$0.value] }
  }

  func push(_ block: BlockNode, forKey blockName: String) {
    if var blocks = blocks[blockName] {
      blocks.append(block)
      self.blocks[blockName] = blocks
    } else {
      self.blocks[blockName] = [block]
    }
  }

  func pop(_ blockName: String) -> BlockNode? {
    if var blocks = blocks[blockName] {
      let block = blocks.removeFirst()
      if blocks.isEmpty {
        self.blocks.removeValue(forKey: blockName)
      } else {
        self.blocks[blockName] = blocks
      }
      return block
    } else {
      return nil
    }
  }
}


extension Collection {
  func any(_ closure: (Iterator.Element) -> Bool) -> Iterator.Element? {
    for element in self {
      if closure(element) {
        return element
      }
    }

    return nil
  }
}


class ExtendsNode : NodeType {
  let templateName: Variable
  let blocks: [String:BlockNode]
  let token: Token?

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let bits = token.components()

    guard bits.count == 2 else {
      throw TemplateSyntaxError("'extends' takes one argument, the template file to be extended")
    }

    let parsedNodes = try parser.parse()
    guard (parsedNodes.any { $0 is ExtendsNode }) == nil else {
      throw TemplateSyntaxError("'extends' cannot appear more than once in the same template")
    }

    let blockNodes = parsedNodes.flatMap { $0 as? BlockNode }

    let nodes = blockNodes.reduce([String: BlockNode]()) { (accumulator, node) -> [String: BlockNode] in
      var dict = accumulator
      dict[node.name] = node
      return dict
    }

    return ExtendsNode(templateName: Variable(bits[1]), blocks: nodes, token: token)
  }

  init(templateName: Variable, blocks: [String: BlockNode], token: Token) {
    self.templateName = templateName
    self.blocks = blocks
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    guard let templateName = try self.templateName.resolve(context) as? String else {
      throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
    }

    let baseTemplate = try context.environment.loadTemplate(name: templateName)

    let blockContext: BlockContext
    if let currentBlockContext = context[BlockContext.contextKey] as? BlockContext {
      blockContext = currentBlockContext
      for (name, block) in blocks {
        blockContext.push(block, forKey: name)
      }
    } else {
      blockContext = BlockContext(blocks: blocks)
    }

    do {
      // pushes base template and renders it's content
      // block_context contains all blocks from child templates
      return try context.push(dictionary: [BlockContext.contextKey: blockContext]) {
        return try baseTemplate.render(context)
      }
    } catch {
      // if error template is already set (see catch in BlockNode)
      // and it happend in the same template as current template
      // there is no need to wrap it in another error
      if let error = error as? TemplateSyntaxError, error.templateName != token?.sourceMap.filename {
        throw TemplateSyntaxError(reason: error.reason, stackTrace: error.allTokens)
      } else {
        throw error
      }
    }
  }
}


class BlockNode : NodeType {
  let name: String
  let nodes: [NodeType]
  let token: Token?

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let bits = token.components()

    guard bits.count == 2 else {
      throw TemplateSyntaxError("'block' tag takes one argument, the block name")
    }

    let blockName = bits[1]
    let nodes = try parser.parse(until(["endblock"]))
    _ = parser.nextToken()
    return BlockNode(name:blockName, nodes:nodes, token: token)
  }

  init(name: String, nodes: [NodeType], token: Token) {
    self.name = name
    self.nodes = nodes
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    if let blockContext = context[BlockContext.contextKey] as? BlockContext, let child = blockContext.pop(name) {
      let childContext = try self.childContext(child, blockContext: blockContext, context: context)
      // render extension node
      do {
        return try context.push(dictionary: childContext) {
          return try child.render(context)
        }
      } catch {
        throw error.withToken(child.token)
      }
    }

    return try renderNodes(nodes, context)
  }

  // child node is a block node from child template that extends this node (has the same name)
  func childContext(_ child: BlockNode, blockContext: BlockContext, context: Context) throws -> [String: Any?] {
    var childContext: [String: Any?] = [BlockContext.contextKey: blockContext]

    if let blockSuperNode = child.nodes.first(where: {
      if case .variable(let variable, _)? = $0.token, variable == "block.super" { return true }
      else { return false}
    }) {
      do {
        // render base node so that its content can be used as part of child node that extends it
        childContext["block"] = ["super": try self.render(context)]
      } catch {
        if let error = error as? TemplateSyntaxError {
          throw TemplateSyntaxError(
            reason: error.reason,
            token: blockSuperNode.token,
            stackTrace: error.allTokens)
        } else {
          throw TemplateSyntaxError(
            reason: "\(error)",
            token: blockSuperNode.token,
            stackTrace: [])
        }
      }
    }
    return childContext
  }

}
