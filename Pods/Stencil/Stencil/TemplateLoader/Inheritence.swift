import Foundation

class BlockContext {
  class var contextKey:String { return "block_context" }

  var blocks:[String:BlockNode]

  init(blocks:[String:BlockNode]) {
    self.blocks = blocks
  }

  func pop(blockName:String) -> BlockNode? {
    return blocks.removeValueForKey(blockName)
  }
}

func any<Element>(elements:[Element], closure:(Element -> Bool)) -> Element? {
  for element in elements {
    if closure(element) {
      return element
    }
  }

  return nil
}

class ExtendsNode : NodeType {
  let templateName:String
  let blocks:[String:BlockNode]

  class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let bits = token.contents.componentsSeparatedByString("\"")

    if bits.count != 3 {
      throw TemplateSyntaxError("'extends' takes one argument, the template file to be extended")
    }

    let parsedNodes = try parser.parse()
    if (any(parsedNodes) { ($0 as? ExtendsNode) != nil }) != nil {
      throw TemplateSyntaxError("'extends' cannot appear more than once in the same template")
    }

    let blockNodes = parsedNodes.filter { node in node is BlockNode }

    let nodes = blockNodes.reduce([String:BlockNode](), combine: { (accumulator, node:NodeType) -> [String:BlockNode] in
      let node = (node as! BlockNode)
      var dict = accumulator
      dict[node.name] = node
      return dict
    })

    return ExtendsNode(templateName: bits[1], blocks: nodes)
  }

  init(templateName:String, blocks:[String:BlockNode]) {
    self.templateName = templateName
    self.blocks = blocks
  }

  func render(context: Context) throws -> String {
    if let loader =  context["loader"] as? TemplateLoader {
      if let template = loader.loadTemplate(templateName) {
        let blockContext = BlockContext(blocks: blocks)
        context.push([BlockContext.contextKey: blockContext])
        let result = try template.render(context)
        context.pop()
        return result
      }

      let paths:String = loader.paths.map { path in
        return path.description
        }.joinWithSeparator(", ")
      throw TemplateSyntaxError("'\(templateName)' template not found in \(paths)")
    }

    throw TemplateSyntaxError("Template loader not in context")
  }
}

class BlockNode : NodeType {
  let name:String
  let nodes:[NodeType]

  class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let bits = token.components()

    if bits.count != 2 {
      throw TemplateSyntaxError("'block' tag takes one argument, the template file to be included")
    }

    let blockName = bits[1]
    let nodes = try parser.parse(until(["endblock"]))
    return BlockNode(name:blockName, nodes:nodes)
  }

  init(name:String, nodes:[NodeType]) {
    self.name = name
    self.nodes = nodes
  }

  func render(context: Context) throws -> String {
    if let blockContext = context[BlockContext.contextKey] as? BlockContext, node = blockContext.pop(name) {
      return try node.render(context)
    }

    return try renderNodes(nodes, context)
  }
}
