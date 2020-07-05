//
// SwiftGen UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
import XCTest

final class ConfigLintTests: XCTestCase {
  private lazy var bundle = Bundle(for: type(of: self))

  private func testLint(
    fixture: String,
    expectedLogs: [(LogLevel, String)],
    unwantedLevels: Set<LogLevel> = [],
    assertionMessage: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let path = bundle.path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    let configFile = Path(path)
    let logger = TestLogger(expectedLogs: expectedLogs, unwantedLevels: unwantedLevels, file: file, line: line)

    do {
      let config = try Config(file: configFile, logger: logger.log)
      config.lint(logger: logger.log)
    } catch let error {
      logger.handleError(error)
    }

    logger.waitAndAssert(message: assertionMessage)
  }

  func testAbsolutePathDirect() {
    let commands = ["strings", "fonts", "ib", "colors", "xcassets"]
    let logs = commands.flatMap { (cmd: String) -> [(LogLevel, String)] in
      [
        (.warning, "\(cmd).inputs: \(Config.Message.absolutePath("/\(cmd)/paths"))"),
        (.warning, "\(cmd).outputs.templatePath: \(Config.Message.absolutePath("/\(cmd)/templates.stencil"))"),
        (.warning, "\(cmd).outputs.output: \(Config.Message.absolutePath("/\(cmd)/out.swift"))")
      ]
    }

    testLint(
      fixture: "config-absolute-paths-direct",
      expectedLogs: logs,
      assertionMessage: "Linter should warn when paths are absolute."
    )
  }

  func testAbsolutePathPrefix() {
    let commands = ["strings", "fonts", "ib", "colors", "xcassets"]
    let logs = commands.flatMap { (cmd: String) -> [(LogLevel, String)] in
      [
        (.warning, "\(cmd).inputs: \(Config.Message.absolutePath("/input/\(cmd)/paths"))"),
        (.warning, """
          \(cmd).outputs.templatePath: \(Config.Message.absolutePath("/templates/\(cmd)/templates.stencil"))
          """),
        (.warning, "\(cmd).outputs.output: \(Config.Message.absolutePath("/output/\(cmd)/out.swift"))")
      ]
    }

    testLint(
      fixture: "config-absolute-paths-prefix",
      expectedLogs: logs,
      assertionMessage: "Linter should warn when paths are absolute."
    )
  }

  func testMissingSources() {
    testLint(
      fixture: "config-missing-paths",
      expectedLogs: [(.error, "Missing entry for key strings.inputs.")],
      assertionMessage: "Linter should warn when 'paths' key is missing"
    )
  }

  func testMissingTemplateNameAndPath() {
    let errorMsg = """
      You must specify a template by name (templateName) or path (templatePath).

      To list all the available named templates, use 'swiftgen template list'.
      """
    testLint(
      fixture: "config-missing-template",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when neither 'templateName' nor 'templatePath' keys are present"
    )
  }

  func testBothTemplateNameAndPath() {
    let errorMsg = """
      You need to choose EITHER a named template OR a template path. \
      Found name 'template' and path 'template.swift'
      """
    testLint(
      fixture: "config-both-templates",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when both 'templateName' and 'templatePath' keys are present"
    )
  }

  func testMissingOutput() {
    testLint(
      fixture: "config-missing-output",
      expectedLogs: [(.error, "Missing entry for key strings.outputs.output.")],
      assertionMessage: "Linter should warn when 'output' key is missing"
    )
  }

  func testInvalidStructure() {
    testLint(
      fixture: "config-invalid-structure",
      expectedLogs: [
        (.error, "Wrong type for key strings.inputs: expected String or Array of String, got Array<Any>.")
      ],
      assertionMessage: "Linter should warn when config file structure is invalid"
    )
  }

  func testInvalidTemplateValue() {
    testLint(
      fixture: "config-invalid-template",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.templateName: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'template' key is of unexpected type"
    )
  }

  func testInvalidOutput() {
    testLint(
      fixture: "config-invalid-output",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.output: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'output' key is of unexpected type"
    )
  }

  // MARK: - Path validation

  func testInvalidPaths() {
    testLint(
      fixture: "config-with-multi-entries",
      expectedLogs: [
        (.error, "input_dir: Input directory \(Config.Message.doesntExist("Fixtures/"))"),
        (.error, "output_dir: Output directory \(Config.Message.doesntExist("Generated/"))"),
        (.error, "strings.inputs: \(Config.Message.doesntExist("Fixtures/Strings/Localizable.strings"))"),
        (.error, "strings.outputs: Template not found at path templates/custom-swift5."),
        (.error, "strings.outputs.output: \(Config.Message.doesntExistIntermediatesNeeded("Generated"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Colors.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Colors.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Images.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Images.xcassets"))"),
        (.error, """
          xcassets.outputs: Template named custom-swift5 not found. Use `swiftgen template list` \
          to list available named templates or use `templatePath` to specify a template by its \
          full path.
          """),
        (.error, "xcassets.outputs.output: \(Config.Message.doesntExistIntermediatesNeeded("Generated"))"),
        (.error, "xcassets.outputs.output: \(Config.Message.doesntExistIntermediatesNeeded("Generated"))"),
        (.error, "xcassets.outputs.output: \(Config.Message.doesntExistIntermediatesNeeded("Generated"))")
      ],
      unwantedLevels: [.warning, .error],
      assertionMessage: "Linter should show errors for invalid paths and templates"
    )
  }

  // MARK: - Deprecation warnings

  func testDeprecatedCommands() {
    testLint(
      fixture: "config-deprecated-commands",
      expectedLogs: [(.warning, Config.Message.deprecatedParser("storyboards", for: "ib"))],
      assertionMessage: "Linter should warn about deprecated commands"
    )
  }

  func testDeprecatedPaths() {
    testLint(
      fixture: "config-deprecated-paths",
      expectedLogs: [(.warning, "strings: `paths` is a deprecated in favour of `inputs`.")],
      assertionMessage: "Linter should warn about the deprecated 'paths' key"
    )
  }

  func testDeprecatedOutput() {
    testLint(
      fixture: "config-deprecated-output",
      expectedLogs: [
        (.warning, "strings: `output` is a deprecated in favour of `outputs.output`."),
        (.warning, "strings: `params` is a deprecated in favour of `outputs.params`."),
        (.warning, "strings: `templateName` is a deprecated in favour of `outputs.templateName`.")
      ],
      assertionMessage: "Linter should warn about the deprecated 'output', `params` and `templateName` keys"
    )
  }

  func testDeprecateMixedWithNew() {
    testLint(
      fixture: "config-deprecated-mixed-with-new",
      expectedLogs: [
        (.warning, "strings: `output` is a deprecated in favour of `outputs.output`."),
        (.warning, "strings: `params` is a deprecated in favour of `outputs.params`."),
        (.warning, "strings: `templateName` is a deprecated in favour of `outputs.templateName`."),
        (.warning, "strings: `output` is a deprecated in favour of `outputs.output`."),
        (.warning, "strings: `params` is a deprecated in favour of `outputs.params`."),
        (.warning, "strings: `templatePath` is a deprecated in favour of `outputs.templatePath`.")
      ],
      assertionMessage: "Linter should warn about deprecated keys even if newer keys are available"
    )
  }
}
