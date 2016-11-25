import Foundation
import PathKit


// A class for loading a template from disk
open class TemplateLoader {
  open let paths: [Path]

  public init(paths: [Path]) {
    self.paths = paths
  }

  public init(bundle: [Bundle]) {
    self.paths = bundle.map {
      return Path($0.bundlePath)
    }
  }

  open func loadTemplate(_ templateName: String) -> Template? {
    return loadTemplate([templateName])
  }

  open func loadTemplate(_ templateNames: [String]) -> Template? {
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
