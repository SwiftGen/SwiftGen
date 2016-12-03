import Foundation
import PathKit


public protocol Loader {
  func loadTemplate(name: String) throws -> Template?
  func loadTemplate(names: [String]) throws -> Template?
}


extension Loader {
  func loadTemplate(names: [String]) throws -> Template? {
    for name in names {
      let template = try loadTemplate(name: name)

      if template != nil {
        return template
      }
    }

    return nil
  }
}


// A class for loading a template from disk
public class FileSystemLoader: Loader {
  public let paths: [Path]

  public init(paths: [Path]) {
    self.paths = paths
  }

  public init(bundle: [Bundle]) {
    self.paths = bundle.map {
      return Path($0.bundlePath)
    }
  }

  public func loadTemplate(name: String) throws -> Template? {
    for path in paths {
      let templatePath = path + Path(name)

      if templatePath.exists {
        return try Template(path: templatePath)
      }
    }

    return nil
  }

  public func loadTemplate(names: [String]) throws -> Template? {
    for path in paths {
      for templateName in names {
        let templatePath = path + Path(templateName)

        if templatePath.exists {
          return try Template(path: templatePath)
        }
      }
    }

    return nil
  }
}
