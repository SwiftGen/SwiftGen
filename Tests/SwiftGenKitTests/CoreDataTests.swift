//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import SwiftGenKit
import XCTest

class CoreDataTests: XCTestCase {
  func testEmpty() throws {
    let parser = try CoreData.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .coreData)
  }

  func testDefaults() throws {
    let parser = try CoreData.Parser()
    do {
      try parser.searchAndParse(path: Fixtures.path(for: "Model.xcdatamodeld", sub: .coreData))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .coreData)
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try CoreData.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }
}
