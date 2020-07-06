//
// SwiftGen UnitTests
// Copyright © 2020 SwiftGen
// MIT Licence
//

import PathKit
import XCTest

final class ConfigReadTests: XCTestCase {
  private lazy var bundle = Bundle(for: type(of: self))

  func testConfigWithParams() throws {
    guard let path = bundle.path(forResource: "config-with-params", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      XCTAssertNil(config.inputDir)
      XCTAssertEqual(config.outputDir, "Common/Generated")

      XCTAssertEqual(config.commandNames, ["strings"])
      let stringEntries = config.entries(for: "strings")
      XCTAssertEqual(stringEntries.count, 1)
      guard let entry = stringEntries.first else {
        return XCTFail("Expected a single strings entry")
      }

      XCTAssertEqual(entry.inputs, ["Sources1/Folder"])
      XCTAssertEqual(entry.filter, ".*\\.strings")

      XCTAssertEqual(entry.outputs.count, 1)
      guard let output = entry.outputs.first else {
        return XCTFail("Expected a single strings entry output")
      }
      XCTAssertEqualDict(
        output.parameters,
        [
          "foo": 5,
          "bar": ["bar1": 1, "bar2": 2, "bar3": [3, 4, ["bar3a": 50]]],
          "baz": ["Hey", "$HELLO world"]
        ]
      )
      XCTAssertEqual(output.output, "strings.swift")
      XCTAssertEqual(output.template, .name("structured-swift5"))
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testConfigWithENVS() throws {
    guard let paramsConfigFilePath = bundle.path(forResource: "config-with-params", ofType: "yml"),
      let envConfigFilePath = bundle.path(forResource: "config-with-env-placeholder", ofType: "yml") else {
      fatalError("Fixture not found")
    }

    let paramsFile = Path(paramsConfigFilePath)
    let envFile = Path(envConfigFilePath)

    do {
      let paramsConfig = try Config(file: paramsFile)
      let envConfig = try Config(
        file: envFile,
        env: ["SWIFTGEN_OUTPUT_DIR": "Common/Generated", "HELLO": "Hey"]
      )

      XCTAssertEqual(paramsConfig.outputDir, envConfig.outputDir)
      guard let paramsList = paramsConfig.entries(for: "strings").first?.outputs.first?.parameters["baz"] as? [String],
        let envList = envConfig.entries(for: "strings").first?.outputs.first?.parameters["baz"] as? [String] else {
        return XCTFail("Could not find strings entry output")
      }
      XCTAssertEqual(paramsList, envList)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testConfigWithMultiEntries() throws {
    guard let path = bundle.path(forResource: "config-with-multi-entries", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      XCTAssertEqual(config.inputDir, "Fixtures/")
      XCTAssertEqual(config.outputDir, "Generated/")

      XCTAssertEqual(config.commandNames, ["strings", "xcassets"])

      // strings
      let stringsEntries = config.entries(for: "strings")
      XCTAssertEqual(stringsEntries.count, 1, "Expected a config entry for strings")

      XCTAssertEqual(stringsEntries[0].inputs, ["Strings/Localizable.strings"])
      XCTAssertEqual(stringsEntries[0].outputs.count, 1)
      XCTAssertEqual(stringsEntries[0].outputs[0].output, "strings.swift")
      XCTAssertEqualDict(stringsEntries[0].outputs[0].parameters, ["enumName": "Loc"])
      XCTAssertEqual(stringsEntries[0].outputs[0].template, .path("templates/custom-swift5"))

      // xcassets
      let xcassetsEntries = config.entries(for: "xcassets")
      XCTAssertEqual(xcassetsEntries.count, 3, "Expected a config entry for xcassets")

      // > xcassets[0]
      XCTAssertEqual(xcassetsEntries[0].inputs, ["XCAssets/Colors.xcassets"])
      XCTAssertEqual(xcassetsEntries[0].outputs.count, 1)
      XCTAssertEqual(xcassetsEntries[0].outputs[0].output, "assets-colors.swift")
      XCTAssertEqualDict(xcassetsEntries[0].outputs[0].parameters, [:])
      XCTAssertEqual(xcassetsEntries[0].outputs[0].template, .name("swift5"))
      // > xcassets[1]
      XCTAssertEqual(xcassetsEntries[1].inputs, ["XCAssets/Images.xcassets"])
      XCTAssertEqual(xcassetsEntries[1].outputs.count, 1)
      XCTAssertEqual(xcassetsEntries[1].outputs[0].output, "assets-images.swift")
      XCTAssertEqualDict(xcassetsEntries[1].outputs[0].parameters, ["enumName": "Pics"])
      XCTAssertEqual(xcassetsEntries[1].outputs[0].template, .name("custom-swift5"))
      // > xcassets[2]
      XCTAssertEqual(xcassetsEntries[2].inputs, ["XCAssets/Colors.xcassets", "XCAssets/Images.xcassets"])
      XCTAssertEqual(xcassetsEntries[2].outputs.count, 1)
      XCTAssertEqual(xcassetsEntries[2].outputs[0].output, "assets-all.swift")
      XCTAssertEqualDict(xcassetsEntries[2].outputs[0].parameters, [:])
      XCTAssertEqual(xcassetsEntries[2].outputs[0].template, .name("swift5"))
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testConfigWithMultiOutputs() throws {
    guard let path = bundle.path(forResource: "config-with-multi-outputs", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      XCTAssertEqual(config.inputDir, "Fixtures/")
      XCTAssertEqual(config.outputDir, "Generated/")

      XCTAssertEqual(config.commandNames, ["ib"])

      // ib
      let ibEntries = config.entries(for: "ib")
      XCTAssertEqual(ibEntries.count, 1, "Expected a config entry for ib")

      XCTAssertEqual(ibEntries[0].inputs, ["IB-iOS"])
      // > outputs[0]
      XCTAssertEqual(ibEntries[0].outputs.count, 2)
      XCTAssertEqual(ibEntries[0].outputs[0].template, .name("scenes-swift5"))
      XCTAssertEqual(ibEntries[0].outputs[0].output, "ib-scenes.swift")
      XCTAssertEqualDict(ibEntries[0].outputs[0].parameters, ["enumName": "Scenes"])
      // > outputs[1]
      XCTAssertEqual(ibEntries[0].outputs[1].template, .name("segues-swift5"))
      XCTAssertEqual(ibEntries[0].outputs[1].output, "ib-segues.swift")
      XCTAssertEqualDict(ibEntries[0].outputs[1].parameters, [:])
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  // MARK: - Invalid configs

  func testInvalidConfigThrows() {
    let badConfigs = [
      "config-missing-paths": "Missing entry for key strings.inputs.",
      "config-missing-template": """
        You must specify a template by name (templateName) or path (templatePath).

        To list all the available named templates, use 'swiftgen template list'.
        """,
      "config-both-templates": """
        You need to choose EITHER a named template OR a template path. \
        Found name 'template' and path 'template.swift'
        """,
      "config-missing-output": "Missing entry for key strings.outputs.output.",
      "config-invalid-structure": """
        Wrong type for key strings.inputs: expected String or Array of String, got Array<Any>.
        """,
      "config-invalid-template": "Wrong type for key strings.outputs.templateName: expected String, got Array<Any>.",
      "config-invalid-output": "Wrong type for key strings.outputs.output: expected String, got Array<Any>."
    ]
    for (configFile, expectedError) in badConfigs {
      do {
        guard let path = bundle.path(forResource: configFile, ofType: "yml") else {
          fatalError("Fixture not found")
        }
        _ = try Config(file: Path(path))
        XCTFail(
          """
          Trying to parse config file \(configFile) should have thrown \
          error \(expectedError) but didn't throw at all
          """
        )
      } catch let error {
        XCTAssertEqual(
          String(describing: error),
          expectedError,
          """
          Trying to parse config file \(configFile) should have thrown \
          error \(expectedError) but threw \(error) instead.
          """
        )
      }
    }
  }

  // MARK: - Deprecations

  func testDeprecatedOutput() throws {
    guard let path = bundle.path(forResource: "config-deprecated-output", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      guard let entry = config.entries(for: "strings").first else {
        return XCTFail("Strings entry not found")
      }

      XCTAssertEqual(entry.outputs.count, 1)
      guard let output = entry.outputs.first else {
        return XCTFail("Expected a single strings entry output")
      }
      XCTAssertEqualDict(output.parameters, ["foo": "baz"])
      XCTAssertEqual(output.output, "my-strings.swift")
      XCTAssertEqual(output.template, .name("structured-swift4"))
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testDeprecatedPaths() throws {
    guard let path = bundle.path(forResource: "config-deprecated-paths", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      guard let entry = config.entries(for: "strings").first else {
        return XCTFail("Strings entry not found")
      }

      XCTAssertEqual(entry.inputs, ["Sources2/Folder"])
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testDeprecatedUseNewerProperties() throws {
    guard let path = bundle.path(forResource: "config-deprecated-mixed-with-new", ofType: "yml") else {
      fatalError("Fixture not found")
    }
    let file = Path(path)
    do {
      let config = try Config(file: file)

      XCTAssertNil(config.inputDir)
      XCTAssertEqual(config.outputDir, "Common/Generated")

      XCTAssertEqual(config.commandNames, ["strings"])
      let stringEntries = config.entries(for: "strings")
      XCTAssertEqual(stringEntries.count, 2, "Expected 2 config entry for strings")

      // > strings[0]
      XCTAssertEqual(stringEntries[0].inputs, ["new-inputs1"])
      XCTAssertEqual(stringEntries[0].outputs.count, 1)
      XCTAssertEqualDict(stringEntries[0].outputs[0].parameters, ["foo": "new-param1"])
      XCTAssertEqual(stringEntries[0].outputs[0].output, "new-output1")
      XCTAssertEqual(stringEntries[0].outputs[0].template, .name("new-templateName1"))

      // > strings[1]
      XCTAssertEqual(stringEntries[1].inputs, ["new-inputs2"])
      XCTAssertEqual(stringEntries[1].outputs.count, 1)
      XCTAssertEqualDict(stringEntries[1].outputs[0].parameters, ["foo": "new-param2"])
      XCTAssertEqual(stringEntries[1].outputs[0].output, "new-output2")
      XCTAssertEqual(stringEntries[1].outputs[0].template, .path("new-templatePath2"))
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }
}
