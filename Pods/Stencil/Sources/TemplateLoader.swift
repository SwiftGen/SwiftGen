import Foundation
import PathKit


// A class for loading a template from disk
public class TemplateLoader {
  public let paths: [Path]

  public init(paths: [Path]) {
    self.paths = paths
  }

  public init(bundle: [NSBundle]) {
    self.paths = bundle.map {
      return Path($0.bundlePath)
    }
  }

  public func loadTemplate(templateName: String) -> Template? {
    return loadTemplate([templateName])
  }

  public func loadTemplate(templateNames: [String]) -> Template? {
    for path in paths {
      for templateName in templateNames {
        let templatePath = path + Path(templateName)

        if templatePath.exists {
          if let template = try? Template(path: templatePath) {
            return template
          }
        }
      }
    }

    return nil
  }
}
