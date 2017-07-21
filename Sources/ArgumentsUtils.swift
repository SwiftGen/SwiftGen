//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import Commander
import PathKit

// MARK: Validators

func checkPath(type: String, assertion: @escaping (Path) -> Bool) -> ((Path) throws -> Path) {
  return { (path: Path) throws -> Path in
    guard assertion(path) else { throw ArgumentError.invalidType(value: path.description, type: type, argument: nil) }
    return path
  }
}

typealias PathValidator = ([Path]) throws -> ([Path])
let pathsExist: PathValidator = { paths in try paths.map(checkPath(type: "path") { $0.exists }) }
let filesExist: PathValidator = { paths in try paths.map(checkPath(type: "file") { $0.isFile }) }
let dirsExist: PathValidator = { paths in try paths.map(checkPath(type: "directory") { $0.isDirectory }) }

// MARK: Path as Input Argument

extension Path : ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = Path(path)
  }
}

// MARK: Output (Path or Console) Argument

func printError(string: String) {
  fputs("\(string)\n", stderr)
}

enum OutputDestination: ArgumentConvertible {
  case console
  case file(Path)

  init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = .file(Path(path))
  }
  var description: String {
    switch self {
    case .console: return "(stdout)"
    case .file(let path): return path.description
    }
  }

  func write(content: String, onlyIfChanged: Bool = false) {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      do {
        if try onlyIfChanged && path.exists && path.read(.utf8) == content {
          return print("Not writing the file as content is unchanged")
        }
        try path.write(content)
        print("File written: \(path)")
      } catch let e as NSError {
        printError(string: "error: \(e)")
      }
    }
  }
}

// MARK: Template Arguments

enum TemplateError: Error, CustomStringConvertible {
  case namedTemplateNotFound(name: String)
  case templatePathNotFound(path: Path)
  case noTemplateProvided
  case multipleTemplateOptions(path: String, name: String)

  var description: String {
    switch self {
    case .namedTemplateNotFound(let name):
      return "Template named \(name) not found. Use `swiftgen templates` to list available named templates " +
      "or use --templatePath to specify a template by its full path."
    case .templatePathNotFound(let path):
      return "Template not found at path \(path.description)."
    case .noTemplateProvided:
      return "A template must be chosen either via its name using '-t' or via its path using '-p'.\n\n" +
      "Note: there's no 'default' template anymore: you can still access a bundled template but " +
      "you have to specify its name explicitly using '-t'.\n" +
      "To list all the available named templates, use 'swiftgen templates list'."
    case let .multipleTemplateOptions(path, name):
      return "You need to choose EITHER a named template (--template option) " +
      "OR a template path (option --templatePath). Found name '\(name)' and path '\(path)'"
    }
  }
}

extension Path {
  static let applicationSupport: Path = {
    let paths = NSSearchPathForDirectoriesInDomains(
      .applicationSupportDirectory,
      .userDomainMask, true
    )
    guard let path = paths.first else {
      fatalError("Unable to locate the Application Support directory on your machine!")
    }
    return Path(path)
  }()
}

let appSupportTemplatesPath = Path.applicationSupport + "SwiftGen/templates"
let bundledTemplatesPath = Path(ProcessInfo.processInfo.arguments[0]).parent() + templatesRelativePath

/**
 Returns the path of a template given its prefix and short name, or its full path.
 * If `templateFullPath` is not empty, check that the path exists and return it (throws if it isn't an existing file)
 * If `templateFullPath` is empty `""`, search the template named `templateShortName` in the folder `subcommand`
   in the Application Support directory first, then in the bundled templates,
   and returns the path if found (throws if none is found)
 * If both or neither are empty, an error will be thrown

 - parameter subcommand         the folder for the template, typically name of one of the SwiftGen subcommand
                                like `strings`, `colors`, etc
 - parameter templateShortName: the short name of the template
 - parameter templateFullPath:  the full path of the template to find. If this is set to an existing file, it
                                returns that Path without even using `subcommand` and `templateShortName` parameters.

 - throws: TemplateError

 - returns: The Path matching the template to find
 */
func findTemplate(subcommand: String, templateShortName: String, templateFullPath: String) throws -> Path {
  switch (!templateFullPath.isEmpty, !templateShortName.isEmpty) {
  case (false, false):
    throw TemplateError.noTemplateProvided
  case (true, false):
    let fullPath = Path(templateFullPath)
    guard fullPath.isFile else {
      throw TemplateError.templatePathNotFound(path: fullPath)
    }
    return fullPath
  case (false, true):
    var path = appSupportTemplatesPath + subcommand + "\(templateShortName).stencil"
    if !path.isFile {
      path = bundledTemplatesPath + subcommand + "\(templateShortName).stencil"
    }
    guard path.isFile else {
      throw TemplateError.namedTemplateNotFound(name: templateShortName)
    }
    return path
  case (true, true):
    throw TemplateError.multipleTemplateOptions(path: templateFullPath, name: templateShortName)
  }
}
