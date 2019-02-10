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
}
