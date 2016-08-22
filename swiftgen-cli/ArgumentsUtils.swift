//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit

// MARK: Validators

func checkPath(type: String, assertion: Path -> Bool) -> (Path throws -> Path) {
  return { (path: Path) throws -> Path in
    guard assertion(path) else { throw ArgumentError.InvalidType(value: path.description, type: type, argument: nil) }
    return path
  }
}
let pathExists = checkPath("path") { $0.exists }
let fileExists = checkPath("file") { $0.isFile }
let dirExists  = checkPath("directory") { $0.isDirectory }

// MARK: Path as Input Argument

extension Path : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.MissingValue(argument: nil)
    }
    self = Path(path)
  }
}

// MARK: Output (Path or Console) Argument

func printError(string: String) {
  fputs("\(string)\n", stderr)
}

enum OutputDestination: ArgumentConvertible {
  case Console
  case File(Path)

  init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.MissingValue(argument: nil)
    }
    self = .File(Path(path))
  }
  var description: String {
    switch self {
    case .Console: return "(stdout)"
    case .File(let path): return path.description
    }
  }

  func write(content: String, onlyIfChanged: Bool = false) {
    switch self {
    case .Console:
      print(content)
    case .File(let path):
      do {
        if try onlyIfChanged && path.exists && path.read(NSUTF8StringEncoding) == content {
          return print("Not writing the file as content is unchanged")
        }
        try path.write(content)
        print("File written: \(path)")
      } catch let e as NSError {
        printError("error: \(e)")
      }
    }
  }
}

// MARK: Template Arguments

enum TemplateError: ErrorType, CustomStringConvertible {
  case NamedTemplateNotFound(name: String)
  case TemplatePathNotFound(path: Path)

  var description: String {
    switch self {
    case .NamedTemplateNotFound(let name):
      return "Template named \(name) not found. Use `swiftgen template` to list available named templates " +
      "or use --templatePath to specify a template by its full path."
    case .TemplatePathNotFound(let path):
      return "Template not found at path \(path.description)."
    }
  }
}

extension Path {
  static let applicationSupport: Path = {
    let paths = NSSearchPathForDirectoriesInDomains(
      .ApplicationSupportDirectory,
      .UserDomainMask, true
    )
    guard let path = paths.first else {
      fatalError("Unable to locate the Application Support directory on your machine!")
    }
    return Path(path)
  }()
}

let appSupportTemplatesPath = Path.applicationSupport + "SwiftGen/templates"
let bundledTemplatesPath = Path(NSProcessInfo.processInfo().arguments[0]).parent() + templatesRelativePath

/**
 Returns the path of a template given its prefix and short name, or its full path.
 * If `templateFullPath` is not empty, check that the path exists and return it (throws if it isn't an existing file)
 * If `templateFullPath` is empty `""`, search the template named `prefix-templateShortName`
   in the Application Support directory first, then in the bundled templates,
   and returns the path if found (throws if none is found)

 - parameter prefix:            the prefix for the template, typically name of one of the SwiftGen subcommand
                                like `strings`, `colors`, etc
 - parameter templateShortName: the short name of the template, might be `"default"` or any custom name
 - parameter templateFullPath:  the full path of the template to find. If this is set to an existing file, it
                                returns that Path without even using `prefix` and `templateShortName` parameters.

 - throws: TemplateError

 - returns: The Path matching the template to find
 */
func findTemplate(prefix: String, templateShortName: String, templateFullPath: String) throws -> Path {
  guard templateFullPath.isEmpty else {
    let fullPath = Path(templateFullPath)
    guard fullPath.isFile else {
      throw TemplateError.TemplatePathNotFound(path: fullPath)
    }
    return fullPath
  }

  var path = appSupportTemplatesPath + "\(prefix)-\(templateShortName).stencil"
  if !path.isFile {
    path = bundledTemplatesPath + "\(prefix)-\(templateShortName).stencil"
  }
  guard path.isFile else {
    throw TemplateError.NamedTemplateNotFound(name: templateShortName)
  }
  return path
}
