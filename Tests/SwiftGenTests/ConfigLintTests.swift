//
// SwiftGen UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
import XCTest

class ConfigLintTests: XCTestCase {
  private func _testLint(
    fixture: String,
    expectedLogs: [(LogLevel, String)],
    unwantedLevels: Set<LogLevel> = [],
    assertionMessage: String,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    var missingLogs = expectedLogs
    let configFile = Path(path)
    do {
      let logger = { (level: LogLevel, msg: String) -> Void in
        if let idx = missingLogs.firstIndex(where: { $0 == level && $1 == msg }) {
          missingLogs.remove(at: idx)
        } else if unwantedLevels.contains(level) {
          XCTFail("Unexpected log: \(msg)")
        }
      }

      let config = try Config(file: configFile, logger: logger)
      config.lint(logger: logger)
    } catch let error {
      if let idx = missingLogs.firstIndex(where: { $0 == .error && $1 == String(describing: error) }) {
        missingLogs.remove(at: idx)
      } else {
        XCTFail("Unexpected error: \(error)", file: file, line: line)
      }
    }
    XCTAssertTrue(
      missingLogs.isEmpty,
      """
      \(assertionMessage)
      The following logs were expected but never received:
      \(missingLogs.map { "\($0) - \($1)" }.joined(separator: "\n"))
      """,
      file: file,
      line: line
    )
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

    _testLint(
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

    _testLint(
      fixture: "config-absolute-paths-prefix",
      expectedLogs: logs,
      assertionMessage: "Linter should warn when paths are absolute."
    )
  }

  func testMissingSources() {
    _testLint(
      fixture: "config-missing-paths",
      expectedLogs: [(.error, "Missing entry for key strings.inputs.")],
      assertionMessage: "Linter should warn when 'paths' key is missing"
    )
  }

  func testMissingTemplateNameAndPath() {
    let errorMsg = """
      You must specify a template by name (templateName) or path (templatePath).

      To list all the available named templates, use 'swiftgen templates list'.
      """
    _testLint(
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
    _testLint(
      fixture: "config-both-templates",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when both 'templateName' and 'templatePath' keys are present"
    )
  }

  func testMissingOutput() {
    _testLint(
      fixture: "config-missing-output",
      expectedLogs: [(.error, "Missing entry for key strings.outputs.output.")],
      assertionMessage: "Linter should warn when 'output' key is missing"
    )
  }

  func testInvalidStructure() {
    _testLint(
      fixture: "config-invalid-structure",
      expectedLogs: [
        (.error, "Wrong type for key strings.inputs: expected String or Array of String, got Array<Any>.")
      ],
      assertionMessage: "Linter should warn when config file structure is invalid"
    )
  }

  func testInvalidTemplateValue() {
    _testLint(
      fixture: "config-invalid-template",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.templateName: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'template' key is of unexpected type"
    )
  }

  func testInvalidOutput() {
    _testLint(
      fixture: "config-invalid-output",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.output: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'output' key is of unexpected type"
    )
  }

  // MARK: - Path validation

  func testInvalidPaths() {
    _testLint(
      fixture: "config-with-multi-entries",
      expectedLogs: [
        (.error, "input_dir: Input directory \(Config.Message.doesntExist("Fixtures/"))"),
        (.error, "output_dir: Output directory \(Config.Message.doesntExist("Generated/"))"),
        (.error, "strings.inputs: \(Config.Message.doesntExist("Fixtures/Strings/Localizable.strings"))"),
        (.error, "strings.outputs: Template not found at path templates/custom-swift3."),
        (.error, "strings.outputs.output: \(Config.Message.doesntExistIntermediatesNeeded("Generated"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Colors.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Colors.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Images.xcassets"))"),
        (.error, "xcassets.inputs: \(Config.Message.doesntExist("Fixtures/XCAssets/Images.xcassets"))"),
        (.error, """
          xcassets.outputs: Template named custom-swift3 not found. Use `swiftgen templates list` \
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
    _testLint(
      fixture: "config-deprecated-commands",
      expectedLogs: [(.warning, Config.Message.deprecatedAction("storyboards", for: "ib"))],
      assertionMessage: "Linter should warn about deprecated commands"
    )
  }

  func testDeprecatedPaths() {
    _testLint(
      fixture: "config-deprecated-paths",
      expectedLogs: [(.warning, "strings: `paths` is a deprecated in favour of `inputs`.")],
      assertionMessage: "Linter should warn about the deprecated 'paths' key"
    )
  }

  func testDeprecatedOutput() {
    _testLint(
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
    _testLint(
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
