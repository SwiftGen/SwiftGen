#if !os(Linux)
import Foundation


open class NowNode : NodeType {
  open let format:Variable

  open class func parse(_ parser:TokenParser, token:Token) throws -> NodeType {
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

  open func render(_ context: Context) throws -> String {
    let date = Date()
    let format = try self.format.resolve(context)
    var formatter:DateFormatter?

    if let format = format as? DateFormatter {
      formatter = format
    } else if let format = format as? String {
      formatter = DateFormatter()
      formatter!.dateFormat = format
    } else {
      return ""
    }

    return formatter!.string(from: date)
  }
}
#endif
