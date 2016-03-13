public class Namespace {
  public typealias TagParser = (TokenParser, Token) throws -> NodeType

  var tags = [String: TagParser]()
  var filters = [String: Filter]()

  public init() {
    registerDefaultTags()
    registerDefaultFilters()
  }

  private func registerDefaultTags() {
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

  private func registerDefaultFilters() {
    registerFilter("capitalize", filter: capitalise)
    registerFilter("uppercase", filter: uppercase)
    registerFilter("lowercase", filter: lowercase)
  }

  /// Registers a new template tag
  public func registerTag(name: String, parser: TagParser) {
    tags[name] = parser
  }

  /// Registers a simple template tag with a name and a handler
  public func registerSimpleTag(name: String, handler: Context throws -> String) {
    registerTag(name, parser: { parser, token in
      return SimpleNode(handler: handler)
    })
  }

  /// Registers a template filter with the given name
  public func registerFilter(name: String, filter: Filter) {
    filters[name] = filter
  }
}
