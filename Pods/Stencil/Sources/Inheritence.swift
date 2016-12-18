class BlockContext {
  class var contextKey: String { return "block_context" }

  var blocks: [String: BlockNode]

  init(blocks: [String: BlockNode]) {
    self.blocks = blocks
  }

  func pop(_ blockName: String) -> BlockNode? {
    return blocks.removeValue(forKey: blockName)
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

    return ExtendsNode(templateName: Variable(bits[1]), blocks: nodes)
  }

  init(templateName: Variable, blocks: [String: BlockNode]) {
    self.templateName = templateName
    self.blocks = blocks
  }

  func render(_ context: Context) throws -> String {
    guard let templateName = try self.templateName.resolve(context) as? String else {
      throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
    }

    let template = try context.environment.loadTemplate(name: templateName)

    let blockContext: BlockContext
    if let context = context[BlockContext.contextKey] as? BlockContext {
      blockContext = context

      for (key, value) in blocks {
        if !blockContext.blocks.keys.contains(key) {
          blockContext.blocks[key] = value
        }
      }
    } else {
      blockContext = BlockContext(blocks: blocks)
    }

    return try context.push(dictionary: [BlockContext.contextKey: blockContext]) {
      return try template.render(context)
    }
  }
}


class BlockNode : NodeType {
  let name: String
  let nodes: [NodeType]

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let bits = token.components()

    guard bits.count == 2 else {
      throw TemplateSyntaxError("'block' tag takes one argument, the block name")
    }

    let blockName = bits[1]
    let nodes = try parser.parse(until(["endblock"]))
    _ = parser.nextToken()
    return BlockNode(name:blockName, nodes:nodes)
  }

  init(name: String, nodes: [NodeType]) {
    self.name = name
    self.nodes = nodes
  }

  func render(_ context: Context) throws -> String {
    if let blockContext = context[BlockContext.contextKey] as? BlockContext, let node = blockContext.pop(name) {
      return try context.push(dictionary: ["block": ["super": self]]) {
        return try node.render(context)
      }
    }

    return try renderNodes(nodes, context)
  }
}
