//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import PathKit
#if canImport(SwiftGen)
@testable import SwiftGen
#endif
import XCTest

class ConfigLintTests: XCTestCase {
  private func _testLint(fixture: String,
                         expectedLogs: [(LogLevel, String)],
                         assertionMessage: String,
                         file: StaticString = #file,
                         line: UInt = #line) {
    guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    var missingLogs = expectedLogs
    let configFile = Path(path)
    do {
      let logger = { (level: LogLevel, msg: String) -> Void in
        if let idx = missingLogs.index(where: { $0 == level && $1 == msg }) {
          missingLogs.remove(at: idx)
        }
      }

      let config = try Config(file: configFile, logger: logger)
      config.lint(logger: logger)
    } catch let error {
      if let idx = missingLogs.index(where: { $0 == .error && $1 == String(describing: error) }) {
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

  func testLint_AbsolutePathDirect() {
    let commands = ["strings", "fonts", "ib", "colors", "xcassets"]
    let logs = commands.flatMap { (cmd: String) -> [(LogLevel, String)] in
      [
        (.warning, "\(cmd).paths: /\(cmd)/paths is an absolute path."),
        (.warning, "\(cmd).templatePath: /\(cmd)/templates.stencil is an absolute path."),
        (.warning, "\(cmd).output: /\(cmd)/out.swift is an absolute path.")
      ]
    }

    _testLint(
      fixture: "config-absolute-paths-direct",
      expectedLogs: logs,
      assertionMessage: "Linter should warn when paths are absolute."
    )
  }

  func testLintAbsolutePathPrefix() {
    let commands = ["strings", "fonts", "ib", "colors", "xcassets"]
    let logs = commands.flatMap { (cmd: String) -> [(LogLevel, String)] in
      [
        (.warning, "\(cmd).paths: /input/\(cmd)/paths is an absolute path."),
        (.warning, "\(cmd).templatePath: /templates/\(cmd)/templates.stencil is an absolute path."),
        (.warning, "\(cmd).output: /output/\(cmd)/out.swift is an absolute path.")
      ]
    }

    _testLint(
      fixture: "config-absolute-paths-prefix",
      expectedLogs: logs,
      assertionMessage: "Linter should warn when paths are absolute."
    )
  }

  func testLintMissingSources() {
    _testLint(
      fixture: "config-missing-paths",
      expectedLogs: [(.error, "Missing entry for key strings.inputs.")],
      assertionMessage: "Linter should warn when 'paths' key is missing"
    )
  }

  func testLintMissingTemplateNameAndPath() {
    let errorMsg = """
      You must specify a template name (-t) or path (-p).

      To list all the available named templates, use 'swiftgen templates list'.
      """
    _testLint(
      fixture: "config-missing-template",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when neither 'templateName' nor 'templatePath' keys are present"
    )
  }

  func testLintBothTemplateNameAndPath() {
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

  func testLintMissingOutput() {
    _testLint(
      fixture: "config-missing-output",
      expectedLogs: [(.error, "Missing entry for key strings.outputs.output.")],
      assertionMessage: "Linter should warn when 'output' key is missing"
    )
  }

  func testLintInvalidStructure() {
    _testLint(
      fixture: "config-invalid-structure",
      expectedLogs: [(.error, """
        Wrong type for key strings.inputs: expected String or Array of String, got Array<Any>.
        """)],
      assertionMessage: "Linter should warn when config file structure is invalid"
    )
  }

  func testLintInvalidTemplateValue() {
    _testLint(
      fixture: "config-invalid-template",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.templateName: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'template' key is of unexpected type"
    )
  }

  func testLintInvalidOutput() {
    _testLint(
      fixture: "config-invalid-output",
      expectedLogs: [(.error, "Wrong type for key strings.outputs.output: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'output' key is of unexpected type"
    )
  }

  // MARK: - Deprecation warnings

  func testLintDeprecatedPaths() {
    _testLint(
      fixture: "config-deprecated-paths",
      expectedLogs: [(.warning, "strings: `paths` is a deprecated in favour of `inputs`.")],
      assertionMessage: "Linter should warn about the deprecated 'paths' key"
    )
  }

  func testLintDeprecatedOutput() {
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

  func testLintDeprecateMixedWithNew() {
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
