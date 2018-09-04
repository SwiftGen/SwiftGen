import Foundation

class ForNode : NodeType {
  let resolvable: Resolvable
  let loopVariables: [String]
  let nodes:[NodeType]
  let emptyNodes: [NodeType]
  let `where`: Expression?
  let token: Token?

  class func parse(_ parser:TokenParser, token:Token) throws -> NodeType {
    let components = token.components()

    func hasToken(_ token: String, at index: Int) -> Bool {
      return components.count > (index + 1) && components[index] == token
    }

    func endsOrHasToken(_ token: String, at index: Int) -> Bool {
      return components.count == index || hasToken(token, at: index)
    }

    guard hasToken("in", at: 2) && endsOrHasToken("where", at: 4) else {
      throw TemplateSyntaxError("'for' statements should use the syntax: `for <x> in <y> [where <condition>]`.")
    }

    let loopVariables = components[1].characters
      .split(separator: ",")
      .map(String.init)
      .map { $0.trim(character: " ") }

    let resolvable = try parser.compileResolvable(components[3], containedIn: token)

    let `where` = hasToken("where", at: 4)
      ? try parseExpression(components: Array(components.suffix(from: 5)), tokenParser: parser, token: token)
      : nil

    let forNodes = try parser.parse(until(["endfor", "empty"]))

    guard let token = parser.nextToken() else {
      throw TemplateSyntaxError("`endfor` was not found.")
    }

    var emptyNodes = [NodeType]()
    if token.contents == "empty" {
      emptyNodes = try parser.parse(until(["endfor"]))
      _ = parser.nextToken()
    }

    return ForNode(resolvable: resolvable, loopVariables: loopVariables, nodes: forNodes, emptyNodes: emptyNodes, where: `where`, token: token)
  }

  init(resolvable: Resolvable, loopVariables: [String], nodes: [NodeType], emptyNodes: [NodeType], where: Expression? = nil, token: Token? = nil) {
    self.resolvable = resolvable
    self.loopVariables = loopVariables
    self.nodes = nodes
    self.emptyNodes = emptyNodes
    self.where = `where`
    self.token = token
  }

  func push<Result>(value: Any, context: Context, closure: () throws -> (Result)) throws -> Result {
    if loopVariables.isEmpty {
      return try context.push() {
        return try closure()
      }
    }

    let valueMirror = Mirror(reflecting: value)
    if case .tuple? = valueMirror.displayStyle {
      if loopVariables.count > Int(valueMirror.children.count) {
        throw TemplateSyntaxError("Tuple '\(value)' has less values than loop variables")
      }
      var variablesContext = [String: Any]()
      valueMirror.children.prefix(loopVariables.count).enumerated().forEach({ (offset, element) in
        if loopVariables[offset] != "_" {
          variablesContext[loopVariables[offset]] = element.value
        }
      })

      return try context.push(dictionary: variablesContext) {
        return try closure()
      }
    }

    return try context.push(dictionary: [loopVariables.first!: value]) {
      return try closure()
    }
  }

  func render(_ context: Context) throws -> String {
    let resolved = try resolvable.resolve(context)

    var values: [Any]

    if let dictionary = resolved as? [String: Any], !dictionary.isEmpty {
      values = dictionary.map { ($0.key, $0.value) }
    } else if let array = resolved as? [Any] {
      values = array
    } else if let range = resolved as? CountableClosedRange<Int> {
      values = Array(range)
    } else if let range = resolved as? CountableRange<Int> {
      values = Array(range)
    } else if let resolved = resolved {
      let mirror = Mirror(reflecting: resolved)
      switch mirror.displayStyle {
      case .struct?, .tuple?:
        values = Array(mirror.children)
      case .class?:
        var children = Array(mirror.children)
        var currentMirror: Mirror? = mirror
        while let superclassMirror = currentMirror?.superclassMirror {
          children.append(contentsOf: superclassMirror.children)
          currentMirror = superclassMirror
        }
        values = Array(children)
      default:
        values = []
      }
    } else {
      values = []
    }

    if let `where` = self.where {
      values = try values.filter({ item -> Bool in
        return try push(value: item, context: context) {
          try `where`.evaluate(context: context)
        }
      })
    }

    if !values.isEmpty {
      let count = values.count

      return try values.enumerated().map { index, item in
        let forContext: [String: Any] = [
          "first": index == 0,
          "last": index == (count - 1),
          "counter": index + 1,
          "counter0": index,
          "length": count
        ]

        return try context.push(dictionary: ["forloop": forContext]) {
          return try push(value: item, context: context) {
            try renderNodes(nodes, context)
          }
        }
        }.joined(separator: "")
    }

    return try context.push {
      try renderNodes(emptyNodes, context)
    }
  }
}
