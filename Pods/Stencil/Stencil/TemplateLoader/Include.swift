import Foundation
import PathKit


public class IncludeNode : NodeType {
  public let templateName:String

  public class func parse(parser:TokenParser, token:Token) throws -> NodeType {
    let bits = token.contents.componentsSeparatedByString("\"")

    guard bits.count == 3 else {
      throw TemplateSyntaxError("'include' tag takes one argument, the template file to be included")
    }

    return IncludeNode(templateName: bits[1])
  }

  public init(templateName:String) {
    self.templateName = templateName
  }

  public func render(context: Context) throws -> String {
    guard let loader = context["loader"] as? TemplateLoader else {
      throw TemplateSyntaxError("Template loader not in context")
    }

    guard let template = loader.loadTemplate(templateName) else {
      let paths:String = loader.paths.map { path in path.description }.joinWithSeparator(", ")
      throw TemplateSyntaxError("'\(templateName)' template not found in \(paths)")
    }
    
    return try template.render(context)
  }
}

