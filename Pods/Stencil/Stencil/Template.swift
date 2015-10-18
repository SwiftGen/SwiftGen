import Foundation
import PathKit

/// A class representing a template
public class Template {
  public let parser:TokenParser

  /// Create a template with the given name inside the main bundle
  public convenience init(named:String) throws {
    try self.init(named:named, inBundle:nil)
  }

  /// Create a template with the given name inside the given bundle
  public convenience init(named:String, inBundle bundle:NSBundle?) throws {
    let url:NSURL

    if let bundle = bundle {
      url = bundle.URLForResource(named, withExtension: nil)!
    } else {
      url = NSBundle.mainBundle().URLForResource(named, withExtension: nil)!
    }

    try self.init(URL:url)
  }

  /// Create a template with a file found at the given URL
  public convenience init(URL:NSURL) throws {
    try self.init(path: Path(URL.absoluteString))
  }

  /// Create a template with a file found at the given path
  public convenience init(path:Path) throws {
    self.init(templateString: try path.read())
  }

  /// Create a template with a template string
  public init(templateString:String) {
    let lexer = Lexer(templateString: templateString)
    let tokens = lexer.tokenize()
    parser = TokenParser(tokens: tokens)
  }

  /// Render the given template
  public func render(context:Context? = nil) throws -> String {
    let nodes = try parser.parse()
    return try renderNodes(nodes, context ?? Context())
  }
}
