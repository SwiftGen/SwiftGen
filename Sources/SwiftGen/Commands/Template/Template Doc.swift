//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import AppKit
import ArgumentParser
import SwiftGenCLI

extension Commands.Template {
  struct Doc: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Open the documentation for templates on GitHub.")

    @Argument(help: "The name of the parser the template is for, like `xcassets`")
    var parser: ParserCLI?

    @Argument(help: "The name of the template to find, like `swift5` or `flat-swift5`")
    var template: String?

    func validate() throws {
      guard let template = template else { return }

      guard let parser = parser else {
        throw ValidationError("Must have parser for template `\(template)`")
      }

      guard TemplateRef.name(template).isBundled(forParser: parser) else {
        throw ValidationError("""
          If provided, the 2nd argument must be the name of a bundled template for the given parser
          """)
      }
    }

    func run() throws {
      var path = "templates/"
      if let parser = parser {
        path += "\(parser.name)/"
        if let template = template {
          path += "\(template).md"
        }
      }

      let url = gitHubDocURL(version: Version.swiftgen, path: path)
      logMessage(.info, "Opening documentation: \(url)")
      NSWorkspace.shared.open(url)
    }
  }
}
