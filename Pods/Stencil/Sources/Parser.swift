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
  fileprivate let environment: Environment

  public init(tokens: [Token], environment: Environment) {
    self.tokens = tokens
    self.environment = environment
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
      case .text(let text, _):
        nodes.append(TextNode(text: text))
      case .variable:
        let filter = try compileResolvable(token.contents, containedIn: token)
        nodes.append(VariableNode(variable: filter, token: token))
      case .block:
        if let parse_until = parse_until , parse_until(self, token) {
          prependToken(token)
          return nodes
        }

        if let tag = token.components().first {
          do {
            let parser = try findTag(name: tag)
            let node = try parser(self, token)
            nodes.append(node)
          } catch {
            throw error.withToken(token)
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

  func findTag(name: String) throws -> Extension.TagParser {
    for ext in environment.extensions {
      if let filter = ext.tags[name] {
        return filter
      }
    }

    throw TemplateSyntaxError("Unknown template tag '\(name)'")
  }

  func findFilter(_ name: String) throws -> FilterType {
    for ext in environment.extensions {
      if let filter = ext.filters[name] {
        return filter
      }
    }

    let suggestedFilters = self.suggestedFilters(for: name)
    if suggestedFilters.isEmpty {
      throw TemplateSyntaxError("Unknown filter '\(name)'.")
    } else {
      throw TemplateSyntaxError("Unknown filter '\(name)'. Found similar filters: \(suggestedFilters.map({ "'\($0)'" }).joined(separator: ", ")).")
    }
  }

  private func suggestedFilters(for name: String) -> [String] {
    let allFilters = environment.extensions.flatMap({ $0.filters.keys })

    let filtersWithDistance = allFilters
                .map({ (filterName: $0, distance: $0.levenshteinDistance(name)) })
                // do not suggest filters which names are shorter than the distance
                .filter({ $0.filterName.characters.count > $0.distance })
    guard let minDistance = filtersWithDistance.min(by: { $0.distance < $1.distance })?.distance else {
      return []
    }
    // suggest all filters with the same distance
    return filtersWithDistance.filter({ $0.distance == minDistance }).map({ $0.filterName })
  }

  public func compileFilter(_ filterToken: String, containedIn containingToken: Token) throws -> Resolvable {
    do {
      return try FilterExpression(token: filterToken, parser: self)
    } catch {
      guard var syntaxError = error as? TemplateSyntaxError, syntaxError.token == nil else {
        throw error
      }
      // find offset of filter in the containing token so that only filter is highligted, not the whole token
      if let filterTokenRange = containingToken.contents.range(of: filterToken) {
        var rangeLine = containingToken.sourceMap.line
        rangeLine.offset += containingToken.contents.distance(from: containingToken.contents.startIndex, to: filterTokenRange.lowerBound)
        syntaxError.token = .variable(value: filterToken, at: SourceMap(filename: containingToken.sourceMap.filename, line: rangeLine))
      } else {
        syntaxError.token = containingToken
      }
      throw syntaxError
    }
  }

  @available(*, deprecated, message: "Use compileFilter(_:containedIn:)")
  public func compileFilter(_ token: String) throws -> Resolvable {
    return try FilterExpression(token: token, parser: self)
  }

  @available(*, deprecated, message: "Use compileResolvable(_:containedIn:)")
  public func compileResolvable(_ token: String) throws -> Resolvable {
    return try RangeVariable(token, parser: self)
      ?? compileFilter(token)
  }

  public func compileResolvable(_ token: String, containedIn containingToken: Token) throws -> Resolvable {
    return try RangeVariable(token, parser: self, containedIn: containingToken)
        ?? compileFilter(token, containedIn: containingToken)
  }

}

// https://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
extension String {

  subscript(_ i: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: i)]
  }

  func levenshteinDistance(_ target: String) -> Int {
    // create two work vectors of integer distances
    var last, current: [Int]

    // initialize v0 (the previous row of distances)
    // this row is A[0][i]: edit distance for an empty s
    // the distance is just the number of characters to delete from t
    last = [Int](0...target.characters.count)
    current = [Int](repeating: 0, count: target.characters.count + 1)

    for i in 0..<self.characters.count {
      // calculate v1 (current row distances) from the previous row v0

      // first element of v1 is A[i+1][0]
      //   edit distance is delete (i+1) chars from s to match empty t
      current[0] = i + 1

      // use formula to fill in the rest of the row
      for j in 0..<target.characters.count {
        current[j+1] = Swift.min(
          last[j+1] + 1,
          current[j] + 1,
          last[j] + (self[i] == target[j] ? 0 : 1)
        )
      }

      // copy v1 (current row) to v0 (previous row) for next iteration
      last = current
    }

    return current[target.characters.count]
  }

}
