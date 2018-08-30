public struct Environment {
  public let templateClass: Template.Type
  public var extensions: [Extension]

  public var loader: Loader?

  public init(loader: Loader? = nil,
              extensions: [Extension]? = nil,
              templateClass: Template.Type = Template.self) {

    self.templateClass = templateClass
    self.loader = loader
    self.extensions = (extensions ?? []) + [DefaultExtension()]
  }

  public func loadTemplate(name: String) throws -> Template {
    if let loader = loader {
      return try loader.loadTemplate(name: name, environment: self)
    } else {
      throw TemplateDoesNotExist(templateNames: [name], loader: nil)
    }
  }

  public func loadTemplate(names: [String]) throws -> Template {
    if let loader = loader {
      return try loader.loadTemplate(names: names, environment: self)
    } else {
      throw TemplateDoesNotExist(templateNames: names, loader: nil)
    }
  }

  public func renderTemplate(name: String, context: [String: Any]? = nil) throws -> String {
    let template = try loadTemplate(name: name)
    return try render(template: template, context: context)
  }

  public func renderTemplate(string: String, context: [String: Any]? = nil) throws -> String {
    let template = templateClass.init(templateString: string, environment: self)
    return try render(template: template, context: context)
  }

  func render(template: Template, context: [String: Any]?) throws -> String {
    // update template environment as it can be created from string literal with default environment
    template.environment = self
    return try template.render(context)
  }

}
