//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenCLI
import TestUtils
import XCTest

final class ConfigGenerateFileListTests: XCTestCase {
  private lazy var resourcesPath: Path = {
    let resources = Fixtures.resourceDirectory().parent().string
    let current = Path.current.string
    return Path(String(resources.dropFirst(current.count + 1)))
  }()

  // MARK: - Inputs

  func testGenerateInputs1() throws {
    let file = Fixtures.config(for: "config-absolute-paths-direct")
    do {
      let config = try Config(file: file)
      let fileList = try config.inputXCFileList()
      XCTAssertEqual(fileList, """
      # colors
      /colors/templates.stencil

      # fonts
      /fonts/templates.stencil

      # ib
      /ib/templates.stencil

      # strings
      /strings/templates.stencil

      # xcassets
      /xcassets/templates.stencil
      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testGenerateInputs2() throws {
    let file = Fixtures.config(for: "config-with-multi-entries")
    do {
      let config = try Config(file: file)
      let fileList = try config.inputXCFileList()
      XCTAssertEqual(fileList, """
      # strings
      $(SRCROOT)/\(resourcesPath)/Configs/Fixtures/Strings/Localizable.strings
      templates/custom-swift5

      # xcassets
      $(SRCROOT)/\(resourcesPath)/Configs/Fixtures/XCAssets/Colors.xcassets
      $(SRCROOT)/\(resourcesPath)/Configs/Fixtures/XCAssets/Images.xcassets
      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testGenerateInputs3() throws {
    let file = Fixtures.config(for: "config-with-multi-outputs")
    do {
      let config = try Config(file: file)
      let fileList = try config.inputXCFileList()
      XCTAssertEqual(fileList, """
      # ib

      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  // MARK: - Outputs

  func testGenerateOutputs1() throws {
    let file = Fixtures.config(for: "config-absolute-paths-direct")
    do {
      let config = try Config(file: file)
      let fileList = try config.outputXCFileList()
      XCTAssertEqual(fileList, """
      # colors
      /colors/out.swift

      # fonts
      /fonts/out.swift

      # ib
      /ib/out.swift

      # strings
      /strings/out.swift

      # xcassets
      /xcassets/out.swift
      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testGenerateOutputs2() throws {
    let file = Fixtures.config(for: "config-with-multi-entries")
    do {
      let config = try Config(file: file)
      let fileList = try config.outputXCFileList()
      XCTAssertEqual(fileList, """
      # strings
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/strings.swift

      # xcassets
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/assets-all.swift
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/assets-colors.swift
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/assets-images.swift
      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }

  func testGenerateOutputs3() throws {
    let file = Fixtures.config(for: "config-with-multi-outputs")
    do {
      let config = try Config(file: file)
      let fileList = try config.outputXCFileList()
      XCTAssertEqual(fileList, """
      # ib
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/ib-scenes.swift
      $(SRCROOT)/\(resourcesPath)/Configs/Generated/ib-segues.swift
      """)
    } catch let error {
      XCTFail("Error: \(error)")
    }
  }
}
