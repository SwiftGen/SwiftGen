import Foundation
import PathKit


public class IncludeNode : NodeType {
  public let templateName:String

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let bits = token.contents.componentsSeparatedByString("\"")

    if bits.count != 3 {
      throw TemplateSyntaxError("'include' tag takes one argument, the template file to be included")
    }

    return IncludeNode(templateName: bits[1])
  }

  public init(templateName:String) {
    self.templateName = templateName
  }

  public func render(context: Context) throws -> String {
    if let loader =  context["loader"] as? TemplateLoader {
      if let template = loader.loadTemplate(templateName) {
        return try template.render(context)
      }

      let paths:String = loader.paths.map { path in
        return path.description
      }.joinWithSeparator(", ")
      throw TemplateSyntaxError("'\(templateName)' template not found in \(paths)")
    }

    throw TemplateSyntaxError("Template loader not in context")
  }
}

