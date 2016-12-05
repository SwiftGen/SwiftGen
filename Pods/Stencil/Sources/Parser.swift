public func until(_ tags: [String]) -> ((TokenParser, Token) -> Bool) {
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


/// A class for parsing an array of tokens and converts them into a collection of Node's
public class TokenParser {
  public typealias TagParser = (TokenParser, Token) throws -> NodeType

  fileprivate var tokens: [Token]
  fileprivate let namespace: Namespace

  public init(tokens: [Token], namespace: Namespace) {
    self.tokens = tokens
    self.namespace = namespace
  }

  /// Parse the given tokens into nodes
  public func parse() throws -> [NodeType] {
    return try parse(nil)
  }

  public func parse(_ parse_until:((_ parser:TokenParser, _ token:Token) -> (Bool))?) throws -> [NodeType] {
    var nodes = [NodeType]()

    while tokens.count > 0 {
      let token = nextToken()!

      switch token {
      case .text(let text):
        nodes.append(TextNode(text: text))
      case .variable:
        nodes.append(VariableNode(variable: try compileFilter(token.contents)))
      case .block:
        let tag = token.components().first

        if let parse_until = parse_until , parse_until(self, token) {
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
      case .comment:
        continue
      }
    }

    return nodes
  }

  public func nextToken() -> Token? {
    if tokens.count > 0 {
      return tokens.remove(at: 0)
    }

    return nil
  }

  public func prependToken(_ token:Token) {
    tokens.insert(token, at: 0)
  }

  func findFilter(_ name: String) throws -> FilterType {
    if let filter = namespace.filters[name] {
      return filter
    }

    throw TemplateSyntaxError("Invalid filter '\(name)'")
  }

  public func compileFilter(_ token: String) throws -> Resolvable {
    return try FilterExpression(token: token, parser: self)
  }
}
