public func until(tags:[String])(parser:TokenParser, token:Token) -> Bool {
  if let name = token.components().first {
    for tag in tags {
      if name == tag {
        return true
      }
    }
  }

  return false
}

public typealias Filter = Any? -> Any?

/// A class for parsing an array of tokens and converts them into a collection of Node's
public class TokenParser {
  public typealias TagParser = (TokenParser, Token) throws -> NodeType

  private var tokens:[Token]
  private var tags = [String:TagParser]()
  private var filters = [String: Filter]()

  public init(tokens:[Token]) {
    self.tokens = tokens
    registerTag("for", parser: ForNode.parse)
    registerTag("if", parser: IfNode.parse)
    registerTag("ifnot", parser: IfNode.parse_ifnot)
    registerTag("now", parser: NowNode.parse)
    registerTag("include", parser: IncludeNode.parse)
    registerTag("extends", parser: ExtendsNode.parse)
    registerTag("block", parser: BlockNode.parse)
    registerFilter("capitalize", filter: capitalise)
    registerFilter("uppercase", filter: uppercase)
    registerFilter("lowercase", filter: lowercase)
  }

  /// Registers a new template tag
  public func registerTag(name:String, parser:TagParser) {
    tags[name] = parser
  }

  /// Registers a simple template tag with a name and a handler
  public func registerSimpleTag(name:String, handler:(Context throws -> String)) {
    registerTag(name, parser: { parser, token in
      return SimpleNode(handler: handler)
    })
  }

  public func registerFilter(name: String, filter: Filter) {
    filters[name] = filter
  }

  /// Parse the given tokens into nodes
  public func parse() throws -> [NodeType] {
    return try parse(nil)
  }

  public func parse(parse_until:((parser:TokenParser, token:Token) -> (Bool))?) throws -> [NodeType] {
    var nodes = [NodeType]()

    while tokens.count > 0 {
      let token = nextToken()!

      switch token {
      case .Text(let text):
        nodes.append(TextNode(text: text))
      case .Variable:
        nodes.append(VariableNode(variable: try compileFilter(token.contents)))
      case .Block:
        let tag = token.components().first

        if let parse_until = parse_until where parse_until(parser: self, token: token) {
            prependToken(token)
            return nodes
        }

        if let tag = tag, let parser = self.tags[tag] {
          nodes.append(try parser(self, token))
        }
      case .Comment:
        continue
      }
    }

    return nodes
  }

  public func nextToken() -> Token? {
    if tokens.count > 0 {
      return tokens.removeAtIndex(0)
    }

    return nil
  }

  public func prependToken(token:Token) {
    tokens.insert(token, atIndex: 0)
  }

  public func findFilter(name: String) throws -> Filter {
    if let filter = filters[name] {
      return filter
    }

    throw TemplateSyntaxError("Invalid filter '\(name)'")
  }

  func compileFilter(token: String) throws -> Resolvable {
    return try FilterExpression(token: token, parser: self)
  }
}
