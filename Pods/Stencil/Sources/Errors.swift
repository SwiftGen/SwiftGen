public class TemplateDoesNotExist: Error, CustomStringConvertible {
  let templateNames: [String]
  let loader: Loader?

  public init(templateNames: [String], loader: Loader? = nil) {
    self.templateNames = templateNames
    self.loader = loader
  }

  public var description: String {
    let templates = templateNames.joined(separator: ", ")

    if let loader = loader {
      return "Template named `\(templates)` does not exist in loader \(loader)"
    }

    return "Template named `\(templates)` does not exist. No loaders found"
  }
}
