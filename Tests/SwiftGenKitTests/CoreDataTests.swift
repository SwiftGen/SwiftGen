//
//  CoreDataTests.swift
//  SwiftGen UnitTests
//
//  Created by Grant Butler on 7/31/18.
//  Copyright © 2018 AliSoftware. All rights reserved.
//

@testable import SwiftGenKit
import XCTest

class CoreDataTests: XCTestCase {
  func testEmpty() {
    let parser = CoreData.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .coreData)
  }

  func testDefaults() {
    let parser = CoreData.Parser()
    do {
      try parser.parse(path: Fixtures.path(for: "Model.xcdatamodeld", sub: .coreData))
    } catch {
      print("Error: \(error.localizedDescription)")
    }

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .coreData)
  }
}
