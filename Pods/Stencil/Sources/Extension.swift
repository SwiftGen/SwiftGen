open class Extension {
  typealias TagParser = (TokenParser, Token) throws -> NodeType
  var tags = [String: TagParser]()

  var filters = [String: Filter]()

  public init() {
  }

  /// Registers a new template tag
  public func registerTag(_ name: String, parser: @escaping (TokenParser, Token) throws -> NodeType) {
    tags[name] = parser
  }

  /// Registers a simple template tag with a name and a handler
  public func registerSimpleTag(_ name: String, handler: @escaping (Context) throws -> String) {
    registerTag(name, parser: { parser, token in
      return SimpleNode(handler: handler)
    })
  }

  /// Registers a template filter with the given name
  public func registerFilter(_ name: String, filter: @escaping (Any?) throws -> Any?) {
    filters[name] = .simple(filter)
  }

  /// Registers a template filter with the given name
  public func registerFilter(_ name: String, filter: @escaping (Any?, [Any?]) throws -> Any?) {
    filters[name] = .arguments(filter)
  }
}


class DefaultExtension: Extension {
  override init() {
    super.init()
    registerDefaultTags()
    registerDefaultFilters()
  }

  fileprivate func registerDefaultTags() {
    registerTag("for", parser: ForNode.parse)
    registerTag("if", parser: IfNode.parse)
    registerTag("ifnot", parser: IfNode.parse_ifnot)
#if !os(Linux)
    registerTag("now", parser: NowNode.parse)
#endif
    registerTag("include", parser: IncludeNode.parse)
    registerTag("extends", parser: ExtendsNode.parse)
    registerTag("block", parser: BlockNode.parse)
    registerTag("filter", parser: FilterNode.parse)
  }

  fileprivate func registerDefaultFilters() {
    registerFilter("default", filter: defaultFilter)
    registerFilter("capitalize", filter: capitalise)
    registerFilter("uppercase", filter: uppercase)
    registerFilter("lowercase", filter: lowercase)
    registerFilter("join", filter: joinFilter)
  }
}


protocol FilterType {
  func invoke(value: Any?, arguments: [Any?]) throws -> Any?
}

enum Filter: FilterType {
  case simple(((Any?) throws -> Any?))
  case arguments(((Any?, [Any?]) throws -> Any?))

  func invoke(value: Any?, arguments: [Any?]) throws -> Any? {
    switch self {
    case let .simple(filter):
      if !arguments.isEmpty {
        throw TemplateSyntaxError("cannot invoke filter with an argument")
      }

      return try filter(value)
    case let .arguments(filter):
      return try filter(value, arguments)
    }
  }
}
