open class Namespace {
  public typealias TagParser = (TokenParser, Token) throws -> NodeType

  var tags = [String: TagParser]()
  var filters = [String: Filter]()

  public init() {
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
  }

  fileprivate func registerDefaultFilters() {
    registerFilter("capitalize", filter: capitalise)
    registerFilter("uppercase", filter: uppercase)
    registerFilter("lowercase", filter: lowercase)
  }

  /// Registers a new template tag
  open func registerTag(_ name: String, parser: @escaping TagParser) {
    tags[name] = parser
  }

  /// Registers a simple template tag with a name and a handler
  open func registerSimpleTag(_ name: String, handler: @escaping (Context) throws -> String) {
    registerTag(name, parser: { parser, token in
      return SimpleNode(handler: handler)
    })
  }

  /// Registers a template filter with the given name
  open func registerFilter(_ name: String, filter: @escaping Filter) {
    filters[name] = filter
  }
}
