//
// SwiftGen
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit

enum TemplateRef: Equatable {
  case name(String)
  case path(Path)

  enum Error: Swift.Error {
    case namedTemplateNotFound(name: String)
    case templatePathNotFound(path: Path)
    case noTemplateProvided
    case multipleTemplateOptions(path: String, name: String)
  }

  init(templateShortName: String, templateFullPath: String) throws {
    switch (!templateFullPath.isEmpty, !templateShortName.isEmpty) {
    case (false, false):
      throw TemplateRef.Error.noTemplateProvided
    case (false, true):
      self = .name(templateShortName)
    case (true, false):
      self = .path(Path(templateFullPath))
    case (true, true):
      throw TemplateRef.Error.multipleTemplateOptions(path: templateFullPath, name: templateShortName)
    }
  }

  /// Returns the path of a template
  ///
  /// * If it's a `.path`, check that the path exists and return it (throws if it isn't an existing file)
  /// * If it's a `.name`, search the named template in the folder `parserName`
  ///   in the Application Support directory first, then in the bundled templates,
  ///   and returns the path if found (throws if none is found)
  ///
  /// - Parameter parserName: The folder to search for the template.
  ///                         Typically the name of one of the SwiftGen parsers like `strings`, `colors`, etc
  /// - Returns: The Path matching the template found
  /// - Throws: TemplateRef.Error
  ///
  func resolvePath(forParser parser: ParserCLI) throws -> Path {
    switch self {
    case .name(let templateShortName):
      var path = Path.appSupportTemplates + parser.templateFolder + "\(templateShortName).stencil"
      if !path.isFile {
        path = Path.bundledTemplates + parser.templateFolder + "\(templateShortName).stencil"
      }
      guard path.isFile else {
        throw TemplateRef.Error.namedTemplateNotFound(name: templateShortName)
      }
      return path
    case .path(let fullPath):
      guard fullPath.isFile else {
        throw TemplateRef.Error.templatePathNotFound(path: fullPath)
      }
      return fullPath
    }
  }
}

extension TemplateRef.Error: CustomStringConvertible {
  var description: String {
    switch self {
    case .namedTemplateNotFound(let name):
      return """
        Template named \(name) not found. Use `swiftgen templates list` to list available named templates \
        or use `templatePath` to specify a template by its full path.
        """
    case .templatePathNotFound(let path):
      return "Template not found at path \(path.description)."
    case .noTemplateProvided:
      return """
        You must specify a template by name (templateName) or path (templatePath).

        To list all the available named templates, use 'swiftgen templates list'.
        """
    case .multipleTemplateOptions(let path, let name):
      return "You need to choose EITHER a named template OR a template path. Found name '\(name)' and path '\(path)'"
    }
  }
}
