import Foundation
import PathKit


public protocol Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template
  func loadTemplate(names: [String], environment: Environment) throws -> Template
}


extension Loader {
  public func loadTemplate(names: [String], environment: Environment) throws -> Template {
    for name in names {
      do {
        return try loadTemplate(name: name, environment: environment)
      } catch is TemplateDoesNotExist {
        continue
      } catch {
        throw error
      }
    }

    throw TemplateDoesNotExist(templateNames: names, loader: self)
  }
}


// A class for loading a template from disk
public class FileSystemLoader: Loader, CustomStringConvertible {
  public let paths: [Path]

  public init(paths: [Path]) {
    self.paths = paths
  }

  public init(bundle: [Bundle]) {
    self.paths = bundle.map {
      return Path($0.bundlePath)
    }
  }

  public var description: String {
    return "FileSystemLoader(\(paths))"
  }

  public func loadTemplate(name: String, environment: Environment) throws -> Template {
    for path in paths {
      let templatePath = try path.safeJoin(path: Path(name))

      if !templatePath.exists {
        continue
      }

      let content: String = try templatePath.read()
      return environment.templateClass.init(templateString: content, environment: environment, name: name)
    }

    throw TemplateDoesNotExist(templateNames: [name], loader: self)
  }

  public func loadTemplate(names: [String], environment: Environment) throws -> Template {
    for path in paths {
      for templateName in names {
        let templatePath = try path.safeJoin(path: Path(templateName))

        if templatePath.exists {
          let content: String = try templatePath.read()
          return environment.templateClass.init(templateString: content, environment: environment, name: templateName)
        }
      }
    }

    throw TemplateDoesNotExist(templateNames: names, loader: self)
  }
}


public class DictionaryLoader: Loader {
  public let templates: [String: String]

  public init(templates: [String: String]) {
    self.templates = templates
  }

  public func loadTemplate(name: String, environment: Environment) throws -> Template {
    if let content = templates[name] {
      return environment.templateClass.init(templateString: content, environment: environment, name: name)
    }

    throw TemplateDoesNotExist(templateNames: [name], loader: self)
  }

  public func loadTemplate(names: [String], environment: Environment) throws -> Template {
    for name in names {
      if let content = templates[name] {
        return environment.templateClass.init(templateString: content, environment: environment, name: name)
      }
    }

    throw TemplateDoesNotExist(templateNames: names, loader: self)
  }
}


extension Path {
  func safeJoin(path: Path) throws -> Path {
    let newPath = self + path

    if !newPath.absolute().description.hasPrefix(absolute().description) {
      throw SuspiciousFileOperation(basePath: self, path: newPath)
    }

    return newPath
  }
}


class SuspiciousFileOperation: Error {
  let basePath: Path
  let path: Path

  init(basePath: Path, path: Path) {
    self.basePath = basePath
    self.path = path
  }

  var description: String {
    return "Path `\(path)` is located outside of base path `\(basePath)`"
  }
}
