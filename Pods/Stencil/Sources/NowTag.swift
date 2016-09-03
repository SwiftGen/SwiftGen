#if !os(Linux)
import Foundation


public class NowNode : NodeType {
  public let format:Variable

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    var format:Variable?

    let components = token.components()
    guard components.count <= 2 else {
      throw TemplateSyntaxError("'now' tags may only have one argument: the format string `\(token.contents)`.")
    }
    if components.count == 2 {
      format = Variable(components[1])
    }

    return NowNode(format:format)
  }

  public init(format:Variable?) {
    self.format = format ?? Variable("\"yyyy-MM-dd 'at' HH:mm\"")
  }

  public func render(context: Context) throws -> String {
    let date = NSDate()
    let format = try self.format.resolve(context)
    var formatter:NSDateFormatter?

    if let format = format as? NSDateFormatter {
      formatter = format
    } else if let format = format as? String {
      formatter = NSDateFormatter()
      formatter!.dateFormat = format
    } else {
      return ""
    }

    return formatter!.stringFromDate(date)
  }
}
#endif
