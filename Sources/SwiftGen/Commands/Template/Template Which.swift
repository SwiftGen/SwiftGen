//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser

extension Commands.Template {
  struct Which: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Print path of a given named template.")

    @OptionGroup
    var template: TemplateOptions

    @OptionGroup
    var output: Commands.OutputDestination

    func run() throws {
      try output.destination.write(content: "\(template.path.description)\n")
    }
  }
}
