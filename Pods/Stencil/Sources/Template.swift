import Foundation
import PathKit

#if os(Linux)
let NSFileNoSuchFileError = 4
#endif

/// A class representing a template
open class Template: ExpressibleByStringLiteral {
  let tokens: [Token]

  /// Create a template with a template string
  public init(templateString: String) {
    let lexer = Lexer(templateString: templateString)
    tokens = lexer.tokenize()
  }

  /// Create a template with the given name inside the given bundle
  public convenience init(named:String, inBundle bundle:Bundle? = nil) throws {
    let useBundle = bundle ??  Bundle.main
    guard let url = useBundle.url(forResource: named, withExtension: nil) else {
      throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
    }

    try self.init(URL:url)
  }

  /// Create a template with a file found at the given URL
  public convenience init(URL:Foundation.URL) throws {
    try self.init(path: Path(URL.path))
  }

  /// Create a template with a file found at the given path
  public convenience init(path: Path) throws {
    self.init(templateString: try path.read())
  }

  // Create a template with a template string literal
  public convenience required init(stringLiteral value: String) {
    self.init(templateString: value)
  }

  // Create a template with a template string literal
  public convenience required init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(stringLiteral: value)
  }

  // Create a template with a template string literal
  public convenience required init(unicodeScalarLiteral value: StringLiteralType) {
    self.init(stringLiteral: value)
  }

  /// Render the given template
  open func render(_ context: Context? = nil) throws -> String {
    let context = context ?? Context()
    let parser = TokenParser(tokens: tokens, namespace: context.namespace)
    let nodes = try parser.parse()
    return try renderNodes(nodes, context)
  }
}
