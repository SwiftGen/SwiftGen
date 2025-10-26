//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import ArgumentParser
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenCLI
import SwiftGenKit

extension Commands {
  struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Run individual parser commands, outside of a config file.",
      subcommands: [
        ParserCommand<Colors.Parser>.self,
        ParserCommand<CoreData.Parser>.self,
        ParserCommand<Files.Parser>.self,
        ParserCommand<Fonts.Parser>.self,
        ParserCommand<InterfaceBuilder.Parser>.self,
        ParserCommand<JSON.Parser>.self,
        ParserCommand<Plist.Parser>.self,
        ParserCommand<Strings.Parser>.self,
        ParserCommand<AssetsCatalog.Parser>.self,
        ParserCommand<Yaml.Parser>.self,

        // deprecated
        DeprecatedCommands.Storyboards.self
      ]
    )
  }
}

extension Commands.Run {
  struct ParserCommand<Parser: ParserWithInfo>: ParsableCommand {
    static var configuration: CommandConfiguration {
      .init(
        commandName: Parser.info.name,
        abstract: Parser.info.description
      )
    }

    @Option(name: .shortAndLong, help: "The regular expression to filter input paths.")
    var filter: String = Parser.self.defaultFilter

    @Option(name: [.customLong("option")], help: "List of parser options. \(Parser.self.allOptions)")
    var options: [String] = []

    @OptionGroup
    var template: TemplateOptions

    @Option(name: [.customLong("param")], help: "List of template parameters.")
    var templateParameters: [String] = []

    @OptionGroup
    var output: Commands.OutputDestination

    @OptionGroup(visibility: .hidden)
    var spacing: Commands.ExperimentalSpacing

    @Argument(help: .init(Parser.info.pathDescription, valueName: "path"))
    var paths: [Path]

    @Flag
    var logLevel: CommandLogLevel = .default

    mutating func run() throws {
      commandLogLevel = logLevel

      let mentor = AIMentor()
      let parserOptions = try Parameters.parse(items: options)
      let optionSignature = AIMentor.makeOptionSignature(from: parserOptions)
      let parser = try Parser(options: parserOptions) { msg, _, _ in
        logMessage(.warning, msg)
      }

      let filterPattern = filter
      let filter = try Filter(pattern: filterPattern, options: Parser.self.filterOptions)
      try parser.searchAndParse(paths: paths, filter: filter)

      let templateRef = try template.reference
      let templateRealPath = try templateRef.resolvePath(forParser: Parser.info)
      let isBundledTemplate = templateRef.isBundled(forParser: Parser.info)
      let template = try Template.load(
        from: templateRealPath,
        modernSpacing: isBundledTemplate || spacing.modernSpacing
      )

      let context = parser.stencilContext()
      let parameterSignature = AIMentor.makeParameterSignature(from: templateParameters)
      let inputDigest = AIMentor.makeInputDigest(from: paths.map { $0.string })
      let snapshot = AIMentor.PromptSnapshot(
        commandName: Parser.info.name,
        templateName: templateRef.displayName,
        filter: filterPattern,
        optionSignature: optionSignature,
        parameterSignature: parameterSignature,
        inputCount: paths.count,
        inputDigest: inputDigest
      )
      mentor.observe(prompt: snapshot)

      let proposed = AIMentor.ProposedOutput(
        commandName: Parser.info.name,
        templateName: templateRef.displayName,
        filter: filterPattern,
        optionSignature: optionSignature,
        parameterSignature: parameterSignature,
        inputCount: paths.count,
        inputDigest: inputDigest,
        context: context,
        outputDescription: output.destination.description
      )
      for tip in mentor.advice(for: proposed) {
        logMessage(.info, "💡 Mentor Tip: \(tip)")
      }

      let enriched = try StencilContext.enrich(context: context, parameters: templateParameters)
      let rendered = try template.render(enriched)
      try output.destination.write(content: rendered, onlyIfChanged: true)
    }
  }
}

// MARK: - Helpers

extension Commands.Run.ParserCommand {
  struct TemplateOptions: ParsableArguments {
    @Option(
      name: [.customLong("template"), .customShort("t")],
      help: .init("DEPRECATED, use `--templateName` instead.", visibility: .hidden)
    )
    var deprecatedTemplateName: String?

    @Option(
      name: [.customLong("templateName"), .customShort("n")],
      help: """
        The name of the template to use for code generation. See `swiftgen template list` for a list of available names.
        """
    )
    var templateName: String?

    @Option(
      name: [.customLong("templatePath"), .customShort("p")],
      help: "The path of the template to use for code generation."
    )
    var templatePath: String?

    var reference: TemplateRef {
      get throws {
        try TemplateRef(
          templateShortName: templateName ?? deprecatedTemplateName ?? "",
          templateFullPath: templatePath ?? ""
        )
      }
    }

    func validate() throws {
      _ = try reference
    }
  }
}
