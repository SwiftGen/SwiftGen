//
// SwiftGen
// Copyright (c) 2015 Olivier Halligon
// MIT Licence
//

import XCTest
import PathKit

class ConfigTests: XCTestCase {

  func testReadConfigWithParams() throws {
    guard let path = Bundle(for: type(of: self)).path(forResource: "config-with-params", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)
      XCTAssertEqual(config.outputDir, "Common/Generated")
      XCTAssertEqual(Array(config.commands.keys), ["strings"])
      guard let stringsEntries = config.commands["strings"] else {
        return XCTFail("Missing key 'strings'")
      }
      XCTAssertEqual(stringsEntries.count, 1)
      guard let entry = stringsEntries.first else {
        return XCTFail("Can't get strings only config entry")
      }
      XCTAssertEqual(entry.paths, ["Sources1/Folder"])
      if case TemplateRef.name("structured-swift3") = entry.template { /* OK */ } else {
        XCTFail("Unexpected template")
      }
      XCTAssertEqual(entry.output, "strings.swift")
      XCTAssertEqual(entry.parameters["foo"] as? Int, 5)
      let barParams = entry.parameters["bar"] as? [String: Any]
      XCTAssertEqual(barParams?["bar1"] as? Int, 1)
      XCTAssertEqual(barParams?["bar2"] as? Int, 2)
      let bar3Params = barParams?["bar3"] as? [Any]
      XCTAssertEqual(bar3Params?.count, 3)
      XCTAssertEqual(bar3Params?[0] as? Int, 3)
      XCTAssertEqual(bar3Params?[1] as? Int, 4)
      XCTAssertEqual((bar3Params?[2] as? [String: Int]) ?? [:], ["bar3a": 50])
      let bazParams = entry.parameters["baz"] as? [String]
      XCTAssertEqual(bazParams ?? [], ["hello", "world"])
    } catch let e {
      XCTFail("Error: \(e)")
    }
  }

  // swiftlint:disable function_body_length
  func testReadConfigWithMultiEntries() throws {
    guard let path = Bundle(for: type(of: self)).path(forResource: "config-with-multi-entries", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)
      XCTAssertEqual(config.inputDir, "Fixtures/")
      XCTAssertEqual(config.outputDir, "Generated/")

      XCTAssertEqual(Array(config.commands.keys), ["strings", "xcassets"])

      // strings
      guard let stringsEntries = config.commands["strings"] else {
        return XCTFail("Missing key 'strings'")
      }
      XCTAssertEqual(stringsEntries.count, 1)
      guard let stringsEntry = stringsEntries.first else {
        return XCTFail("Can't get strings only config entry")
      }
      XCTAssertEqual(stringsEntry.paths, ["Strings/Localizable.strings"])
      if case TemplateRef.path(let tplPath) = stringsEntry.template,
      tplPath == "templates/custom-swift3" { /* OK */ } else {
        XCTFail("Unexpected template: \(stringsEntry.template)")
      }
      XCTAssertEqual(stringsEntry.output, "strings.swift")
      XCTAssertEqual(Array(stringsEntry.parameters.keys), ["enumName"])
      XCTAssertEqual(stringsEntry.parameters["enumName"] as? String, "Loc")

      // xcassets
      guard let xcassetsEntries = config.commands["xcassets"] else {
        return XCTFail("Missing key 'xcassets'")
      }
      XCTAssertEqual(xcassetsEntries.count, 3)
      // > xcassets[0]
      XCTAssertEqual(xcassetsEntries[0].paths, ["XCAssets/Colors.xcassets"])
      if case TemplateRef.name("swift3") = xcassetsEntries[0].template { /* OK */ } else {
        XCTFail("Unexpected template: \(xcassetsEntries[0].template)")
      }
      XCTAssertEqual(xcassetsEntries[0].output, "assets-colors.swift")
      XCTAssertEqual(xcassetsEntries[0].parameters.count, 0)
      // > xcassets[1]
      XCTAssertEqual(xcassetsEntries[1].paths, ["XCAssets/Images.xcassets"])
      if case TemplateRef.name("swift3") = xcassetsEntries[1].template { /* OK */ } else {
        XCTFail("Unexpected template: \(xcassetsEntries[1].template)")
      }
      XCTAssertEqual(xcassetsEntries[1].output, "assets-images.swift")
      XCTAssertEqual(xcassetsEntries[1].parameters.count, 1)
      XCTAssertEqual(xcassetsEntries[1].parameters["enumName"] as? String, "Pics")
      // > xcassets[2]
      XCTAssertEqual(xcassetsEntries[2].paths, ["XCAssets/Colors.xcassets", "XCAssets/Images.xcassets"])
      if case TemplateRef.name("swift4") = xcassetsEntries[2].template { /* OK */ } else {
        XCTFail("Unexpected template: \(xcassetsEntries[2].template)")
      }
      XCTAssertEqual(xcassetsEntries[2].output, "assets-all.swift")
      XCTAssertEqual(xcassetsEntries[2].parameters.count, 0)
    } catch let e {
      XCTFail("Error: \(e)")
    }
  }
  // swiftlint:enable function_body_length

  func testReadInvalidConfigThrows() {
    let badConfigs = [
      "config-missing-paths": "Missing entry for key strings.paths.",
      "config-missing-template": "You must specify a template name (-t) or path (-p).\n\n" +
      "To list all the available named templates, use 'swiftgen templates list'.",
      "config-both-templates": "You need to choose EITHER a named template OR a template path. " +
      "Found name 'template' and path 'template.swift'",
      "config-missing-output": "Missing entry for key strings.output.",
      "config-invalid-structure": "Wrong type for key strings.paths: expected Path or array of Paths, got Array<Any>.",
      "config-invalid-template": "Wrong type for key strings.templateName: expected String, got Array<Any>.",
      "config-invalid-output": "Wrong type for key strings.output: expected String, got Array<Any>."
    ]
    for (configFile, expectedError) in badConfigs {
      do {
        guard let path = Bundle(for: type(of: self)).path(forResource: configFile, ofType: "yml") else {
          fatalError("Fixture not found")
        }
        _ = try Config(file: Path(path))
        XCTFail("Trying to parse config file \(configFile) should have thrown " +
          "error \(expectedError) but didn't throw at all")
      } catch let e {
        XCTAssertEqual(
          String(describing: e), expectedError,
          "Trying to parse config file \(configFile) should have thrown " +
          "error \(expectedError) but threw \(e) instead."
        )
      }
    }
  }

  // MARK: Linting

  private func _testLint(fixture: String, expectedLogs: [(LogLevel, String)], assertionMessage: String,
                         file: StaticString = #file, line: UInt = #line) {
    guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "yml") else {
      fatalError("Fixture \(fixture) not found")
    }
    var missingLogs = expectedLogs
    let configFile = Path(path)
    do {
      let config = try Config(file: configFile)
      config.lint { level, msg in
        if let idx = missingLogs.index(where: { $0 == level && $1 == msg }) {
          missingLogs.remove(at: idx)
        }
      }
    } catch let e {
      if let idx = missingLogs.index(where: { $0 == .error && $1 == String(describing: e) }) {
        missingLogs.remove(at: idx)
      } else {
        XCTFail("Unexpected error: \(e)", file: file, line: line)
      }
    }
    XCTAssertTrue(
      missingLogs.isEmpty,
      "\(assertionMessage)\n" +
        "The following logs were expected but never received:\n" +
        missingLogs.map({ "\($0) - \($1)" }).joined(separator: "\n"),
      file: file, line: line
    )
  }

  func testLint_AbsolutePathDirect() {
    let commands = ["strings", "fonts", "storyboards", "colors", "xcassets"]
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
    let commands = ["strings", "fonts", "storyboards", "colors", "xcassets"]
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
      expectedLogs: [(.error, "Missing entry for key strings.paths.")],
      assertionMessage: "Linter should warn when 'paths' key is missing"
    )
  }

  func testLintMissingTemplateNameAndPath() {
    let errorMsg = "You must specify a template name (-t) or path (-p).\n\n" +
    "To list all the available named templates, use 'swiftgen templates list'."
    _testLint(
      fixture: "config-missing-template",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when neither 'templateName' nor 'templatePath' keys are present"
    )
  }

  func testLintBothTemplateNameAndPath() {
    let errorMsg = "You need to choose EITHER a named template OR a template path. " +
    "Found name 'template' and path 'template.swift'"
    _testLint(
      fixture: "config-both-templates",
      expectedLogs: [(.error, errorMsg)],
      assertionMessage: "Linter should warn when both 'templateName' and 'templatePath' keys are present"
    )
  }

  func testLintMissingOutput() {
    _testLint(
      fixture: "config-missing-output",
      expectedLogs: [(.error, "Missing entry for key strings.output.")],
      assertionMessage: "Linter should warn when 'output' key is missing"
    )
  }

  func testLintInvalidStructure() {
    _testLint(
      fixture: "config-invalid-structure",
      expectedLogs: [(.error, "Wrong type for key strings.paths: expected Path or array of Paths, got Array<Any>.")],
      assertionMessage: "Linter should warn when config file structure is invalid"
    )
  }

  func testLintInvalidTemplateValue() {
    _testLint(
      fixture: "config-invalid-template",
      expectedLogs: [(.error, "Wrong type for key strings.templateName: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'template' key is of unexpected type"
    )
  }

  func testLintInvalidOutput() {
    _testLint(
      fixture: "config-invalid-output",
      expectedLogs: [(.error, "Wrong type for key strings.output: expected String, got Array<Any>.")],
      assertionMessage: "Linter should warn when the 'output' key is of unexpected type"
    )
  }
}
