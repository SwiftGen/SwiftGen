//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import SwiftGenCLI

extension Commands {
  struct Template: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Manage custom templates.",
      subcommands: [
        List.self,
        Which.self,
        Cat.self,
        Doc.self
      ]
    )
  }
}

// MARK: - Helpers

extension Commands.Template {
  struct TemplateOptions: ParsableArguments {
    @Argument(help: "The name of the parser the template is for, like `xcassets`")
    var parser: ParserCLI

    @Argument(help: "The name of the template to find, like `swift5` or `flat-swift5`")
    var template: String

    var path: Path {
      get throws {
        let template = TemplateRef.name(self.template)
        return try template.resolvePath(forParser: parser)
      }
    }

    func validate() throws {
      if try !path.isFile {
        throw ValidationError("Unknown bundled template `\(parser.name)/\(template)`")
      }
    }
  }
}
