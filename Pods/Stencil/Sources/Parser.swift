public func until(tags: [String]) -> ((TokenParser, Token) -> Bool) {
  return { parser, token in
    if let name = token.components().first {
      for tag in tags {
        if name == tag {
          return true
        }
      }
    }

    return false
  }
}

public typealias Filter = Any? throws -> Any?

/// A class for parsing an array of tokens and converts them into a collection of Node's
public class TokenParser {
  public typealias TagParser = (TokenParser, Token) throws -> NodeType

  private var tokens: [Token]
  private let namespace: Namespace

  public init(tokens: [Token], namespace: Namespace) {
    self.tokens = tokens
    self.namespace = namespace
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

        if let tag = tag {
          if let parser = namespace.tags[tag] {
            nodes.append(try parser(self, token))
          } else {
            throw TemplateSyntaxError("Unknown template tag '\(tag)'")
          }
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
    if let filter = namespace.filters[name] {
      return filter
    }

    throw TemplateSyntaxError("Invalid filter '\(name)'")
  }

  func compileFilter(token: String) throws -> Resolvable {
    return try FilterExpression(token: token, parser: self)
  }
}
