//
//  TemplateRef.swift
//  swiftgen
//
//  Created by Olivier HALLIGON on 11/10/2017.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import PathKit

enum TemplateRef {
  case name(String)
  case path(Path)

  enum Error: Swift.Error {
    case namedTemplateNotFound(name: String)
    case templatePathNotFound(path: Path)
    case noTemplateProvided
    case multipleTemplateOptions(path: String, name: String)
  }

  init(templateShortName: String, templateFullPath: Path?) throws {
    switch (templateFullPath, !templateShortName.isEmpty) {
    case (nil, false):
      throw TemplateRef.Error.noTemplateProvided
    case (nil, true):
      self = .name(templateShortName)
    case (let fullPath?, false):
      self = .path(fullPath)
    case (let fullPath?, true):
      throw TemplateRef.Error.multipleTemplateOptions(path: fullPath.string, name: templateShortName)
    }
  }

  /**
   Returns the path of a template
   * If it's a `.path`, check that the path exists and return it (throws if it isn't an existing file)
   * If it's a `.name`, search the named template in the folder `subcommand`
   in the Application Support directory first, then in the bundled templates,
   and returns the path if found (throws if none is found)

   - parameter subcommand         the folder for the template, typically name of one of the SwiftGen subcommand
   like `strings`, `colors`, etc

   - throws: TemplateError

   - returns: The Path matching the template found
   */
  func resolvePath(forSubcommand subCmd: String) throws -> Path {
    switch self {
    case .name(let templateShortName):
      var path = appSupportTemplatesPath + subCmd + "\(templateShortName).stencil"
      if !path.isFile {
        path = bundledTemplatesPath + subCmd + "\(templateShortName).stencil"
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
